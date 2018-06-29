//
//  HKImage.m
//  HKApp
//
//  Created by 虎克 on 2016/12/10.
//  Copyright © 2016年 虎克. All rights reserved.
//

#import "JWImage.h"
#import <Accelerate/Accelerate.h>

@implementation JWImage


/**
 毛玻璃

 @param image image
 @param blur 透明度
 @return 毛玻璃效果
 */
+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}

/**
 颜色图片

 @param color 颜色值
 @return 纯色图片
 */
+(UIImage *)imageWithColor:(UIColor *)color
{
    CGSize size = CGSizeMake(5, 5);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


/**
 黑色透明度图片

 @param imageAlpha 透明度
 @return 透明度纯黑色图片
 */
+(UIImage *)halfAlphaBlackImage:(CGFloat)imageAlpha color:(UIColor *)color{
    CGSize imageSize = CGSizeMake(50, 50);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
//    [[UIColor colorWithRed:0 green:0 blue:0 alpha:imageAlpha] set];
    [[color colorWithAlphaComponent:imageAlpha] set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pressedColorImg;
}

/**
 压缩图片

 @param originImage image
 @param newSize 新size
 @return 压缩后的图片
 */
+(UIImage*)imageWith:(UIImage*)originImage scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [originImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


/**
 设置image的alpha

 @param alpha 透明度
 @param image image
 @return newImage
 */
+(UIImage *)imageByApplyingAlpha:(CGFloat)alpha image:(UIImage*)image{
    UIGraphicsBeginImageContextWithOptions(image.size,NO, 0.0f);
    CGContextRef ctx =UIGraphicsGetCurrentContext();
    CGRect area =CGRectMake(0,0, image.size.width, image.size.height);
    CGContextScaleCTM(ctx,1, -1);
    CGContextTranslateCTM(ctx,0, -area.size.height);
    CGContextSetBlendMode(ctx,kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, image.CGImage);
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

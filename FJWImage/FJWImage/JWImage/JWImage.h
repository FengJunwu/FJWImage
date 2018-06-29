//
//  HKImage.h
//  HKApp
//
//  Created by 虎克 on 2016/12/10.
//  Copyright © 2016年 虎克. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface JWImage : UIImage
/**
 毛玻璃
 
 @param image image
 @param blur 透明度
 @return 毛玻璃效果
 */
+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

/**
 颜色图片
 
 @param color 颜色值
 @return 纯色图片
 */
+(UIImage *)imageWithColor:(UIColor *)color;

/**
 黑色透明度图片
 
 @param imageAlpha 透明度
 @return 透明度纯黑色图片
 */
+(UIImage *)halfAlphaBlackImage:(CGFloat)imageAlpha color:(UIColor *)color;

/**
 压缩图片
 
 @param originImage image
 @param newSize 新size
 @return 压缩后的图片
 */
+(UIImage*)imageWith:(UIImage*)originImage scaledToSize:(CGSize)newSize;

/**
 设置image的alpha
 
 @param alpha 透明度
 @param image image
 @return newImage
 */
+(UIImage *)imageByApplyingAlpha:(CGFloat)alpha image:(UIImage*)image;

@end

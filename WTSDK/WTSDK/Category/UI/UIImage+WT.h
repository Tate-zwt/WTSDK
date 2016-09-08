//
//  UIImage+WT.h
//  WTSDK
//
//  Created by 张威庭 on 15/12/16.
//  Copyright © 2015年 zwt. All rights reserved.
//

#import <UIKit/UIKit.h>

static const void *completeBlockKey = &completeBlockKey;
static const void *failBlockKey = &failBlockKey;

@interface UIImage ()

@property (nonatomic, copy) void (^completeBlock)();

@property (nonatomic, copy) void (^failBlock)();

@end

@interface UIImage (WT)

/**
 *  截屏吧 截部分视图也行
 */
+ (UIImage *)captureWithView:(UIView *)view;
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;

/**
 *  纯色图片
 */
+ (UIImage *)coloreImage:(UIColor *)color;
+ (UIImage *)coloreImage:(UIColor *)color size:(CGSize)size;

/**
 *  按固定的最大比例压缩图片
 */
- (UIImage *)allowMaxImg;
- (UIImage *)allowMaxImg_thum:(BOOL)thumbnail;

/**
 *  图片要求的最大长宽
 */
- (CGSize)reSetMaxWH:(CGFloat)WH;

/**
 *  按比例 重设图片大小
 */
- (UIImage *)resize_Rate:(CGFloat)rate;
/**
 *  按比例 质量 重设图片大小
 */
- (UIImage *)resize_Quality:(CGInterpolationQuality)quality rate:(CGFloat)rate;

/**
 *  保存到指定相册名字
 */
- (void)savedToAlbum_AlbumName:(NSString *)albumName sucBlack:(void (^)())completeBlock failBlock:(void (^)())failBlock;

/**
 *  保存到相册
 */
- (void)savedToAlbum:(void (^)())completeBlock failBlock:(void (^)())failBlock;

/**
 *  水印方向
 */
typedef NS_ENUM(NSInteger, ImageWaterDirect) {
    //左上
    ImageWaterDirectTopLeft = 0,
    //右上
    ImageWaterDirectTopRight,
    //左下
    ImageWaterDirectBottomLeft,
    //右下
    ImageWaterDirectBottomRight,
    //正中
    ImageWaterDirectCenter
    
};

/**
 *  加水印
 */
- (UIImage *)waterWithText:(NSString *)text direction:(ImageWaterDirect)direction fontColor:(UIColor *)fontColor fontPoint:(CGFloat)fontPoint marginXY:(CGPoint)marginXY;

/**
 *  加水印
 */
- (UIImage *)waterWithWaterImage:(UIImage *)waterImage direction:(ImageWaterDirect)direction waterSize:(CGSize)waterSize marginXY:(CGPoint)marginXY;

- (UIImage *)fixOrientation;

@end

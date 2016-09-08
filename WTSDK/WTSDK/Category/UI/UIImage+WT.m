//
//  UIImage+WT.m
//  WTSDK
//
//  Created by 张威庭 on 15/12/16.
//  Copyright © 2015年 zwt. All rights reserved.
//

#import "UIImage+WT.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <objc/runtime.h>
@implementation UIImage (WT)

/**
 *  截屏吧 截部分视图也行
 */
+ (UIImage *)captureWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [UIScreen mainScreen].scale);
    
    // IOS7及其后续版本
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [self methodSignatureForSelector:
                                     @selector(drawViewHierarchyInRect:afterScreenUpdates:)]];
        [invocation setTarget:self];
        [invocation setSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)];
        CGRect arg2 = view.bounds;
        BOOL arg3 = YES;
        [invocation setArgument:&arg2 atIndex:2];
        [invocation setArgument:&arg3 atIndex:3];
        [invocation invoke];
    } else { // IOS7之前的版本
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    //    CGImageRelease(sourceImageRef);
    CGImageRelease(newImageRef);
    return newImage;
}

/**
 *  纯色图片
 */
+ (UIImage *)coloreImage:(UIColor *)color size:(CGSize)size {
    CGRect rect = (CGRect){{0.0f, 0.0f}, size};
    //开启一个图形上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    //获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    //获取图像
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)coloreImage:(UIColor *)color {
    CGSize size = CGSizeMake(1.0f, 1.0f);
    return [self coloreImage:color size:size];
}

/**
 *  按比例 重设图片大小
 */
- (UIImage *)resize_Rate:(CGFloat)rate {
    return [self resize_Quality:kCGInterpolationNone rate:rate];
}
/**
 *  按比例 质量 重设图片大小
 */
- (UIImage *)resize_Quality:(CGInterpolationQuality)quality rate:(CGFloat)rate {
    UIImage *resized = nil;
    CGFloat width = self.size.width * rate;
    CGFloat height = self.size.height * rate;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [self drawInRect:CGRectMake(0, 0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resized;
}

- (UIImage *)allowMaxImg {
    return [self allowMaxImg_thum:NO];
}

/**
 *  按最大比例压缩图片
 */
- (UIImage *)allowMaxImg_thum:(BOOL)thumbnail {
    if (self == nil) {
        return nil;
    }
    CGFloat height = self.size.height;
    CGFloat width = self.size.width;
    CGFloat Max_H_W = 800; //要显示的图片 我能容忍的 最大长或宽（800）
    if (thumbnail) {
        Max_H_W = 150; //thumbnail（缩略图时） 最大长或宽
    }
    if ((MAX(height, width)) < (Max_H_W)) {
        return self; //不需要再改了
    }
    if (MAX(height, width) > Max_H_W) { //超过了限制 按比例压缩长宽
        CGFloat Max = MAX(height, width);
        height = height * (Max_H_W / Max);
        width = width * (Max_H_W / Max);
    }
    UIImage *newimage;
    UIGraphicsBeginImageContext(CGSizeMake((int) width, (int) height));
    [self drawInRect:CGRectMake(0, 0, (int) width, (int) height)];
    newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}

//图片要求的最大长宽
- (CGSize)reSetMaxWH:(CGFloat)WH {
    if (self == nil) {
        return CGSizeZero;
    }
    CGFloat height = self.size.height / self.scale;
    CGFloat width = self.size.width / self.scale;
    CGFloat Max_H_W = WH; //要显示的图片 我能容忍的 最大长或宽（）
    if ((MAX(height, width)) < (Max_H_W)) {
        return self.size; //不需要再改了
    }
    if (MAX(height, width) > Max_H_W) { //超过了限制 按比例压缩长宽
        CGFloat Max = MAX(height, width);
        height = height * (Max_H_W / Max);
        width = width * (Max_H_W / Max);
    }
    return CGSizeMake(width, height);
}

#pragma mark -

/**
 *  保存到指定相册名字
 */
- (void)savedToAlbum_AlbumName:(NSString *)albumName sucBlack:(void (^)())completeBlock failBlock:(void (^)())failBlock {
    ALAssetsLibrary *ass = [[ALAssetsLibrary alloc] init];
    [ass writeImageToSavedPhotosAlbum:self.CGImage orientation:(ALAssetOrientation) self.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        __block BOOL albumWasFound = NO;
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        //search all photo albums in the library
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            //判断相册是否存在
            if ([albumName compare:[group valueForProperty:ALAssetsGroupPropertyName]] == NSOrderedSame) {
                //存在
                albumWasFound = YES;
                [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    if ([group addAsset:asset]) {
                        completeBlock();
                    }
                }
                              failureBlock:^(NSError *error) {
                                  failBlock();
                              }];
                return;
            }
            //如果不存在该相册创建
            if (group == nil && albumWasFound == NO) {
                __weak ALAssetsLibrary *weakSelf = assetsLibrary;
                //创建相册
                [assetsLibrary addAssetsGroupAlbumWithName:albumName resultBlock:^(ALAssetsGroup *group) {
                    [weakSelf assetForURL:assetURL
                              resultBlock:^(ALAsset *asset) {
                                  if ([group addAsset:asset]) {
                                      completeBlock();
                                  }
                              }
                             failureBlock:^(NSError *error) {
                                 failBlock();
                             }];
                }
                                              failureBlock:^(NSError *error) {
                                                  failBlock();
                                              }];
                return;
            }
        }
                                   failureBlock:^(NSError *error) {
                                       failBlock();
                                   }];
    }];
}

/**
 *  保存相册
 *
 *  @param completeBlock 成功回调
 *  @param completeBlock 出错回调
 */
- (void)savedToAlbum:(void (^)())completeBlock failBlock:(void (^)())failBlock {
    UIImageWriteToSavedPhotosAlbum(self, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    self.completeBlock = completeBlock;
    self.failBlock = failBlock;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        if (self.completeBlock != nil) self.completeBlock();
    } else {
        if (self.failBlock != nil) self.failBlock();
    }
}

/*
 *  模拟成员变量
 */
- (void (^)())failBlock {
    return objc_getAssociatedObject(self, failBlockKey);
}
- (void)setfailBlock:(void (^)())failBlock {
    objc_setAssociatedObject(self, failBlockKey, failBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void (^)())completeBlock {
    return objc_getAssociatedObject(self, completeBlockKey);
}

- (void)setcompleteBlock:(void (^)())completeBlock {
    objc_setAssociatedObject(self, completeBlockKey, completeBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - function😇

/**
 *  加水印
 */
- (UIImage *)waterWithText:(NSString *)text direction:(ImageWaterDirect)direction fontColor:(UIColor *)fontColor fontPoint:(CGFloat)fontPoint marginXY:(CGPoint)marginXY {
    CGSize size = self.size;
    CGRect rect = (CGRect){CGPointZero, size};
    //新建图片图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    //绘制图片
    [self drawInRect:rect];
    //绘制文本
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:fontPoint], NSForegroundColorAttributeName : fontColor};
    CGRect strRect = [self calWidth:text attr:attr direction:direction rect:rect marginXY:marginXY];
    [text drawInRect:strRect withAttributes:attr];
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //结束图片图形上下文
    UIGraphicsEndImageContext();
    return newImage;
}

- (CGRect)calWidth:(NSString *)str attr:(NSDictionary *)attr direction:(ImageWaterDirect)direction rect:(CGRect)rect marginXY:(CGPoint)marginXY {
    CGSize size = [str sizeWithAttributes:attr];
    CGRect calRect = [self rectWithRect:rect size:size direction:direction marginXY:marginXY];
    return calRect;
}

- (CGRect)rectWithRect:(CGRect)rect size:(CGSize)size direction:(ImageWaterDirect)direction marginXY:(CGPoint)marginXY {
    CGPoint point = CGPointZero;
    //右上
    if (ImageWaterDirectTopRight == direction) point = CGPointMake(rect.size.width - size.width, 0);
    //左下
    if (ImageWaterDirectBottomLeft == direction) point = CGPointMake(0, rect.size.height - size.height);
    //右下
    if (ImageWaterDirectBottomRight == direction) point = CGPointMake(rect.size.width - size.width, rect.size.height - size.height);
    //正中
    if (ImageWaterDirectCenter == direction) point = CGPointMake((rect.size.width - size.width) * .5f, (rect.size.height - size.height) * .5f);
    point.x += marginXY.x;
    point.y += marginXY.y;
    CGRect calRect = (CGRect){point, size};
    return calRect;
}

/**
 *  加水印
 */
- (UIImage *)waterWithWaterImage:(UIImage *)waterImage direction:(ImageWaterDirect)direction waterSize:(CGSize)waterSize marginXY:(CGPoint)marginXY {
    CGSize size = self.size;
    CGRect rect = (CGRect){CGPointZero, size};
    //新建图片图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    //绘制图片
    [self drawInRect:rect];
    //计算水印的rect
    CGSize waterImageSize = CGSizeEqualToSize(waterSize, CGSizeZero) ? waterImage.size : waterSize;
    CGRect calRect = [self rectWithRect:rect size:waterImageSize direction:direction marginXY:marginXY];
    //绘制水印图片
    [waterImage drawInRect:calRect];
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //结束图片图形上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end

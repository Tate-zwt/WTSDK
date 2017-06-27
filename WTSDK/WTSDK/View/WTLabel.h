//
//  WTLabel.h
//  PicMovie
//
//  Created by 张威庭 on 2017/6/27.
//  Copyright © 2017年 PicMovie. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM (NSInteger, WTTextAlignmentType)   {
    
    WTTextAlignmentTypeLeftTop = 0,
    
    WTTextAlignmentTypeRightTop = 1,
    
    WTTextAlignmentTypeLeftBottom = 2,
    
    WTTextAlignmentTypeRightBottom = 3,
    
    WTTextAlignmentTypeTopCenter = 4,
    
    WTTextAlignmentTypeBottomCenter = 5,
    
    WTTextAlignmentTypeLeft = 6,
    
    WTTextAlignmentTypeRight = 7,
    
    WTTextAlignmentTypeCenter = 8,
    
};
@interface WTLabel : UILabel
@property (nonatomic,assign) WTTextAlignmentType textAlignmentType;
@end

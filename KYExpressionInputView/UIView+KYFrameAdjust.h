//
//  UIView+Frame.h
//  feeling
//
//  Created by 郭帅 on 15/8/24.
//  Copyright (c) 2015年 isaced. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (KYFrameAdjust)

- (CGFloat) x;

- (void) setX:(CGFloat)x;

- (CGFloat) y;

- (void) setY:(CGFloat)y;

- (CGFloat) width;

- (void) setWidth:(CGFloat)width;

- (CGFloat) height;

- (void) setHeight:(CGFloat)height;

/**
 *  计算宽高比
 *
 *  @return width/height
 */
- (CGFloat) aspectRatio;

@end

//
//  UIView+FeelingShadow.h
//  feeling
//
//  Created by com.feeling on 15/5/13.
//  Copyright (c) 2015年 isaced. All rights reserved.
//

/**
 *
 * 包含一个1像素Shadow的View
 *
 */

#import <UIKit/UIKit.h>

@interface UIView (KYShadow)

- (void) addShadowWithColor:(UIColor *)color;

- (void) addTopShadowWithColor:(UIColor *)color;

- (void) addLeftShadowWithColor:(UIColor *)color;

- (void) addRightShadowWithColor:(UIColor *)color;
@end

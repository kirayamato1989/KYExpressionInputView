//
//  UIView+FeelingShadow.m
//  feeling
//
//  Created by com.feeling on 15/5/13.
//  Copyright (c) 2015年 isaced. All rights reserved.
//

#import "UIView+KYShadow.h"
#import "KYExpressionConstant.h"

@implementation UIView (KYShadow)

-(void)addShadowWithColor:(UIColor *)color{
    UIView *shadow = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1)];
    shadow.backgroundColor = color?:UIColorFromRGB(0xe5e5e5);
    shadow.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    [self addSubview:shadow];
}

- (void)addTopShadowWithColor:(UIColor *)color{
    UIView *shadow = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
    shadow.backgroundColor = color?:UIColorFromRGB(0xe5e5e5);
    shadow.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
    [self addSubview:shadow];
}

- (void)addLeftShadowWithColor:(UIColor *)color {
    UIView *shadow = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, self.bounds.size.height)];
    shadow.backgroundColor = color?:UIColorFromRGB(0xe5e5e5);
    shadow.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleHeight;
    [self addSubview:shadow];
}

- (void)addRightShadowWithColor:(UIColor *)color {
    UIView *shadow = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.width-1, 1, self.bounds.size.height)];
    shadow.backgroundColor = color?:UIColorFromRGB(0xe5e5e5);
    shadow.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleHeight;
    [self addSubview:shadow];
}

@end

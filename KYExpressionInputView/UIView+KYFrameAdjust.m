//
//  UIView+Frame.m
//  feeling
//
//  Created by 郭帅 on 15/8/24.
//  Copyright (c) 2015年 isaced. All rights reserved.
//

#import "UIView+KYFrameAdjust.h"

@implementation UIView (KYFrameAdjust)

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}


- (CGFloat)aspectRatio {
    return self.width/self.height;
}


@end

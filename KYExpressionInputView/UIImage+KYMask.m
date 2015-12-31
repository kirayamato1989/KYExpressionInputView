//
//  UIImage+Mask.m
//  KYCustomExpressionView
//
//  Created by YamatoKira on 15/11/3.
//  Copyright © 2015年 YamatoKira. All rights reserved.
//

#import "UIImage+KYMask.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation UIImage (KYMask)

+ (UIImage *)ky_maskImage:(UIImage *)image color:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(image.size, 1, image.scale);
    
    [image drawAtPoint:CGPointZero];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [color setFill];
    
    CGContextFillRect(context, CGRectMake(0, 0, image.size.width, image.size.height));
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end

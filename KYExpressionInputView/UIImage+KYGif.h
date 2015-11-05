//
//  UIImage+KYGif.h
//  KYCustomExpressionView
//
//  Created by YamatoKira on 15/11/2.
//  Copyright © 2015年 YamatoKira. All rights reserved.
//

// 感谢SDWebImage

#import <UIKit/UIKit.h>

@interface UIImage (KYGif)

+ (UIImage *)ky_animatedGIFWithData:(NSData *)data;

@end

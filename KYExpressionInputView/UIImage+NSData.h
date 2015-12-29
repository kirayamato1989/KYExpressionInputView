//
//  UIImage+NSData.h
//  KYExpressionInputViewDemo
//
//  Created by YamatoKira on 15/12/29.
//  Copyright © 2015年 YamatoKira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NSData)

+ (NSData *)convertImageIntoData:(UIImage *)image error:(NSError *__autoreleasing *)error;

@end

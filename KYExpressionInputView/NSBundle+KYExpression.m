//
//  NSBundle+KYExpression.m
//  KYExpressionInputViewDemo
//
//  Created by YamatoKira on 2017/9/19.
//  Copyright © 2017年 YamatoKira. All rights reserved.
//

#import "NSBundle+KYExpression.h"
#import "KYExpressionInputView.h"

@implementation NSBundle (KYExpression)

+ (NSBundle *)kye_bundle {
    NSBundle *classBundle = [NSBundle bundleForClass:[KYExpressionInputView class]];
    NSString *path = [classBundle.resourcePath stringByAppendingPathComponent:@"KYExpressionBundle.bundle"];
    return [NSBundle bundleWithPath:path];
}

@end

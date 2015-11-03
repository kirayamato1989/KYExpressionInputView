//
//  NSData+KYImageContentType.h
//  KYCustomExpressionView
//
//  Created by YamatoKira on 15/11/2.
//  Copyright © 2015年 YamatoKira. All rights reserved.
//

// 感谢SDWebImage

#import <Foundation/Foundation.h>

@interface NSData (KYImageContentType)

+ (NSString *)contentTypeForImageData:(NSData *)data;

@end

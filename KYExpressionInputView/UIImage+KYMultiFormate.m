//
//  UIImage+KYMultiFormate.m
//  KYCustomExpressionView
//
//  Created by YamatoKira on 15/11/2.
//  Copyright © 2015年 YamatoKira. All rights reserved.
//

#import "UIImage+KYMultiFormate.h"
#import "NSData+KYImageContentType.h"
#import "UIImage+KYGif.h"

@implementation UIImage (KYMultiFormate)

+ (instancetype)ky_multiImageWithData:(NSData *)data {
    NSString *contentType = [NSData contentTypeForImageData:data];
    
    UIImage *image = nil;
    
    if ([contentType isEqualToString:@"image/gif"]) {
        image = [UIImage ky_animatedGIFWithData:data];
    }
    else {
        image = [UIImage imageWithData:data];
    }
    return image;
}

@end

//
//  UIImage+NSData.m
//  KYExpressionInputViewDemo
//
//  Created by YamatoKira on 15/12/29.
//  Copyright © 2015年 YamatoKira. All rights reserved.
//

#import "UIImage+KYNSData.h"
#import <objc/runtime.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/UTCoreTypes.h>

static char *kUIImageDataKey;

@implementation UIImage (KYNSData)

+ (NSData *)convertImageIntoData:(UIImage *)image error:(NSError *__autoreleasing *)error {
    if (!image) {
        return nil;
    }
    
    NSData *data = [image imageData];
    
    if (data) {
        return data;
    }
    
    if (image.images.count <= 1) {
        data = UIImageJPEGRepresentation(image, 0.9);
    }
    else {
        size_t frameCount = image.images.count;
        
        NSMutableData *mutableData = [NSMutableData data];
        CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)mutableData, kUTTypeGIF, frameCount, NULL);
        
        NSDictionary *imageProperties = @{ (__bridge NSString *)kCGImagePropertyGIFDictionary: @{
                                                   (__bridge NSString *)kCGImagePropertyGIFLoopCount: @(0)
                                                   }
                                           };
        CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)imageProperties);
        
        for (size_t idx = 0; idx < image.images.count; idx++) {
            CGFloat duration = [image.images[idx] duration];
            NSDictionary *frameProperties = @{
                                              (__bridge NSString *)kCGImagePropertyGIFDictionary: @{
                                                      (__bridge NSString *)kCGImagePropertyGIFDelayTime: @(duration)
                                                      }
                                              };
            
            CGImageDestinationAddImage(destination, [[image.images objectAtIndex:idx] CGImage], (__bridge CFDictionaryRef)frameProperties);
        }
        
        BOOL success = CGImageDestinationFinalize(destination);
        CFRelease(destination);
        
        if (!success) {
            *error = [[NSError alloc] initWithDomain:@"com.feeling.errorDomain" code:1 userInfo:@{@"description":@"convert into data failed"}];
            
            NSLog(@"convertIntoData failed");
        }
        data = [NSData dataWithData:mutableData];
    }
    
    [image setImageData:data];
    
    return data;
}

- (void)setImageData:(NSData *)data {
    objc_setAssociatedObject(self, kUIImageDataKey, data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSData *)imageData {
    return objc_getAssociatedObject(self, kUIImageDataKey);
}

@end

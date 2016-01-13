//
//  KYExpressionItem.m
//  KYCustomExpressionView
//
//  Created by YamatoKira on 15/11/2.
//  Copyright © 2015年 YamatoKira. All rights reserved.
//

#import "KYExpressionItem.h"
#import "UIImage+KYMultiFormate.h"
#import "NSData+KYImageContentType.h"
#import "UIImage+KYNSData.h"
#import "KYExpressionConstant.h"


@interface KYExpressionItem ()

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, strong) NSData *imageData;

@property (nonatomic, assign) KYExpressionDataType dataType;

@end

@implementation KYExpressionItem

+ (instancetype)itemWithImage:(UIImage *)image url:(NSString *)url {
    NSAssert(image||url, @"image and url can not both be nil");
    return [[self alloc] initWithImage:image url:url];
}

+ (instancetype)itemWithImageData:(NSData *)data url:(NSString *)url {
    NSAssert(data||url, @"data and url can not both be nil");
    return [[self alloc] initWithImageData:data url:url];
}

+ (instancetype)itemWithEmoji:(NSString *)emoji {
    return [[self alloc] initWithEmoji:emoji];
}

+ (instancetype)deleteItem {
    NSString *path = [kExpressionBundle pathForResource:@"ky_expression_delete" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    image = [UIImage imageWithCGImage:image.CGImage scale:[UIScreen mainScreen].scale orientation:image.imageOrientation];
    KYExpressionItem *item = [self itemWithImage:image url:nil];
    item.dataType = kExpressionDataTypeDelete;
    return item;
}

- (instancetype)initWithImage:(UIImage *)image url:(NSString *)url {
    NSAssert(image||url, @"image and url can not both be nil");
    if (self = [super init]) {
        _image = image;
        _imageUrl = url.copy;
        if (image.images.count>1) {
            _dataType = kExpressionDataTypeGif;
        }
        else{
            _dataType = kExpressionDataTypeImage;
        }
    }
    return self;
}

- (instancetype)initWithImageData:(NSData *)data url:(NSString *)url {
    if (self = [super init]) {
        _image = [UIImage ky_multiImageWithData:data];
        _imageUrl = url.copy;
        _imageData = data;
        
        if (_image.images.count>1) {
            _dataType = kExpressionDataTypeGif;
        }
        else{
            _dataType = kExpressionDataTypeImage;
        }
    }
    return self;
}

- (instancetype)initWithEmoji:(NSString *)emoji {
    if (self = [super init]) {
        _text = emoji.copy;
        _dataType = kExpressionDataTypeEmoji;
    }
    return self;
}

#pragma mark KYExpressionData

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.image forKey:NSStringFromSelector(@selector(image))];
    [aCoder encodeObject:@(self.dataType) forKey:NSStringFromSelector(@selector(dataType))];
    [aCoder encodeObject:self.code forKey:NSStringFromSelector(@selector(code))];
    [aCoder encodeObject:self.text forKey:NSStringFromSelector(@selector(text))];
    [aCoder encodeObject:self.imageUrl forKey:NSStringFromSelector(@selector(imageUrl))];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        if (aDecoder) {
            _image = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(image))];
            _dataType = [[aDecoder decodeObjectForKey:NSStringFromSelector(@selector(dataType))] unsignedIntegerValue];
            _code = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(code))];
            _text = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(text))];
            _imageUrl = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(imageUrl))];
        }
    }
    return self;
}

- (NSData *)imageData {
    if (!_imageData) {
        if (self.dataType == kExpressionDataTypeGif) {
            _imageData = [UIImage convertImageIntoData:self.image error:nil];
        }
        else{
            _imageData = UIImageJPEGRepresentation([self image], 1.0);
        }
    }
    return _imageData;
}

#pragma mark public method
- (void)imageUploadCompleteWithUrlString:(NSString *)url {
    self.imageUrl = url;
}

@end

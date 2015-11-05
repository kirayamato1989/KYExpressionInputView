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
#import "KYExpressionConstant.h"

@interface KYExpressionItem ()

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, copy) NSString *storeKey;

@property (nonatomic, strong) NSData *imageData;

@property (nonatomic, assign) KYExpressionDataType dataType;

@end

@implementation KYExpressionItem

+ (instancetype)itemWithImage:(UIImage *)image url:(NSString *)url {
    NSAssert(image, @"image can not be nil");
    return [[self alloc] initWithImage:image url:url];
}

+ (instancetype)itemWithData:(NSData *)data url:(NSString *)url {
    NSAssert(data, @"data can not be nil");
    return [[self alloc] initWithData:data url:url];
}

+ (instancetype)itemWithEmoji:(NSString *)emoji {
    return [[self alloc] initWithEmoji:emoji];
}

+ (instancetype)deleteItem {
    NSString *path = [kExpressionBundle pathForResource:@"expression_delete" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    image = [UIImage imageWithCGImage:image.CGImage scale:[UIScreen mainScreen].scale orientation:image.imageOrientation];
    KYExpressionItem *item = [self itemWithImage:image url:nil];
    item.dataType = kExpressionDataTypeDelete;
    return item;
}

- (instancetype)initWithImage:(UIImage *)image url:(NSString *)url {
    NSAssert(image, @"image can not be nil");
    if (self = [super init]) {
        _image = image;
        _imageUrl = url.copy;
        if (image.images.count>1) {
            _dataType = kExpressionDataTypeGif;
        }
        else{
            _dataType = kExpressionDataTypeImage;
        }
        [self configStoreKey:nil];
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data url:(NSString *)url {
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
        
        [self configStoreKey:nil];
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

- (KYExpressionItem *)configStoreKey:(NSString *)key {
    if (!key) {
        NSDate *now = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"YYYY/MM/dd_HH_mm_ss";
        key = [NSString stringWithFormat:@"KYExpression_%@",[formatter stringFromDate:now]];
    }
    _storeKey = key.copy;
    return self;
}

- (NSData *)imageData {
    if (!_imageData) {
        if (self.dataType == kExpressionDataTypeGif) {
            
        }
        else{
            _imageData = UIImageJPEGRepresentation([self image], 1.0);
        }
    }
    return _imageData;
}

@end

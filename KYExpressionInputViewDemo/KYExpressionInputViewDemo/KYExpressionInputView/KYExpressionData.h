//
//  KYExpressionData.h
//  KYCustomExpressionView
//
//  Created by YamatoKira on 15/11/2.
//  Copyright © 2015年 YamatoKira. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, KYExpressionDataType) {
    kExpressionDataTypeNone,
    kExpressionDataTypeEmoji,  //emoji表情
    kExpressionDataTypeImage,  //静态图片
    kExpressionDataTypeGif,    //gif动图
    kExpressionDataTypeDelete,  //默认的删除按钮
};

@protocol KYExpressionData <NSObject>

- (KYExpressionDataType)dataType;

@optional

- (UIImage *)image;

- (NSData *)imageData;

- (NSString *)storeKey;

- (NSString *)code;

- (NSString *)text;

- (NSString *)imageUrl;

@end

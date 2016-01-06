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
    kExpressionDataTypeDelete,  //默认的删除按钮
    kExpressionDataTypeImage,  //静态图片
    kExpressionDataTypeGif,    //gif动图
};

typedef void (^KY_expressionImageDownloadCompletion)(UIImage *image, NSError *error);

@protocol KYExpressionData <NSObject, NSCoding>

- (KYExpressionDataType)dataType;

@optional

- (UIImage *)image;

- (NSData *)imageData;

- (NSString *)code;

- (NSString *)text;

- (NSString *)imageUrl;

- (void)setImageDownloadCompletion:(KY_expressionImageDownloadCompletion)handler;

@end

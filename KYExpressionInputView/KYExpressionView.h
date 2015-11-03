//
//  FaceView.h
//  feeling
//
//  Created by com.feeling on 15/7/11.
//  Copyright (c) 2015年 isaced. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYExpressionData.h"

#define kFaceViewWH 50
@class KYExpressionView,KYExpressionItem;

typedef NS_ENUM(NSInteger, ExpressionViewType) {
    ExpressionViewTypeNone,
    ExpressionViewTypeCustomImage,  //自定义表情
    ExpressionViewTypeBag, //表情包
};

typedef void (^ExpressionTapBlock) (id<KYExpressionData> expressionItem);

@interface KYExpressionView : UIView

@property (nonatomic, assign) ExpressionViewType type;

@property (nonatomic, strong) id<KYExpressionData> item;

+ (instancetype)expressionViewWithItem:(id<KYExpressionData>)item;

- (instancetype)initWithItem:(id<KYExpressionData>)item;

- (void) setTapBlock:(ExpressionTapBlock)block;

@end

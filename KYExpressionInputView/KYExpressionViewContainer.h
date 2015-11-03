//
//  FaceCustomContainer.h
//  feeling
//
//  Created by com.feeling on 15/7/12.
//  Copyright (c) 2015年 isaced. All rights reserved.
//

/**
 *  自定义表情的容器View
 */

#import <UIKit/UIKit.h>
#import "KYExpressionData.h"
#import "KYExpressionContainerLayout.h"

@class KYExpressionInputView;

typedef void (^KYExpressionTapBlock) (id<KYExpressionData>expression);

typedef NS_ENUM(NSUInteger, KYExpressionViewContainerType) {
    kExpressionViewContainerTypeNone,
    kExpressionViewContainerTypeEmoji,
    kExpressionViewContainerTypeCustom,
    kExpressionViewContainerTypePackage,
};

@interface KYExpressionViewContainer : UIView

@property (nonatomic, copy) KYExpressionTapBlock block;

@property (nonatomic, weak) KYExpressionInputView *inputView;

@property (nonatomic, assign) KYExpressionViewContainerType containerType;



- (void)setItems:(NSArray *)items;

/**
 *  添加自定义表情
 *
 *  @param image 图片实例
 */
- (void)addExpressionItem:(id<KYExpressionData>)item;


- (KYExpressionContainerLayout *)layout;

- (void)updateUI;

@end

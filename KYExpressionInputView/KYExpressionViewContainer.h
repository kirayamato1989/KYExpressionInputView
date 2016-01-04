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

@class KYExpressionInputView,KYExpressionViewContainer;

typedef void (^KYExpressionTapBlock) (id<KYExpressionData>expression, NSUInteger index, KYExpressionViewContainer *container);

@interface KYExpressionViewContainer : UIView

@property (nonatomic, copy) KYExpressionTapBlock block;

@property (nonatomic, weak) KYExpressionInputView *inputView;


+ (instancetype)containerWithLayout:(KYExpressionContainerLayout *)layout items:(NSArray <id<KYExpressionData>>*)items;


- (NSArray <id<KYExpressionData>>*)items;


- (void)setItems:(NSArray <id<KYExpressionData>>*)items;

/**
 *  添加自定义表情
 *
 *  @param image 图片实例
 */
- (void)addExpressionItem:(id<KYExpressionData>)item;

/**
 *  删除自定义表情
 *
 *  @param indexSet 索引
 */
- (void)removeItemsAtIndexSet:(NSIndexSet *)indexSet;

/**
 *  获取表情布局layout
 */
- (KYExpressionContainerLayout *)layout;


/**
 *  用新的layout去更新当前的layout
 */
- (void)updateLayoutByLayout:(KYExpressionContainerLayout *)newLayout;


@end

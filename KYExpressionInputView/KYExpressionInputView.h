//
//  FaceInputView.h
//  feeling
//
//  Created by YamatoKira 2015/11/2.
//  Copyright (c) 2015年 KiraYamato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYExpressionToolbar.h"
#import "KYExpressionData.h"
#import "KYExpressionPackageProtocol.h"
#import "KYExpressionViewContainer.h"


@class KYExpressionInputView;

@protocol KYExpressionInputViewDelegate <NSObject>
@optional
- (void)inputView:(KYExpressionInputView *)inputView didSelectExpression:(id<KYExpressionData>)expression atIndex:(NSUInteger)index container:(KYExpressionViewContainer *)container;

- (void)inputView:(KYExpressionInputView *)inputView didClickSendButton:(UIButton *)button;

@end

@interface KYExpressionInputView : UIView

@property (nonatomic, readonly) KYExpressionToolbar *toolbar;

// Colors
@property (nonatomic, strong) UIColor *toolbarColor;

@property (nonatomic, strong) UIColor *senderButtonColor;

@property (nonatomic, assign) KYFloatOrientation itemSpacing;

@property (nonatomic, assign) KYSizeOrientation itemSize;

@property (nonatomic, assign) KYFloatOrientation lineSpacing;

@property (nonatomic, assign) id<KYExpressionInputViewDelegate> delegate;

@property (nonatomic, weak) UITextView *textView;


// Boolens

// default NO, when YES the emoji will hide
@property (nonatomic, assign) BOOL hiddenEmoji;

// default NO, when YES the toolBar will hide
@property (nonatomic, assign) BOOL hiddenToolBar;


/**
 * 更新某个container的itemSize
 *
 *  @param itemSize new value
 *  @param index
 */
- (void)updateItemSize:(KYSizeOrientation)itemSize conatinerAtIndex:(NSUInteger)index;

/**
 *  更新某个container的itemSpacing
 *
 *  @param itemSpacing
 *  @param index       
 */
- (void)updateItemSpacing:(KYFloatOrientation)itemSpacing containerAtIndex:(NSUInteger)index;

/**
 *  隐藏和显示发送按钮
 *
 *  @param hidden
 *  @param animated
 */
- (void)setToolbarSendButtonHidden:(BOOL)hidden animated:(BOOL)animated;

/**
 *  获取expressionViewContainer
 *
 *  @param index 
 *
 *  @return
 */
- (KYExpressionViewContainer *)containerViewAtIndex:(NSUInteger)index;


/**
 *  修改发送按钮状态
 *
 *  @param enable
 */
- (void)toggleSendButtonEnable:(BOOL)enable;

/**
 *  给某个container添加表情
 *
 *  @param expression 
 *  @param index
 */
- (void)addCustomExpression:(id<KYExpressionData>)expression indexOfConatiner:(NSUInteger)index;




- (void)addToolbarItemWithImage:(UIImage *)image
                           title:(NSString *)title
                           items:(NSArray<id<KYExpressionData>> *)items;



- (void)addToolbarItemWithImage:(UIImage *)image
                           title:(NSString *)title
                           items:(NSArray<id<KYExpressionData>> *)items
                             row:(KYUIntegerOrientation)row
                          column:(KYUIntegerOrientation)column
                        itemSize:(KYSizeOrientation)itemSize
                    itemSpacing:(KYFloatOrientation)itemSpacing
                    lineSpacing:(KYFloatOrientation)lineSpacing
                    textPercent:(CGFloat)percent
                 backgroundColor:(UIColor *)color
                     borderWidth:(CGFloat)width;


- (void)addToolbarItemWithImage:(UIImage *)image
                          title:(NSString *)title
              expressionPackage:(id<KYExpressionPackageProtocol>)package;


- (void)addToolbarItemWithImage:(UIImage *)image
                          title:(NSString *)title
                      container:(KYExpressionViewContainer *)container ;

@end

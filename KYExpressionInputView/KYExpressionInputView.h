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
- (void) inputView:(KYExpressionInputView *)inputView didSelectExpression:(id<KYExpressionData>)expression;

- (void) inputView:(KYExpressionInputView *)inputView didClickSendButton:(UIButton *)button;

@end

@interface KYExpressionInputView : UIView

// Colors
@property (nonatomic, strong) UIColor *toolbarColor;

@property (nonatomic, strong) UIColor *expressionContainerColor;

@property (nonatomic, strong) UIColor *senderButtonColor;

@property (nonatomic, assign) CGFloat itemSpacing;

@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, assign) id<KYExpressionInputViewDelegate> delegate;

@property (nonatomic, weak) UITextView *textView;


// Boolens

// default NO, when YES the emoji will hide
@property (nonatomic, assign) BOOL hiddenEmoji;

// default NO, when YES the toolBar will hide
@property (nonatomic, assign) BOOL hiddenToolBar;


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
 *  添加自定义表情
 *
 *  @param image
 */
- (void)addCustomExpressionImage:(UIImage *)image;




- (void)addToolbarItemWithImage:(UIImage *)image
                           title:(NSString *)title
                           items:(NSArray<id<KYExpressionData>> *)items;



- (void)addToolbarItemWithImage:(UIImage *)image
                           title:(NSString *)title
                           items:(NSArray<id<KYExpressionData>> *)items
                             row:(NSUInteger)row
                          column:(NSUInteger)column
                        itemSize:(CGSize)itemSize
                     itemSpacing:(CGFloat)itemSpacing;


- (void)addToolbarItemWithImage:(UIImage *)image
                          title:(NSString *)title
              expressionPackage:(id<KYExpressionPackageProtocol>)package;

@end

//
//  FaceToolbar.h
//  feeling
//
//  Created by com.feeling on 15/7/11.
//  Copyright (c) 2015年 isaced. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^sendButtonClickBlock) (UIButton *button);

typedef void (^selectedIndexChangeBlock) (NSUInteger index);

@interface KYExpressionToolbar : UIView

@property (nonatomic, copy) sendButtonClickBlock sendBlock;

@property (nonatomic, copy) selectedIndexChangeBlock selectBlock;

@property (nonatomic, assign, readonly) NSUInteger selectedIndex;

- (void)setSendButtonHidden:(BOOL)hidden animated:(BOOL)animated;

- (void)toggleSendButtonEnable:(BOOL)enable;

- (void)addItemWithImage:(UIImage *)image title:(NSString *)title;

- (void)removeItemAtIndex:(NSUInteger)index;

- (void)setSelectedIndex:(NSUInteger)index;

@end

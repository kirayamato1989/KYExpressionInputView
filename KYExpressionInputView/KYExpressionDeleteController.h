//
//  FaceDeleteCustomController.h
//  feeling
//
//  Created by com.feeling on 15/7/13.
//  Copyright (c) 2015年 isaced. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DeleteSelectedImagesBlock) (NSIndexSet *indexSet);
typedef void (^CancelBlock)();

@interface KYExpressionDeleteController : UIViewController

- (instancetype) initWithImages:(NSArray *)array;

- (void)showWithAnimated:(BOOL)animated;

- (void)setDeleteBlock:(DeleteSelectedImagesBlock)block;

- (void)setCancelBlock:(CancelBlock)block;

@end

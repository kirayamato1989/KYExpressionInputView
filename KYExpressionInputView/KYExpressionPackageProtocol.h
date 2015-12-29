//
//  KYExpressionBagProtocol.h
//  KYCustomExpressionView
//
//  Created by YamatoKira on 15/11/2.
//  Copyright © 2015年 YamatoKira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYExpressionData.h"

@protocol KYExpressionPackageProtocol <NSObject, NSCoding>

- (NSUInteger)numberOfItems;

- (id<KYExpressionData>)itemAtIndex:(NSUInteger)index;

- (NSArray<id<KYExpressionData>> *)items;

/**
 *  标示必须唯一
 */
- (NSString *)identifier;

@optional

- (void)addItem:(id<KYExpressionData>)item;

- (void)insertItem:(id<KYExpressionData>)item AtIndex:(NSUInteger)index;

- (void)deleteItemAtIndex:(NSUInteger)index;

@end


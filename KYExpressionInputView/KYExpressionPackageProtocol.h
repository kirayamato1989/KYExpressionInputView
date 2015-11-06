//
//  KYExpressionBagProtocol.h
//  KYCustomExpressionView
//
//  Created by YamatoKira on 15/11/2.
//  Copyright © 2015年 YamatoKira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYExpressionData.h"

@protocol KYExpressionPackageProtocol <NSObject>

- (NSUInteger)numberOfItems;

- (id<KYExpressionData>)itemAtIndex:(NSUInteger)index;

- (NSArray<id<KYExpressionData>> *)items;

- (NSString *)identifier;

@end


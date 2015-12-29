//
//  KYExpressionPackage.h
//  KYExpressionInputViewDemo
//
//  Created by YamatoKira on 15/12/29.
//  Copyright © 2015年 YamatoKira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KYExpressionPackageProtocol.h"

@interface KYExpressionPackage : NSObject<KYExpressionPackageProtocol>

+ (instancetype)packageWithItems:(NSArray<id<KYExpressionData>> *)items identifier:(NSString *)identifier;

@end

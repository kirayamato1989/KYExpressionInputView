//
//  KYCustomExpressionStore.h
//  KYCustomExpressionView
//
//  Created by YamatoKira on 15/11/2.
//  Copyright © 2015年 YamatoKira. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KYExpressionPackageProtocol.h"

@interface KYExpressionStore : NSObject

+ (instancetype)defaultStore;

- (id<KYExpressionPackageProtocol>)packageForIdentifier:(NSString *)identifier;

- (void)savePackage:(id<KYExpressionPackageProtocol>)package;

- (void)removePackageByIdentifier:(NSString *)identifier;

@end

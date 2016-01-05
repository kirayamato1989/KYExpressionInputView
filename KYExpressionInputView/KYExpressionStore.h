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

- (NSArray<id<KYExpressionPackageProtocol>> *)allPackages;

/**
 *  表情包持久化的文件夹地址（子类可重写）
 */
- (NSString *)cacheDirectoryPath;

/**
 *  清空缓存
 */
- (void)clearCache;

@end

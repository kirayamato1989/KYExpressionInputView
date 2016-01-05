//
//  KYCustomExpressionStore.m
//  KYCustomExpressionView
//
//  Created by YamatoKira on 15/11/2.
//  Copyright © 2015年 YamatoKira. All rights reserved.
//

#import "KYExpressionStore.h"


@interface KYExpressionStore ()

@property (nonatomic, strong) NSCache *cache;

@property (nonatomic, strong) NSMutableArray *identifiers;

@property (nonatomic, strong) dispatch_queue_t saveQueue;

@end

static KYExpressionStore *_defaultStore;

@implementation KYExpressionStore

// 单例
+ (instancetype)defaultStore {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_defaultStore) {
            _defaultStore = [[KYExpressionStore alloc] init];
        }
    });
    return _defaultStore;
}

#pragma mark
- (instancetype)init {
    if (self = [super init]) {
        _cache = [[NSCache alloc] init];
        _saveQueue = dispatch_queue_create("com.KYExpressionStore.save", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark public method

- (void)savePackage:(id<KYExpressionPackageProtocol>)package {
    [self savePackage:package toDisk:YES];
}

- (id<KYExpressionPackageProtocol>)packageForIdentifier:(NSString *)identifier {
    if (![self.cache objectForKey:identifier]) {
        // 去磁盘里面找
        NSString *packagePath = [self cachePathForPackageIdentifier:identifier];
        if ([[NSFileManager defaultManager] fileExistsAtPath:packagePath]) {
            id<KYExpressionPackageProtocol> package = [NSKeyedUnarchiver unarchiveObjectWithFile:packagePath];
            
            // 缓存到内存
            [self.cache setObject:package forKey:identifier];
        }
    }
    return [self.cache objectForKey:identifier];
}

- (void)removePackageByIdentifier:(NSString *)identifier {
    // cache
    [self.cache removeObjectForKey:identifier];
    [self.identifiers removeObject:identifier];
    
    // clean disk
    NSString *cachePath = [self cachePathForPackageIdentifier:identifier];
    [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
    
    dispatch_async(self.saveQueue, ^{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.identifiers];
        [[NSFileManager defaultManager] createFileAtPath:[self cachePlistPath] contents:data attributes:nil];
    });
}

- (NSArray *)allPackages {
    NSMutableArray *packagesArray = [NSMutableArray array];
    for (NSString *identifier in self.identifiers) {
        id<KYExpressionPackageProtocol> package = [self packageForIdentifier:identifier];
        if (package) {
            [packagesArray addObject:package];
        }
    }
    return [NSArray arrayWithArray:packagesArray];
}

- (NSString *)cacheDirectoryPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:[NSString stringWithFormat:@"/KYExpressionPackages/"]];
}

- (void)clearCache {
    [self.cache removeAllObjects];
    self.identifiers = nil;
}

#pragma mark private method

- (void)savePackage:(id<KYExpressionPackageProtocol>)package toDisk:(BOOL)saveDisk {
    [self.cache setObject:package forKey:[package identifier]];
    
    if (saveDisk) {
        dispatch_async(self.saveQueue, ^{
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:package];
            if (data) {
                NSString *cachePath = [self cachePathForPackageIdentifier:[package identifier]];
                BOOL exits = [[NSFileManager defaultManager] fileExistsAtPath:[self cacheDirectoryPath]];
                if (!exits) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:[self cacheDirectoryPath] withIntermediateDirectories:YES attributes:nil error:NULL];
                }
                
                BOOL succeed = [[NSFileManager defaultManager] createFileAtPath:cachePath contents:data attributes:nil];
                if (succeed) {
                    // 更新plist表
                    if (![self.identifiers containsObject:[package identifier]]) {
                        [self.identifiers addObject:[package identifier]];
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.identifiers];
                        [[NSFileManager defaultManager] createFileAtPath:[self cachePlistPath] contents:data attributes:nil];
                    }
                }
            }
        });
    }
}

- (NSString *)cachePathForPackageIdentifier:(NSString *)identifier {
    return [[self cacheDirectoryPath] stringByAppendingPathComponent:identifier];
}

- (NSString *)cachePlistPath {
    return [[self cacheDirectoryPath] stringByAppendingPathComponent:@"package.plist"];
}

- (NSMutableArray *)identifiers {
    if (!_identifiers) {
        _identifiers = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:[self cachePlistPath]]];
    }
    return _identifiers;
}

@end

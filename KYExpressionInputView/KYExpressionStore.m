//
//  KYCustomExpressionStore.m
//  KYCustomExpressionView
//
//  Created by YamatoKira on 15/11/2.
//  Copyright © 2015年 YamatoKira. All rights reserved.
//

#import "KYExpressionStore.h"

static KYExpressionStore *_defaultStore;

@implementation KYExpressionStore

+ (instancetype)defaultStore {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_defaultStore) {
            _defaultStore = [[KYExpressionStore alloc] init];
        }
    });
    return _defaultStore;
}

@end

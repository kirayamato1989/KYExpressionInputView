//
//  KYExpressionPackage.m
//  KYExpressionInputViewDemo
//
//  Created by YamatoKira on 15/12/29.
//  Copyright © 2015年 YamatoKira. All rights reserved.
//

#import "KYExpressionPackage.h"

@interface KYExpressionPackage ()

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, copy) NSString *identifier;

@end

@implementation KYExpressionPackage

#pragma mark inilizer
+ (instancetype)packageWithItems:(NSArray<id<KYExpressionData>> *)items identifier:(NSString *)identifier {
    return [[self alloc] initWithItems:items identifier:identifier];
}

- (instancetype)initWithItems:(NSArray<id<KYExpressionData>> *)items identifier:(NSString *)identifier {
    if (self = [super init]) {
        _items = [NSMutableArray arrayWithArray:items];
        _identifier = identifier.copy;
    }
    return self;
}


#pragma mark KYExpressionPackageProtocol

- (id<KYExpressionData>)itemAtIndex:(NSUInteger)index {
    if (index >= self.items.count) {
        return nil;
    }
    return self.items[index];
}

- (NSUInteger)numberOfItems {
    return self.items.count;
}

- (void)addItem:(id<KYExpressionData>)item {
    [self.items addObject:item];
}

- (void)insertItem:(id<KYExpressionData>)item AtIndex:(NSUInteger)index {
    if (!item) return;
    [self.items insertObject:item atIndex:index];
}

- (void)deleteItemAtIndex:(NSUInteger)index {
    [self.items removeObjectAtIndex:index];
}

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.items forKey:NSStringFromSelector(@selector(items))];
    [aCoder encodeObject:self.identifier forKey:NSStringFromSelector(@selector(identifier))];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        if (aDecoder) {
            _items = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(items))];
            _identifier = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(identifier))];
        }
    }
    return self;
}

@end

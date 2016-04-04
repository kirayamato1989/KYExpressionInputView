//
//  KYExpressionContainerLayout.m
//  KYCustomExpressionView
//
//  Created by YamatoKira on 15/11/2.
//  Copyright © 2015年 YamatoKira. All rights reserved.
//

#import "KYExpressionContainerLayout.h"


inline KYUIntegerOrientation KYUIntegerOrientationMake (NSUInteger portrait ,NSUInteger landscape ) {
    KYUIntegerOrientation value;
    value.uintegerForOrientationPortrait = portrait;
    value.uintegerForOrientationLandscape = landscape;
    return value;
}

inline NSUInteger KYUIntegerForCurrentOrientation (KYUIntegerOrientation value) {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsPortrait(orientation)||orientation == UIDeviceOrientationUnknown) {
        return value.uintegerForOrientationPortrait;
    }
    else{
        return value.uintegerForOrientationLandscape;
    }
}

inline BOOL KYUIntegerIsEqual (KYUIntegerOrientation value1, KYUIntegerOrientation value2)
{
    if (value1.uintegerForOrientationPortrait != value2.uintegerForOrientationPortrait) {
        return NO;
    }
    if (value1.uintegerForOrientationLandscape != value2.uintegerForOrientationLandscape) {
        return NO;
    }
    return YES;
}

inline KYSizeOrientation KYSizeOrientationMake (CGSize portrait, CGSize landscape) {
    KYSizeOrientation size;
    size.sizeForOrientationPortrait = portrait;
    size.sizeForOrientationLandscape = landscape;
    return size;
}

inline KYSizeOrientation KYSizeOrientationMakeWithFloat (CGFloat pw, CGFloat ph, CGFloat lw, CGFloat lh) {
    KYSizeOrientation size;
    CGSize portraitSize = CGSizeMake(pw, ph);
    CGSize landscapeSize = CGSizeMake(lw, lh);
    size.sizeForOrientationPortrait = portraitSize;
    size.sizeForOrientationLandscape = landscapeSize;
    return size;
}


inline CGSize KYSizeForCurrentOrientation (KYSizeOrientation value) {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsPortrait(orientation)||orientation == UIDeviceOrientationUnknown) {
        return value.sizeForOrientationPortrait;
    }
    else{
        return value.sizeForOrientationLandscape;
    }
}

inline BOOL KYSizeIsEqual (KYSizeOrientation value1, KYSizeOrientation value2) {
    
    if (!CGSizeEqualToSize(value1.sizeForOrientationPortrait, value2.sizeForOrientationPortrait)) {
        return NO;
    }
    if (CGSizeEqualToSize(value1.sizeForOrientationLandscape, value2.sizeForOrientationLandscape)) {
        return NO;
    }
    return YES;
}

inline KYFloatOrientation KYFloatOrientationMake (CGFloat portrait, CGFloat landscape) {
    KYFloatOrientation value;
    value.floatForOrientationPortrait = portrait;
    value.floatForOrientationLandscape = landscape;
    return value;
}

inline CGFloat KYFloatForCurrentOrientation (KYFloatOrientation value) {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsPortrait(orientation)||orientation == UIDeviceOrientationUnknown) {
        return value.floatForOrientationPortrait;
    }
    else{
        return value.floatForOrientationLandscape;
    }
}


inline BOOL KYFloatIsEqual(KYFloatOrientation value1, KYFloatOrientation value2) {
    if (value1.floatForOrientationPortrait != value2.floatForOrientationPortrait) {
        return NO;
    }
    if (value1.floatForOrientationLandscape != value2.floatForOrientationLandscape) {
        return NO;
    }
    return YES;
}

@interface KYExpressionContainerLayout ()

@property (nonatomic, strong) NSMutableDictionary *cache;

@property (nonatomic, assign) KYSizeOrientation cachedCollectionViewSize;

@end

@implementation KYExpressionContainerLayout

- (instancetype)init {
    if (self = [super init]) {
        _cache = [NSMutableDictionary dictionaryWithCapacity:2];
        _numberOfRow = KYUIntegerOrientationMake(2, 2);
        _numberOfColumn = KYUIntegerOrientationMake(4, 8);
        _itemSize = KYSizeOrientationMake(CGSizeMake(50, 50), CGSizeMake(50, 50));
        _itemSpacing = KYFloatOrientationMake(10, 10);
    }
    return self;
}

- (void)prepareLayout {
    NSUInteger numberOfItem = [self.collectionView numberOfItemsInSection:0];
    
    UIDeviceOrientation oriention = [[UIDevice currentDevice] orientation];
    
    BOOL isPortrait = UIDeviceOrientationIsPortrait(oriention);
    // 个数有改变
    NSArray *cache = [self cacheForIsPortrait:isPortrait];
    
    if (cache.count != numberOfItem || !CGSizeEqualToSize([self cachedCollectionViewSizeForCurrentOrientation], self.collectionView.bounds.size)) {
        
        [self setCachedCollectionViewSizeForCurrentOrientation:self.collectionView.bounds.size];
        
        NSMutableArray *newCache = [NSMutableArray array];
        
        // 边距
        CGSize itemSize = KYSizeForCurrentOrientation(self.itemSize);
        NSUInteger numberOfRow = KYUIntegerForCurrentOrientation(self.numberOfRow);
        NSUInteger numberOfColumn = KYUIntegerForCurrentOrientation(self.numberOfColumn);
        CGFloat itemSpacing = KYFloatForCurrentOrientation(self.itemSpacing);
        CGFloat lineSpacing = KYFloatForCurrentOrientation(self.lineSpacing);
        
        
        CGFloat topSpacing = (self.collectionView.bounds.size.height - (numberOfRow*itemSize.height + (numberOfRow - 1)*lineSpacing))/2.f;
        
        CGFloat letfSpacing = (self.collectionView.bounds.size.width - (numberOfColumn*itemSize.width + (numberOfColumn - 1)*itemSpacing))/2.f;
        
        // 判断itemSize是否合适
        if (topSpacing<0) {
            itemSize.height -= ceilf(fabs(2*topSpacing)/numberOfRow);
            
            topSpacing = (self.collectionView.bounds.size.height - (numberOfRow*itemSize.height + (numberOfRow - 1)*lineSpacing))/2.f;
        }
        
        if (letfSpacing<0) {
            itemSize.width -= ceilf(fabs(2*letfSpacing)/numberOfColumn);
            
            letfSpacing = (self.collectionView.bounds.size.width - (numberOfColumn*itemSize.width + (numberOfColumn - 1)*itemSpacing))/2.f;
        }
        
        NSUInteger numberOfPage = (numberOfItem/(numberOfRow*numberOfColumn)) + (numberOfItem%(numberOfRow*numberOfColumn)>0?1:0);
        if (isPortrait) {
            KYUIntegerOrientation newValue = self.numberOfPage;
            newValue.uintegerForOrientationPortrait = numberOfPage;
            _numberOfPage = newValue;
        }
        else{
            KYUIntegerOrientation newValue = self.numberOfPage;
            newValue.uintegerForOrientationLandscape = numberOfPage;
            _numberOfPage = newValue;
        }
        
        
        for (int i = 0; i < numberOfItem; i++) {
            //1
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            NSUInteger page = i/(numberOfRow*numberOfColumn);
            
            NSUInteger indexAtPage = i - page * (numberOfColumn * numberOfRow);
            
            NSUInteger row = indexAtPage/numberOfColumn;
            
            NSUInteger column = indexAtPage%numberOfColumn;
            
            attributes.frame = CGRectMake(page * self.collectionView.bounds.size.width + letfSpacing + column*(itemSize.width + itemSpacing) , topSpacing + row*(itemSize.height + lineSpacing), itemSize.width, itemSize.height);

            [newCache addObject:attributes];
        }
        
        [self updateCache:newCache isPortrait:isPortrait];
    }
}


- (CGSize)collectionViewContentSize {
    NSUInteger page = KYUIntegerForCurrentOrientation(self.numberOfPage);
    CGSize contentSize = CGSizeMake(page * self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    return contentSize;
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributesArray = [NSMutableArray array];
    
    for (UICollectionViewLayoutAttributes *attributes in [self cacheForCurrentPortrait]) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [attributesArray addObject:attributes];
        }
    }
    return attributesArray;
}

- (NSArray *)cacheForCurrentPortrait {
    UIDeviceOrientation oriention = [[UIDevice currentDevice] orientation];
    
    BOOL isPortrait = UIDeviceOrientationIsPortrait(oriention);
    
    return [self cacheForIsPortrait:isPortrait];
}

- (NSArray *)cacheForIsPortrait:(BOOL)b {
    NSString *key = b?@"portrait":@"landscape";
    return self.cache[key];
}

- (void)updateCache:(NSArray *)newValue isPortrait:(BOOL)b {
    NSString *key = b?@"portrait":@"landscape";
    
    NSMutableArray *array = self.cache[key];
    
    if (!array) {
        array = [NSMutableArray array];
        self.cache[key] = array;
    }
    [array removeAllObjects];
    [array addObjectsFromArray:newValue];
}


- (void)setItemSize:(KYSizeOrientation)itemSize {
    if (!KYSizeIsEqual(_itemSize, itemSize)) {
        _itemSize = itemSize;
        [self.cache removeAllObjects];
        
        [self.collectionView reloadData];
    }
}

- (void)setItemSpacing:(KYFloatOrientation)itemSpacing {
    if (!KYFloatIsEqual(_itemSpacing, itemSpacing)) {
        _itemSpacing = itemSpacing;
        [self.cache removeAllObjects];
        
        [self.collectionView reloadData];
    }
}

- (void)setNumberOfRow:(KYUIntegerOrientation)numberOfRow {
    if (!KYUIntegerIsEqual(_numberOfRow, numberOfRow)) {
        _numberOfRow = numberOfRow;
        
        [self.cache removeAllObjects];
        
        [self.collectionView reloadData];
    }
}

- (void)setNumberOfColumn:(KYUIntegerOrientation)numberOfColumn {
    if (!KYUIntegerIsEqual(_numberOfColumn, numberOfColumn)) {
        _numberOfColumn = numberOfColumn;
        
        [self.cache removeAllObjects];
        
        [self.collectionView reloadData];
    }
}

- (void)setCachedCollectionViewSizeForCurrentOrientation:(CGSize)size {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsPortrait(orientation)) {
        _cachedCollectionViewSize.sizeForOrientationPortrait = size;
    }
    else {
        _cachedCollectionViewSize.sizeForOrientationLandscape = size;
    }
}

- (CGSize)cachedCollectionViewSizeForCurrentOrientation {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsPortrait(orientation)) {
        return _cachedCollectionViewSize.sizeForOrientationPortrait;
    }
    else {
        return _cachedCollectionViewSize.sizeForOrientationLandscape;
    }
}

@end

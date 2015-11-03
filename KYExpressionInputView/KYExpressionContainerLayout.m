//
//  KYExpressionContainerLayout.m
//  KYCustomExpressionView
//
//  Created by YamatoKira on 15/11/2.
//  Copyright © 2015年 YamatoKira. All rights reserved.
//

#import "KYExpressionContainerLayout.h"

@interface KYExpressionContainerLayout ()

@property (nonatomic, strong) NSMutableArray *cache;

@property (nonatomic, assign) CGSize cachedCollectionViewSize;

@end

@implementation KYExpressionContainerLayout

- (instancetype)init {
    if (self = [super init]) {
        _numberOfRow = 2;
        _numberOfColumn = 4;
        _itemSize = CGSizeMake(60, 60);
        _itemSpacing = 10;
    }
    return self;
}

- (void)prepareLayout {
    NSUInteger numberOfItem = [self.collectionView numberOfItemsInSection:0];
    
    // 个数有改变
    if (self.cache.count != numberOfItem || !CGSizeEqualToSize(self.cachedCollectionViewSize, self.collectionView.bounds.size)) {
        
        self.cachedCollectionViewSize = self.collectionView.bounds.size;
        
        // 为空
        if (!self.cache) {
            self.cache = [NSMutableArray array];
        }
        
        // 清空
        [self.cache removeAllObjects];
        
        // 边距
        CGFloat topSpacing = (self.collectionView.bounds.size.height - (self.numberOfRow*self.itemSize.height + (self.numberOfRow - 1)*self.itemSpacing))/2.f;
        
        CGFloat letfSpacing = (self.collectionView.bounds.size.width - (self.numberOfColumn*self.itemSize.width + (self.numberOfColumn - 1)*self.itemSpacing))/2.f;
        
        CGSize itemSize = self.itemSize;
        
        // 判断itemSize是否合适
        if (topSpacing<0) {
            itemSize.height -= ceilf(fabs(2*topSpacing)/self.numberOfRow);
            
            topSpacing = (self.collectionView.bounds.size.height - (self.numberOfRow*itemSize.height + (self.numberOfRow - 1)*self.itemSpacing))/2.f;
        }
        
        if (letfSpacing<0) {
            itemSize.width -= ceilf(fabs(2*letfSpacing)/self.numberOfColumn);
            
            letfSpacing = (self.collectionView.bounds.size.width - (self.numberOfColumn*itemSize.width + (self.numberOfColumn - 1)*self.itemSpacing))/2.f;
        }
        
        NSAssert(self.numberOfColumn*self.numberOfRow, @"row or column can not be zero");
        
        self.numberOfPage = (numberOfItem/(self.numberOfRow*self.numberOfColumn)) + (numberOfItem%(self.numberOfRow*self.numberOfColumn)>0?1:0);
        
        for (int i = 0; i < numberOfItem; i++) {
            //1
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            NSUInteger page = i/(self.numberOfRow*self.numberOfColumn);
            
            NSUInteger indexAtPage = i - page * (self.numberOfColumn * self.numberOfRow);
            
            NSUInteger row = indexAtPage/self.numberOfColumn;
            
            NSUInteger column = indexAtPage%self.numberOfColumn;
            
            attributes.frame = CGRectMake(page * self.collectionView.bounds.size.width + letfSpacing + column*(itemSize.width + self.itemSpacing) , topSpacing + row*(itemSize.height + self.itemSpacing), itemSize.width, itemSize.height);

            [self.cache addObject:attributes];
        }
    }
}


- (CGSize)collectionViewContentSize {
    CGSize contentSize = CGSizeMake(self.numberOfPage * self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    return contentSize;
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributesArray = [NSMutableArray array];
    
    for (UICollectionViewLayoutAttributes *attributes in self.cache) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [attributesArray addObject:attributes];
        }
    }
    return attributesArray;
}

- (void)setItemSize:(CGSize)itemSize {
    if (!CGSizeEqualToSize(_itemSize, itemSize)) {
        _itemSize = itemSize;
        [self.cache removeAllObjects];
        
        [self.collectionView reloadData];
    }
}

- (void)setItemSpacing:(CGFloat)itemSpacing {
    if (_itemSpacing != itemSpacing) {
        _itemSpacing = itemSpacing;
        [self.cache removeAllObjects];
        
        [self.collectionView reloadData];
    }
}

- (void)setNumberOfRow:(NSUInteger)numberOfRow {
    if (_numberOfRow != numberOfRow) {
        _numberOfRow = numberOfRow;
        
        [self.cache removeAllObjects];
        
        [self.collectionView reloadData];
    }
}

- (void)setNumberOfColumn:(NSUInteger)numberOfColumn {
    if (_numberOfColumn != numberOfColumn) {
        _numberOfColumn = numberOfColumn;
        
        [self.cache removeAllObjects];
        
        [self.collectionView reloadData];
    }
}

@end

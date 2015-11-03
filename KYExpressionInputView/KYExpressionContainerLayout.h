//
//  KYExpressionContainerLayout.h
//  KYCustomExpressionView
//
//  Created by YamatoKira on 15/11/2.
//  Copyright © 2015年 YamatoKira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYExpressionContainerLayout : UICollectionViewLayout

/**
 *  每页表情行数
 */
@property (nonatomic, assign) NSUInteger numberOfRow;

/**
 *  每页表情列数
 */
@property (nonatomic, assign) NSUInteger numberOfColumn;

/**
 *  表情的页数
 */
@property (nonatomic, assign) NSUInteger numberOfPage;

/**
 *  表情间距
 */
@property (nonatomic, assign) CGFloat itemSpacing;

/**
 * 每个表情的Size
 */
@property (nonatomic, assign) CGSize itemSize;


//@property (nonatomic, assign) CGFloat

@end

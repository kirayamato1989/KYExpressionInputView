//
//  KYExpressionContainerLayout.h
//  KYCustomExpressionView
//
//  Created by YamatoKira on 15/11/2.
//  Copyright © 2015年 YamatoKira. All rights reserved.
//

#import <UIKit/UIKit.h>

struct KYUIntegerOrientation {
    NSUInteger uintegerForOrientationPortrait;
    NSUInteger uintegerForOrientationLandscape;
};

typedef struct KYUIntegerOrientation KYUIntegerOrientation;

KYUIntegerOrientation KYUIntegerOrientationMake(NSUInteger, NSUInteger);

NSUInteger KYUIntegerForCurrentOrientation(KYUIntegerOrientation);

BOOL KYUIntegerIsEqual(KYUIntegerOrientation, KYUIntegerOrientation);



struct KYSizeOrientation {
    CGSize sizeForOrientationPortrait;
    CGSize sizeForOrientationLandscape;
};

typedef struct KYSizeOrientation KYSizeOrientation;

KYSizeOrientation KYSizeOrientationMake(CGSize, CGSize);

CGSize KYSizeForCurrentOrientation(KYSizeOrientation);

BOOL KYSizeIsEqual(KYSizeOrientation, KYSizeOrientation);



struct KYFloatOrientation {
    CGFloat floatForOrientationPortrait;
    CGFloat floatForOrientationLandscape;
};
typedef struct KYFloatOrientation KYFloatOrientation;

KYFloatOrientation KYFloatOrientationMake(CGFloat, CGFloat);

CGFloat KYFloatForCurrentOrientation(KYFloatOrientation);

BOOL KYFloatIsEqual(KYFloatOrientation, KYFloatOrientation);

@interface KYExpressionContainerLayout : UICollectionViewLayout

/**
 *  每页表情行数
 */
@property (nonatomic, assign) KYUIntegerOrientation numberOfRow;

/**
 *  每页表情列数
 */
@property (nonatomic, assign) KYUIntegerOrientation numberOfColumn;

/**
 *  表情的页数
 */
@property (nonatomic, assign) KYUIntegerOrientation numberOfPage;

/**
 *  表情间距
 */
@property (nonatomic, assign) KYFloatOrientation itemSpacing;

/**
 * 每个表情的Size
 */
@property (nonatomic, assign) KYSizeOrientation itemSize;


@end

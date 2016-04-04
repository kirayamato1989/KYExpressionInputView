//
//  FaceCustomContainer.m
//  feeling
//
//  Created by com.feeling on 15/7/12.
//  Copyright (c) 2015年 isaced. All rights reserved.
//

#import "KYExpressionViewContainer.h"
#import "KYExpressionInputView.h"
#import "KYExpressionItem.h"
#import "KYExpressionContainerLayout.h"
#import "KYExpressionConstant.h"

@interface KYExpressionCollectionViewCell : UICollectionViewCell


@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) id<KYExpressionData> expressionItem;

@property (nonatomic, weak) KYExpressionContainerLayout *layout;

@end

@implementation KYExpressionCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.clipsToBounds = YES;
        self.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        
        //
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
        
        //
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        _textLabel.textColor = UIColorFromRGB(0x333333);
        
        _textLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.borderWidth = self.layout.borderWidth;
    
    CGFloat textHeightPercent = self.layout.textHeightPercent;
    
    switch ([self.expressionItem dataType]) {
        case kExpressionDataTypeEmoji:
            // adjust font to the cell bounds
            _textLabel.font = [UIFont systemFontOfSize:MIN(self.bounds.size.width, self.bounds.size.height)/2];
            
            textHeightPercent = 1;
            
            break;
        case kExpressionDataTypeImage:
        case kExpressionDataTypeGif:
            self.textLabel.font = [UIFont systemFontOfSize:self.bounds.size.height * textHeightPercent];
            break;
        case kExpressionDataTypeDelete:
            textHeightPercent = 0;
            break;
        default:
            break;
    }
    
    CGFloat textHeight = self.bounds.size.height * textHeightPercent;
    
    CGFloat imageViewHeight = self.bounds.size.height * (1 - textHeightPercent);
    
    _imageView.frame = CGRectMake(0, 0, self.bounds.size.width, imageViewHeight);
    
    _textLabel.frame = CGRectMake(0, CGRectGetMaxY(_imageView.frame), self.bounds.size.width, textHeight);
}

- (void)setExpressionItem:(id<KYExpressionData>)expressionItem {
    if (_expressionItem != expressionItem) {
        _expressionItem = expressionItem;
        
        _imageView.image = nil;
        
        _textLabel.text = nil;
        
        switch ([expressionItem dataType]) {
            case kExpressionDataTypeEmoji:
                _textLabel.text = [expressionItem text];
                break;
            case kExpressionDataTypeImage:
            case kExpressionDataTypeGif:
                _imageView.contentMode = UIViewContentModeScaleAspectFit;
                _imageView.image = [expressionItem image];
                _textLabel.text = [expressionItem text];
                break;
            case kExpressionDataTypeDelete:
                _imageView.contentMode = UIViewContentModeCenter;
                _imageView.image = [expressionItem image];
            default:
                break;
        }
        
        // 异步加载图片
        if ([expressionItem respondsToSelector:@selector(setImageDownloadCompletion:)]) {
            __weak typeof(self) weakSelf = self;
            [expressionItem setImageDownloadCompletion:^(UIImage *image, NSError *error) {
                if (weakSelf.expressionItem == expressionItem) {
                    if (image) {
                        _imageView.image = image;
                        [weakSelf setNeedsLayout];
                    }
                }
            }];
        }
        
        [self setNeedsLayout];
    }
}

@end


@interface KYExpressionViewContainer () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *expressionCollectionView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSString *cachePath;

@property (nonatomic, strong) dispatch_queue_t diskQueue;
/**
 *  存储的是所有图片的
 */
@property (nonatomic, strong) NSMutableArray *dataArray;


@property (nonatomic, weak) KYExpressionContainerLayout *layout;

@end

@implementation KYExpressionViewContainer

+ (instancetype)containerWithLayout:(KYExpressionContainerLayout *)layout items:(NSArray<id<KYExpressionData>> *)items {
    KYExpressionViewContainer *container = [[KYExpressionViewContainer alloc] initWithFrame:CGRectMake(0, 0, 320, 219)];
    [container setLayout:layout];
    [container setItems:items];
    return container;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _dataArray = [NSMutableArray array];
        
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.layout prepareLayout];
    
    [self.expressionCollectionView reloadData];
    
    self.pageControl.numberOfPages = KYUIntegerForCurrentOrientation(self.layout.numberOfPage);
    
    [self.pageControl setNeedsDisplay];
    
    // 防止屏幕翻转时contentoffset出错
    CGPoint contentOffset = self.expressionCollectionView.contentOffset;
    contentOffset.x = self.pageControl.currentPage * self.expressionCollectionView.bounds.size.width;
    self.expressionCollectionView.contentOffset = contentOffset;
}

#pragma mark DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KYExpressionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (!cell.layout) {
        cell.layout = self.layout;
    }
    
    id<KYExpressionData> data = self.dataArray[indexPath.row];
    
    cell.expressionItem = data;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    id<KYExpressionData> item = self.dataArray[indexPath.row];
    if (self.block) {
        self.block(item, indexPath.row, self);
    }
}

#pragma mark ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    
    int page = (scrollView.bounds.size.width/2.f+offsetX)/scrollView.bounds.size.width;
    
    if (page != self.pageControl.currentPage) {
        self.pageControl.currentPage = page;
    }
}

#pragma mark private method

- (void)initUI {
    // self
    KYExpressionContainerLayout *layout = [[KYExpressionContainerLayout alloc] init];
    
    _layout = layout;
    
    // collectionView
    self.expressionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 20) collectionViewLayout:layout];
    
    self.expressionCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    self.expressionCollectionView.pagingEnabled = YES;
    
    self.expressionCollectionView.showsHorizontalScrollIndicator = NO;
    self.expressionCollectionView.showsVerticalScrollIndicator = NO;
    
    self.expressionCollectionView.dataSource = self;
    self.expressionCollectionView.delegate = self;
    
    self.expressionCollectionView.backgroundColor = [UIColor clearColor];
    
    [self.expressionCollectionView registerClass:[KYExpressionCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self addSubview:self.expressionCollectionView];
    
    //pageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 20, self.bounds.size.width, 20)];
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    
    self.pageControl.numberOfPages = KYUIntegerForCurrentOrientation(self.layout.numberOfPage);
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPage = 0;
    [self.pageControl addTarget:self action:@selector(pageControlDidChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.pageControl];
}

- (void)setLayout:(KYExpressionContainerLayout *)layout {
    if (_layout != layout) {
        _layout.itemSize = layout.itemSize;
        _layout.itemSpacing = layout.itemSpacing;
        _layout.numberOfColumn = layout.numberOfColumn;
        _layout.numberOfRow = layout.numberOfRow;
        _layout.borderWidth = layout.borderWidth;
        _layout.textHeightPercent = layout.textHeightPercent;
        _layout.lineSpacing = layout.lineSpacing;
    }
}

- (void)updateLayoutByLayout:(KYExpressionContainerLayout *)newLayout {
    [self setLayout:newLayout];
}

- (NSArray<id<KYExpressionData>> *)items {
    return [NSArray arrayWithArray:self.dataArray];
}

- (void)setItems:(NSArray <id<KYExpressionData>>*)items {
    self.dataArray = items.mutableCopy;
    [self.expressionCollectionView reloadData];
}

- (void)addExpressionItem:(id<KYExpressionData>)item {
    [self.dataArray addObject:item];
    [self layoutSubviews];
}

- (void)removeItemsAtIndexSet:(NSIndexSet *)indexSet {
    [self.dataArray removeObjectsAtIndexes:indexSet];
    [self layoutSubviews];
}

- (void)pageControlDidChange:(UIPageControl *)pageControl {
    NSUInteger currentPage = pageControl.currentPage;
    CGPoint contentOffset = CGPointMake(self.expressionCollectionView.bounds.size.width*currentPage, 0);
    self.expressionCollectionView.contentOffset = contentOffset;
}

@end

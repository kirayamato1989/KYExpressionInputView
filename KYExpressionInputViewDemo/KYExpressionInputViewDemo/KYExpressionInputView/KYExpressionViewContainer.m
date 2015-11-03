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
{
    UIImageView *_imageView;
    UILabel *_textLabel;
}


@property (nonatomic, strong) id<KYExpressionData> expressionItem;

@end

@implementation KYExpressionCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.clipsToBounds = YES;
        self.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        
        //
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
        
        //
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
        _textLabel.font = [UIFont systemFontOfSize:15.f];
        
        _textLabel.textColor = [UIColor blackColor];
        
        _textLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)setExpressionItem:(id<KYExpressionData>)expressionItem {
    if (_expressionItem != expressionItem) {
        _expressionItem = expressionItem;
        
        _imageView.hidden = YES;
        _imageView.image = nil;
        _imageView.animationImages = nil;
        [_imageView stopAnimating];
        
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _textLabel.hidden = YES;
        _textLabel.text = nil;
        
        switch ([expressionItem dataType]) {
            case kExpressionDataTypeEmoji:
                [self showBorder:NO];
                _textLabel.hidden = NO;
                _textLabel.text = [expressionItem text];
                break;
            case kExpressionDataTypeImage:
                [self showBorder:YES];
                _imageView.hidden = NO;
                _imageView.image = [expressionItem image];
                break;
            case kExpressionDataTypeGif:
                [self showBorder:YES];
                _imageView.hidden = NO;
                _imageView.image = [expressionItem image];
                _imageView.animationImages = [expressionItem image].images;
                _imageView.animationDuration = [[expressionItem image] duration];
                [_imageView startAnimating];
                break;
            case kExpressionDataTypeDelete:
                [self showBorder:NO];
                _imageView.hidden = NO;
                _imageView.contentMode = UIViewContentModeScaleAspectFit;
                _imageView.image = [expressionItem image];
            default:
                break;
        }
    }
}

- (void)showBorder:(BOOL)b {
    self.layer.borderWidth = b?.5f:0.f;
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


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _dataArray = [NSMutableArray array];
        
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.pageControl.numberOfPages = self.layout.numberOfPage;
}

#pragma mark DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KYExpressionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    id<KYExpressionData> data = self.dataArray[indexPath.row];
    
    cell.expressionItem = data;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    id<KYExpressionData> item = self.dataArray[indexPath.row];
    if (self.block) {
        self.block(item);
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
    self.backgroundColor = self.inputView.expressionContainerColor;
    
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
    
    self.expressionCollectionView.backgroundColor = self.inputView.expressionContainerColor;
    
    [self.expressionCollectionView registerClass:[KYExpressionCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self addSubview:self.expressionCollectionView];
    
    //pageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 20, self.bounds.size.width, 20)];
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    
    self.pageControl.numberOfPages = self.layout.numberOfPage;
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPage = 0;
//    self.pageControl.backgroundColor = [UIColor redColor];
    [self addSubview:self.pageControl];
}

- (void)setItems:(NSArray *)items {
    self.dataArray = items.mutableCopy;
    [self.expressionCollectionView reloadData];
}

- (void)addExpressionItem:(id<KYExpressionData>)item {
    [self.dataArray addObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.dataArray.count - 1 inSection:0];
    [self.expressionCollectionView insertItemsAtIndexPaths:@[indexPath]];
}

- (void)updateUI {
    [self.layout prepareLayout];
    [self.expressionCollectionView reloadData];
    [self setNeedsLayout];
}

@end

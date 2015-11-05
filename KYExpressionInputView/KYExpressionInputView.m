//
//  FaceInputView.m
//  feeling
//
//  Created by com.feeling on 15/7/11.
//  Copyright (c) 2015年 isaced. All rights reserved.
//

#import "KYExpressionInputView.h"
#import "KYExpressionViewContainer.h"
#import "KYExpressionItem.h"
#import "UIView+FrameAdjust.h"

@interface KYExpressionInputView ()

@property (nonatomic, strong) KYExpressionToolbar *toolbar;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) NSMutableArray *itemsConfigArray;

@property (nonatomic, weak) KYExpressionViewContainer *currentDisplayExpressionViewContainer;

@property (nonatomic, strong) KYExpressionViewContainer *defaultExpressionContainer;

@end

@implementation KYExpressionInputView

- (instancetype)initWithFrame:(CGRect)frame {
    frame.size.height = 260.f;
    frame.size.width = 320.f;
    if (self = [super initWithFrame:frame]) {
        //self
        self.itemsConfigArray = [NSMutableArray array];
        
        //subview
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 44)];
        self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.containerView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.containerView];
        
        
        self.toolbar = [[KYExpressionToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - 44, frame.size.width, 44)];
        self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        
        [self addSubview:_toolbar];
        
        //发送按钮回调
        __weak typeof(self) weakSelf = self;
        _toolbar.sendBlock = ^ (UIButton *send){
            if ([weakSelf.delegate respondsToSelector:@selector(inputView:didClickSendButton:)]) {
                [weakSelf.delegate inputView:weakSelf didClickSendButton:send];
            }
        };
        
        // 添加自定义表情
        
        
        //切换输入数据源
        _toolbar.selectBlock = ^ (NSUInteger index) {
            [weakSelf configExpressionContainerViewForIndex:index];
        };
        
        [self.toolbar setSelectedIndex:0];
    }
    return self;
}


- (void)dealloc {
    NSLog(@"KYExpressionInputView--dealloc");
}

- (void)toggleSendButtonEnable:(BOOL)enable {
    [self.toolbar toggleSendButtonEnable:enable];
}

-(void)setToolbarColor:(UIColor *)toolbarColor {
    _toolbarColor = toolbarColor;
    _toolbar.backgroundColor = toolbarColor;
}

- (void)addToolbarItemWithImage:(UIImage *)image title:(NSString *)title items:(NSArray<id<KYExpressionData>> *)items{
    // 避免传入了nil
    if (items.count == 0) return;
    
    NSMutableDictionary *config = [NSMutableDictionary dictionary];
    config[@"items"] = [self configItemsIfEmoji:items row:2 column:4];
    config[@"itemSize"] = [NSValue valueWithCGSize:CGSizeMake(60, 60)];
    config[@"itemSpacing"] = @15;
    config[@"row"] = @2;
    config[@"column"] = @4;
    
    [self.itemsConfigArray addObject:config];
    [self.toolbar addItemWithImage:image title:title];
    
    if (self.itemsConfigArray.count == 1) {
        [self.toolbar setSelectedIndex:0];
    }
}

- (void)addToolbarItemWithImage:(UIImage *)image
                          title:(NSString *)title
                          items:(NSArray<id<KYExpressionData>> *)items
                            row:(NSUInteger)row
                         column:(NSUInteger)column
                       itemSize:(CGSize)itemSize
                    itemSpacing:(CGFloat)itemSpacing{
    if (items.count == 0) return;
    
    NSMutableDictionary *config = [NSMutableDictionary dictionary];
    config[@"items"] = [self configItemsIfEmoji:items row:row column:column];
    config[@"itemSize"] = [NSValue valueWithCGSize:itemSize];
    config[@"itemSpacing"] = @(itemSpacing);
    config[@"row"] = @(row);
    config[@"column"] = @(column);
    
    [self.itemsConfigArray addObject:config];
    [self.toolbar addItemWithImage:image title:title];
    
    if (self.itemsConfigArray.count == 1) {
        [self.toolbar setSelectedIndex:0];
    }
}

- (void)addToolbarItemWithImage:(UIImage *)image title:(NSString *)title expressionPackage:(id<KYExpressionPackageProtocol>)package {
    if ([package numberOfItems] == 0) return;
    
    NSMutableDictionary *config = [NSMutableDictionary dictionary];
    config[@"items"] = [self configItemsIfEmoji:[package items] row:2 column:4];
    config[@"itemSize"] = [NSValue valueWithCGSize:CGSizeMake(60, 60)];
    config[@"itemSpacing"] = @15;
    config[@"row"] = @2;
    config[@"column"] = @4;
    
    [self.itemsConfigArray addObject:config];
    
    [self.toolbar addItemWithImage:image title:title];
    
    if (self.itemsConfigArray.count == 1) {
        [self.toolbar setSelectedIndex:0];
    }
    
}

- (void)removeContainerAtIndex:(NSUInteger)index {
    NSDictionary *config = self.itemsConfigArray[index];
    UIView *view = config[@"container"];
    
    [view removeFromSuperview];
    [self.itemsConfigArray removeObjectAtIndex:index];
    
    [self.toolbar removeItemAtIndex:index];
    
}

- (void)setItemSpacing:(CGFloat)itemSpacing {
    if (_itemSpacing != itemSpacing) {
        _itemSpacing = itemSpacing;
        
        for (NSMutableDictionary *config in self.itemsConfigArray) {
            config[@"itemSpacing"] = @(itemSpacing);
            if ([self.currentDisplayExpressionViewContainer isKindOfClass:[KYExpressionViewContainer class]]) {
                KYExpressionContainerLayout *layout = [(KYExpressionViewContainer *)self.currentDisplayExpressionViewContainer layout];
                layout.itemSpacing = itemSpacing;
            }
        }
    }
}

- (void)setItemSize:(CGSize)itemSize {
    if (!CGSizeEqualToSize(_itemSize, itemSize)) {
        _itemSize = itemSize;
        
        for (NSMutableDictionary *config in self.itemsConfigArray) {
            config[@"itemSize"] = [NSValue valueWithCGSize:itemSize];
            if ([self.currentDisplayExpressionViewContainer isKindOfClass:[KYExpressionViewContainer class]]) {
                KYExpressionContainerLayout *layout = [(KYExpressionViewContainer *)self.currentDisplayExpressionViewContainer layout];
                layout.itemSize = itemSize;
            }
        }
    }
}

- (void)configExpressionContainerViewForIndex:(NSUInteger)index {
    if (index >= self.itemsConfigArray.count) return;
    
    NSMutableDictionary *config = self.itemsConfigArray[index];
    
    KYExpressionViewContainer *view = config[@"container"];
    
    NSArray *items = config[@"items"];
    
    CGSize itemSize = [config[@"itemSize"] CGSizeValue];
    
    CGFloat itemSpacing = [config[@"itemSpacing"] floatValue];
    
    NSUInteger numberOfRow = [config[@"row"] unsignedIntegerValue];
    
    NSUInteger numberOfColumn = [config[@"column"] unsignedIntegerValue];
    
    if (self.currentDisplayExpressionViewContainer == view&&self.currentDisplayExpressionViewContainer) {
        return;
    }
    
    if (!view) {
        
        
        KYExpressionViewContainer *container = [[KYExpressionViewContainer alloc] initWithFrame:self.containerView.bounds];
        container.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        container.layout.itemSize = itemSize;
        container.layout.itemSpacing = itemSpacing;
        container.layout.numberOfColumn = numberOfColumn;
        container.layout.numberOfRow = numberOfRow;
        
        container.backgroundColor = self.expressionContainerColor;
        
        [container setItems:items];
        container.inputView = self;
        
        [self.containerView addSubview:container];
        
        __weak typeof(self) weakSelf = self;
        container.block = ^ (id<KYExpressionData> item) {
            if ([weakSelf.delegate respondsToSelector:@selector(inputView:didSelectExpression:)]) {
                [weakSelf.delegate inputView:weakSelf didSelectExpression:item];
            }
        };
        view = container;
        
        config[@"container"] = container;
    }
    else if ([view isKindOfClass:[KYExpressionViewContainer class]]) {
        KYExpressionContainerLayout *layout = [view layout];
        layout.itemSize = itemSize;
        layout.itemSpacing = itemSpacing;
        layout.numberOfColumn = numberOfColumn;
        layout.numberOfRow = numberOfRow;
    }
    
    self.currentDisplayExpressionViewContainer.hidden = YES;
    self.currentDisplayExpressionViewContainer = view;
    self.currentDisplayExpressionViewContainer.hidden = NO;
}

- (NSArray *)configItemsIfEmoji:(NSArray *)items row:(NSUInteger)row column:(NSUInteger)column {
    if ([[items firstObject] dataType] == kExpressionDataTypeEmoji&&row*column>1) {
        //计算位置，插入删除按钮
        BOOL stop = NO;
        NSMutableArray *tempArray = [NSMutableArray array];
        NSMutableArray *sampleArray = [NSMutableArray arrayWithArray:items];
        NSRange subRange = NSMakeRange(0, column*row - 1);
        while (!stop) {
            NSArray *subArray = nil;
            if (sampleArray.count < subRange.length) {
                stop = YES;
                
                subArray = sampleArray;
            }
            else{
                subArray = [sampleArray subarrayWithRange:subRange];
                
                [sampleArray removeObjectsInRange:subRange];
            }
            
            KYExpressionItem *delete = [KYExpressionItem deleteItem];
            [tempArray addObjectsFromArray:subArray];
            [tempArray addObject:delete];
        }
        items = [NSArray arrayWithArray:tempArray];
    }
    return items;
}

- (void)addCustomExpressionImage:(UIImage *)image {
    
    
}


#pragma mark Boolen Setter

- (void)setHiddenEmoji:(BOOL)hiddenEmoji {
    if (_hiddenEmoji != hiddenEmoji) {
        if (hiddenEmoji) {
            NSMutableDictionary *config = self.itemsConfigArray[0];
            NSArray *items = config[@"items"];
            if ([[items firstObject] dataType] == kExpressionDataTypeEmoji) {
               [self removeContainerAtIndex:0];
            }
        }
    }
}

- (void)setHiddenToolBar:(BOOL)hiddenToolBar {
    if (_hiddenToolBar != hiddenToolBar) {
        _hiddenToolBar = hiddenToolBar;
        if (hiddenToolBar) {
            [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.toolbar.y += self.toolbar.height;
                self.containerView.height += self.toolbar.height;
            } completion:^(BOOL finished) {
                self.toolbar.hidden = YES;
            }];
        }
        else {
            self.toolbar.hidden = NO;
            [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.toolbar.y -= self.toolbar.height;
                self.containerView.height -= self.toolbar.height;
            } completion:nil];
        }
    }
}

@end

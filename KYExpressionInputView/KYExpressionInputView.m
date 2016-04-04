//
//  FaceInputView.m
//  feeling
//
//  Created by com.feeling on 15/7/11.
//  Copyright (c) 2015年 isaced. All rights reserved.
//

#import "KYExpressionInputView.h"
#import "KYExpressionItem.h"
#import "UIView+KYFrameAdjust.h"

@interface KYExpressionViewContainerModel : NSObject

@property (nonatomic, strong) KYExpressionViewContainer *container;

@property (nonatomic, copy) NSArray<id<KYExpressionData>> *expressionItems;

@property (nonatomic, strong) KYExpressionContainerLayout *layout;

@property (nonatomic, strong) UIColor *backgroundColor;


+ (instancetype)modelWithItems:(NSArray <id<KYExpressionData>>*)items
                      itemSize:(KYSizeOrientation)itemSize
                   itemSpacing:(KYFloatOrientation)itemSpacing
                   lineSpacing:(KYFloatOrientation)lineSpacing
                           row:(KYUIntegerOrientation)row
                        column:(KYUIntegerOrientation)column
                   textPercent:(CGFloat)percent
               backgroundColor:(UIColor *)color
                   borderWidth:(CGFloat)width;

@end


@implementation KYExpressionViewContainerModel

+ (instancetype)modelWithItems:(NSArray<id<KYExpressionData>> *)items
                      itemSize:(KYSizeOrientation)itemSize
                   itemSpacing:(KYFloatOrientation)itemSpacing
                   lineSpacing:(KYFloatOrientation)lineSpacing
                           row:(KYUIntegerOrientation)row
                        column:(KYUIntegerOrientation)column
                   textPercent:(CGFloat)percent
               backgroundColor:(UIColor *)color
                   borderWidth:(CGFloat)width {
    KYExpressionViewContainerModel *model = [[self alloc] init];
    KYExpressionContainerLayout *layout = [[KYExpressionContainerLayout alloc] init];
    model.layout = layout;
    model.expressionItems = [NSArray arrayWithArray:items];
    model.layout.itemSize = itemSize;
    model.layout.itemSpacing = itemSpacing;
    model.layout.numberOfColumn = column;
    model.layout.numberOfRow = row;
    model.layout.borderWidth = width;
    model.layout.textHeightPercent = percent;
    model.layout.lineSpacing = lineSpacing;
    model.backgroundColor = color;
    return model;
}


@end

@interface KYExpressionInputView ()

@property (nonatomic, strong) KYExpressionToolbar *toolbar;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) NSMutableArray *modelArray;

@property (nonatomic, weak) KYExpressionViewContainer *currentDisplayExpressionViewContainer;

@property (nonatomic, strong) KYExpressionViewContainer *defaultExpressionContainer;

@end

@implementation KYExpressionInputView

#pragma mark inilizations

- (instancetype)initWithFrame:(CGRect)frame {
    frame.size.height = 260.f;
    frame.size.width = 320.f;
    if (self = [super initWithFrame:frame]) {
        //self
        self.modelArray = [NSMutableArray array];
        
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
            [weakSelf showContainerAtIndex:index];
        };
        
        [self registObserver];
        
        [self.toolbar setSelectedIndex:0];
    }
    return self;
}

#pragma mark lifeCycle

- (void)dealloc {
    [self removeObserver];
    NSLog(@"KYExpressionInputView--dealloc");
}


#pragma mark public method

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
    
    [self.modelArray addObject:config];
    [self.toolbar addItemWithImage:image title:title];
    
    if (self.modelArray.count == 1) {
        [self.toolbar setSelectedIndex:0];
    }
}

- (void)addToolbarItemWithImage:(UIImage *)image
                          title:(NSString *)title
                          items:(NSArray<id<KYExpressionData>> *)items
                            row:(KYUIntegerOrientation)row
                         column:(KYUIntegerOrientation)column
                       itemSize:(KYSizeOrientation)itemSize
                    itemSpacing:(KYFloatOrientation)itemSpacing
                    lineSpacing:(KYFloatOrientation)lineSpacing
                    textPercent:(CGFloat)percent
                backgroundColor:(UIColor *)color
                    borderWidth:(CGFloat)width {
    if (items.count == 0) return;
    
    KYExpressionViewContainerModel *model = [KYExpressionViewContainerModel modelWithItems:items itemSize:itemSize itemSpacing:itemSpacing lineSpacing:lineSpacing row:row column:column textPercent:percent backgroundColor:color borderWidth:width];
    
    
    [self.modelArray addObject:model];
    [self.toolbar addItemWithImage:image title:title];
    
    if (self.modelArray.count == 1) {
        [self.toolbar setSelectedIndex:0];
    }
}

- (void)addToolbarItemWithImage:(UIImage *)image title:(NSString *)title expressionPackage:(id<KYExpressionPackageProtocol>)package {
    if ([package numberOfItems] == 0) return;
    KYExpressionViewContainerModel *model = [KYExpressionViewContainerModel modelWithItems:[package items] itemSize:KYSizeOrientationMake(CGSizeMake(60, 60), CGSizeMake(60, 60)) itemSpacing:KYFloatOrientationMake(15, 15) lineSpacing:KYFloatOrientationMake(15, 15) row:KYUIntegerOrientationMake(2, 2) column:KYUIntegerOrientationMake(4, 8) textPercent:0 backgroundColor:[UIColor clearColor] borderWidth:0];
    
    [self.modelArray addObject:model];
    
    [self.toolbar addItemWithImage:image title:title];
    
    if (self.modelArray.count == 1) {
        [self.toolbar setSelectedIndex:0];
    }
    
}

- (void)addToolbarItemWithImage:(UIImage *)image title:(NSString *)title container:(KYExpressionViewContainer *)container {
    
    //
    container.frame = self.containerView.bounds;
    
    //
    KYExpressionViewContainerModel *model = [KYExpressionViewContainerModel modelWithItems:[container items] itemSize:container.layout.itemSize itemSpacing:container.layout.itemSpacing lineSpacing:container.layout.lineSpacing row:container.layout.numberOfRow column:container.layout.numberOfColumn textPercent:0 backgroundColor:[UIColor clearColor] borderWidth:0];
    
    [self.modelArray addObject:model];
    
    [self.toolbar addItemWithImage:image title:title];
    
    if (self.modelArray.count == 1) {
        [self.toolbar setSelectedIndex:0];
    }
}

- (void)addCustomExpression:(id<KYExpressionData>)expression indexOfConatiner:(NSUInteger)index {
    KYExpressionViewContainerModel *model = self.modelArray[index];
    NSMutableArray *array = model.expressionItems.mutableCopy;
    [array addObject:expression];
    model.expressionItems = [NSArray arrayWithArray:array];
    
    [model.container addExpressionItem:expression];
}

- (KYExpressionViewContainer *)containerViewAtIndex:(NSUInteger)index {
    return [self.modelArray[index] container];
}

- (void)setToolbarSendButtonHidden:(BOOL)hidden animated:(BOOL)animated {
    [self.toolbar setSendButtonHidden:hidden animated:animated];
}

- (void)updateItemSize:(KYSizeOrientation)itemSize conatinerAtIndex:(NSUInteger)index {
    KYExpressionViewContainerModel *model = self.modelArray[index];
    model.layout.itemSize = itemSize;
    if (self.currentDisplayExpressionViewContainer == model.container) {
        model.container.layout.itemSize = itemSize;
    }
}

- (void)updateItemSpacing:(KYFloatOrientation)itemSpacing containerAtIndex:(NSUInteger)index {
    KYExpressionViewContainerModel *model = self.modelArray[index];
    model.layout.itemSpacing = itemSpacing;
    if (self.currentDisplayExpressionViewContainer == model.container) {
        model.container.layout.itemSpacing = itemSpacing;
    }
}

#pragma mark private method

- (void)showContainerAtIndex:(NSUInteger)index {
    KYExpressionViewContainer *view = [self.modelArray[index] container];
    if (view == self.currentDisplayExpressionViewContainer) return;
    
    self.currentDisplayExpressionViewContainer.hidden = YES;
    self.currentDisplayExpressionViewContainer = view;
    self.currentDisplayExpressionViewContainer.hidden = NO;
}

- (void)removeContainerAtIndex:(NSUInteger)index {
    NSDictionary *config = self.modelArray[index];
    KYExpressionViewContainer *view = config[@"container"];
    
    [view removeFromSuperview];
    [self.modelArray removeObjectAtIndex:index];
    
    [self.toolbar removeItemAtIndex:index];
    
}

- (void)configExpressionContainerViewForIndex:(NSUInteger)index{
    if (index >= self.modelArray.count) return;
    
    KYExpressionViewContainerModel *model = self.modelArray[index];
    
    KYExpressionViewContainer *view = model.container;
    
    NSArray *items = model.expressionItems;
    
    if (!view) {
        KYExpressionViewContainer *container = [[KYExpressionViewContainer alloc] initWithFrame:self.containerView.bounds];
        container.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [container updateLayoutByLayout:model.layout];
        
        container.backgroundColor = model.backgroundColor;
        
        [container setItems:[self configItemsIfEmoji:items row:KYUIntegerForCurrentOrientation(model.layout.numberOfRow) column:KYUIntegerForCurrentOrientation(model.layout.numberOfColumn)]];
        container.inputView = self;
        
        [self.containerView addSubview:container];
        
        __weak typeof(self) weakSelf = self;
        container.block = ^ (id<KYExpressionData> item, NSUInteger index, KYExpressionViewContainer *container) {
            if ([weakSelf.delegate respondsToSelector:@selector(inputView:didSelectExpression:atIndex:container:)]) {
                [weakSelf.delegate inputView:weakSelf didSelectExpression:item atIndex:index container:container];
            }
        };
        
        view = container;
        
        model.container = container;
    }
    else {
        [view updateLayoutByLayout:model.layout];
        
        view.backgroundColor = model.backgroundColor;
        
        if ([items.firstObject dataType] == kExpressionDataTypeEmoji) {
            view.items = [self configItemsIfEmoji:items row:KYUIntegerForCurrentOrientation(model.layout.numberOfRow) column:KYUIntegerForCurrentOrientation(model.layout.numberOfColumn)];
        }
    }
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


#pragma mark setter&&getter

- (void)setItemSpacing:(KYFloatOrientation)itemSpacing {
    if (!KYFloatIsEqual(_itemSpacing, itemSpacing)) {
        _itemSpacing = itemSpacing;
        
        for (KYExpressionViewContainerModel *model in self.modelArray) {
            model.layout.itemSpacing = itemSpacing;
            if ([self.currentDisplayExpressionViewContainer isKindOfClass:[KYExpressionViewContainer class]]) {
                KYExpressionContainerLayout *layout = [(KYExpressionViewContainer *)self.currentDisplayExpressionViewContainer layout];
                layout.itemSpacing = itemSpacing;
            }
        }
    }
}

- (void)setItemSize:(KYSizeOrientation)itemSize {
    if (!KYSizeIsEqual(_itemSize, itemSize)) {
        _itemSize = itemSize;
        
        for (KYExpressionViewContainerModel *model in self.modelArray) {
            model.layout.itemSize = itemSize;
            if ([self.currentDisplayExpressionViewContainer isKindOfClass:[KYExpressionViewContainer class]]) {
                KYExpressionContainerLayout *layout = [(KYExpressionViewContainer *)self.currentDisplayExpressionViewContainer layout];
                layout.itemSize = itemSize;
            }
        }
    }
}

- (void)setLineSpacing:(KYFloatOrientation)lineSpacing {
    if (!KYFloatIsEqual(_lineSpacing, lineSpacing)) {
        for (KYExpressionViewContainerModel *model in self.modelArray) {
            model.layout.lineSpacing = lineSpacing;
            if ([self.currentDisplayExpressionViewContainer isKindOfClass:[KYExpressionViewContainer class]]) {
                KYExpressionContainerLayout *layout = [(KYExpressionViewContainer *)self.currentDisplayExpressionViewContainer layout];
                layout.lineSpacing = lineSpacing;
            }
        }
    }
}

#pragma mark Boolen Setter

- (void)setHiddenEmoji:(BOOL)hiddenEmoji {
    if (_hiddenEmoji != hiddenEmoji) {
        if (hiddenEmoji) {
            NSMutableDictionary *config = self.modelArray[0];
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


#pragma mark Notification 
- (void)registObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)orientationDidChange:(NSNotification *)noti {
    [self configExpressionContainerViewForIndex:_toolbar.selectedIndex];
}

@end

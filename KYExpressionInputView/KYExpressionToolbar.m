//
//  FaceToolbar.m
//  feeling
//
//  Created by com.feeling on 15/7/11.
//  Copyright (c) 2015年 isaced. All rights reserved.
//

#import "KYExpressionToolbar.h"
#import "UIView+KYShadow.h"
#import "KYExpressionConstant.h"
#import "UIView+KYFrameAdjust.h"
#import "UIImage+KYMask.h"

@interface KYExpressionToolbarItem : UIButton

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSString *title;

+ (instancetype)itemWithImage:(UIImage *)image title:(NSString *)title;

@end

@implementation KYExpressionToolbarItem

+(instancetype)itemWithImage:(UIImage *)image title:(NSString *)title {
    return [[self alloc] initWithImage:image title:title];
}

- (instancetype) initWithImage:(UIImage *)image title:(NSString *)title {
    if (self = [super init]) {
        self.image = image;
        self.title = title;
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:15.f];
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        if (image) {
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self setImage:image forState:UIControlStateNormal];
        }
        if (title) {
            [self setTitle:title forState:UIControlStateNormal];
        }
        
        [self addRightShadowWithColor:nil];
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect rect = [super titleRectForContentRect:contentRect];
    if (self.title&&self.image) {
        rect = CGRectMake(0, self.bounds.size.height*0.6, self.bounds.size.width, self.bounds.size.height*0.4);
    }
    return rect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect rect = [super imageRectForContentRect:contentRect];
    if (self.title&&self.image) {
        rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height*0.6);
    }
    return rect;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = [UIColor lightGrayColor];
    }
    else{
        self.backgroundColor = [UIColor clearColor];
    }
}

@end



@interface KYExpressionToolbar()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *itemContaniner;

@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, weak) KYExpressionToolbarItem *selectedItem;

@end

@implementation KYExpressionToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame.size.width = 320;
        frame.size.height = 44;
    }
    
    if (self = [super initWithFrame:frame]) {
        self.items = [NSMutableArray array];
        
        [self addTopShadowWithColor:nil];
        
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 60, self.bounds.size.height)];
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sendButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - 60, 0, 60, self.bounds.size.height);
        self.sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleHeight;
        
        [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [self.sendButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.sendButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateDisabled];
        [self.sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.sendButton];
        
        [self.sendButton addLeftShadowWithColor:nil];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self reloadData];
}

- (void) sendButtonClick:(UIButton *)sender {
    if (self.sendBlock) {
        self.sendBlock(sender);
    }
}

- (void)toggleSendButtonEnable:(BOOL)enable {
    self.sendButton.enabled = enable;
}

-(void)addItemWithImage:(UIImage *)image title:(NSString *)title {
    //实例化
    KYExpressionToolbarItem *item = [KYExpressionToolbarItem itemWithImage:image title:title];
    
    
    //添加布局约束
    [self.scrollView addSubview:item];
    [self.items addObject:item];
    
    [self reloadData];
    //添加点击事件
    [item addTarget:self action:@selector(toolbarItemClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)reloadData {
    //添加布局约束
    KYExpressionToolbarItem *lastItem = self.items.lastObject;
    for (int i = 0; i < self.items.count; i++) {
        KYExpressionToolbarItem *item = self.items[i];
        item.tag = i + 1;
        item.frame = CGRectMake(i*60, 0, 60, self.bounds.size.height);
    }
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastItem.frame), self.bounds.size.height);
}

- (void)removeItemAtIndex:(NSUInteger)index {
    KYExpressionToolbarItem *item = self.items[index];
    [item removeFromSuperview];
    [self.items removeObject:item];
    
    [self reloadData];
}

- (void)setSelectedIndex:(NSUInteger)index {
    if (index<self.items.count) {
        _selectedIndex = index;
        
        KYExpressionToolbarItem *item = self.items[index];
        
        [self toolbarItemClick:item];
    }
}


- (void)toolbarItemClick:(KYExpressionToolbarItem *)item {
    //改变选中状态
    if (item) {
        if (self.selectedItem != item) {
            self.selectedItem.selected = NO;
            item.selected = YES;
            self.selectedItem = item;
            _selectedIndex = item.tag - 1;
            if (self.selectBlock) {
                self.selectBlock(item.tag -1);
            }
            
            //
            CGRect frame = item.frame;
            frame.origin.x -= self.scrollView.contentOffset.x;
            CGFloat transformX = 0;
            if (frame.origin.x < 0) {
                transformX = frame.origin.x;
            }
            else if (frame.origin.x > self.scrollView.bounds.size.width - item.bounds.size.width) {
                transformX = CGRectGetMaxX(frame) - self.scrollView.bounds.size.width;
            }
            if (transformX != 0) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint contentOffset = self.scrollView.contentOffset;
                    contentOffset.x += transformX;
                    self.scrollView.contentOffset = contentOffset;
                }];
            }
            
        }
    }
}

- (void)setSendButtonHidden:(BOOL)hidden animated:(BOOL)animated {
    //
    if (self.sendButton.hidden == hidden) return;
    
    //
    CGFloat animatedDuration = animated?0.4f:0.f;
    
    if (!hidden) {
        self.sendButton.hidden = hidden;
    }
    
    [UIView animateWithDuration:animatedDuration animations:^{
        CGFloat delta = hidden?self.sendButton.width:-self.sendButton.width;
        self.sendButton.x += delta;
        self.scrollView.width += delta;
    } completion:^(BOOL finished) {
        self.sendButton.hidden = hidden;
    }];
}

@end




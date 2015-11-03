//
//  FaceView.m
//  feeling
//
//  Created by com.feeling on 15/7/11.
//  Copyright (c) 2015年 isaced. All rights reserved.
//

#import "KYExpressionView.h"
#import "Masonry.h"

@interface KYExpressionView ()

@property (nonatomic, copy) ExpressionTapBlock block;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation KYExpressionView

+ (instancetype)expressionViewWithItem:(id<KYExpressionData>)item {
    return [[self alloc] initWithItem:item];
}

- (instancetype)initWithItem:(id<KYExpressionData>)item {
    if (self = [self init]) {
        [self initConfig];
        
        _item = item;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initConfig];
    }
    return self;
}

- (void)initConfig {
    _imageView = [[UIImageView alloc] init];
    _imageView.clipsToBounds = YES;
    _imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self updateConstraintsIfNeeded];
}

- (void)setTapBlock:(ExpressionTapBlock)block {
    self.block = block;
}

- (void)setItem:(id<KYExpressionData>)item {
    if (_item != item) {
        _item = item;
        
        self.imageView.image = [item image];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //判断触摸的结束点是否在图片中
    if (CGRectContainsPoint(self.bounds, point)) {
        //回调,把该图像的信息传到相应的controller中
        if (self.block) {
            self.block(self.item);
        }
    }
    [super touchesEnded:touches withEvent:event];
}


@end

//
//  FaceDeleteCustomController.m
//  feeling
//
//  Created by com.feeling on 15/7/13.
//  Copyright (c) 2015年 isaced. All rights reserved.
//

#import "KYExpressionDeleteController.h"
#import "Masonry.h"
#import "UIView+Shadow.h"
#import "KYExpressionConstant.h"

@interface FaceDeleteCollectionViewModel : NSObject

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) BOOL isSelected;

@end

@implementation FaceDeleteCollectionViewModel



@end

@interface FaceDeleteCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *selectIconView;


@end


@implementation FaceDeleteCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.imageView = [[UIImageView alloc]init];
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.imageView];
        
        self.selectIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected"]];
        self.selectIconView.contentMode = UIViewContentModeScaleAspectFit;
        self.selectIconView.layer.zPosition = 1.f;
        [self addSubview:self.selectIconView];
        
        
        //约束
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.selectIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(@20);
            make.centerX.equalTo(self.mas_right);
            make.centerY.equalTo(self.mas_top);
        }];
        self.selectIconView.hidden = YES;
    }
    return self;
}

@end

@interface KYExpressionDeleteController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *allImages;

@property (nonatomic, strong) NSMutableIndexSet *deleteIndexSet;

@property (nonatomic, strong) UIView *topBar;

@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) NSMutableArray *modelArray;

@property (nonatomic, copy) DeleteSelectedImagesBlock block;

@property (nonatomic, copy) CancelBlock cancelBlock;

@end

@implementation KYExpressionDeleteController

static NSString * const reuseIdentifier = @"Cell";


- (instancetype)initWithImages:(NSArray *)array {
    if (self = [super init]) {
        self.allImages = array.copy;
        self.modelArray = [NSMutableArray array];
        self.deleteIndexSet = [NSMutableIndexSet indexSet];
        
        for (UIImage *image in self.allImages) {
            FaceDeleteCollectionViewModel *model = [FaceDeleteCollectionViewModel new];
            model.image = image;
            model.isSelected = NO;
            [self.modelArray addObject:model];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //topBar
    self.topBar = [[UIView alloc] init];
    [self.view addSubview:self.topBar];
    [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    [self.topBar addShadow];
    
    UIButton *backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBarButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBarButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.topBar addSubview:backBarButton];
    [backBarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.top.equalTo(@20);
        make.height.and.width.equalTo(@44);
    }];
    
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBarButton setTitle:@"删除" forState:UIControlStateNormal];
    [rightBarButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [rightBarButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [rightBarButton addTarget:self action:@selector(deleteSelectedImages) forControlEvents:UIControlEventTouchUpInside];
    rightBarButton.enabled = NO;
    self.deleteButton = rightBarButton;
    
    [self.topBar addSubview:rightBarButton];
    [rightBarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.right.equalTo(self.topBar).offset(-5);
        make.width.and.height.equalTo(@44);
    }];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"收藏的表情";
    title.font = [UIFont systemFontOfSize:17.f];
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    title.textColor = UIColorFromRGB(0x333333);
    [self.topBar addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.centerX.equalTo(self.topBar.mas_centerX);
        make.width.equalTo(@100);
        make.bottom.equalTo(self.topBar);
    }];
    
    //collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(50.f, 50.f);
    layout.minimumLineSpacing = 24.f;
    layout.minimumInteritemSpacing = 24.f;
    layout.sectionInset = UIEdgeInsetsMake(21, 24, 0, 24);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view);
    }];
    
    
    // Register cell classes
    [self.collectionView registerClass:[FaceDeleteCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FaceDeleteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    FaceDeleteCollectionViewModel *model = self.modelArray[indexPath.item];
    cell.imageView.image = model.image;
    cell.selectIconView.hidden = !model.isSelected;
    cell.isSelected = model.isSelected;
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FaceDeleteCollectionViewModel *model = self.modelArray[indexPath.item];
    model.isSelected = !model.isSelected;
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    if (model.isSelected) {
        [self.deleteIndexSet addIndex:indexPath.item];
    }
    else{
        [self.deleteIndexSet removeIndex:indexPath.item];
    }
    self.deleteButton.enabled = self.deleteIndexSet.count;
}



#pragma mark private method

- (void)setDeleteBlock:(DeleteSelectedImagesBlock)block {
    _block = block;
}

- (void)setCancelBlock:(CancelBlock)block {
    _cancelBlock = block;
}

- (void)showWithAnimated:(BOOL)animated {
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:self animated:animated completion:nil];
}

- (void) dismiss {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)deleteSelectedImages {
    [self dismiss];
    if (self.block) {
        self.block(self.deleteIndexSet);
    }
}

@end

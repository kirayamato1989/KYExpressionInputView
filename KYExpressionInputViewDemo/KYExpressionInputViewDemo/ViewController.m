//
//  ViewController.m
//  KYCustomExpressionView
//
//  Created by YamatoKira on 15/11/2.
//  Copyright © 2015年 YamatoKira. All rights reserved.
//

#import "ViewController.h"
#import "KYExpression.h"
#import "UIImage+KYMultiFormate.h"


@interface ViewController ()<KYExpressionInputViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    KYExpressionInputView *inputView = [[KYExpressionInputView alloc] init];
    
    inputView.toolbarColor = [UIColor whiteColor];
    
    NSString *emojiPath = [[NSBundle mainBundle] pathForResource:@"ISEmojiList" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:emojiPath];
    NSMutableArray *emojiItems = [NSMutableArray array];
    for (NSString *text in array) {
        KYExpressionItem *item = [KYExpressionItem itemWithEmoji:text];
        [emojiItems addObject:item];
    }
    
    
    [inputView addToolbarItemWithImage:nil title:@"表情" items:emojiItems row:KYUIntegerOrientationMake(4, 5) column:KYUIntegerOrientationMake(8, 14) itemSize:KYSizeOrientationMake(CGSizeMake(36, 36), CGSizeMake(36, 36)) itemSpacing:KYFloatOrientationMake(6, 8) textPercent:1 backgroundColor:[UIColor clearColor] borderWidth:0];
    
    
    
//    NSString *iconPath = [kExpressionBundle pathForResource:@"icon" ofType:@"jpg"];
    
//    [inputView addToolbarItemWithImage:[UIImage imageWithContentsOfFile:iconPath] title:nil items:items row:KYUIntegerOrientationMake(2, 2) column:KYUIntegerOrientationMake(4, 6) itemSize:KYSizeOrientationMake(CGSizeMake(66, 80), CGSizeMake(56, 56)) itemSpacing:KYFloatOrientationMake(20, 20) textPercent:0.15 backgroundColor:[UIColor whiteColor] borderWidth:0];
    
    // add by a KYExpressionViewContainer
//    KYExpressionContainerLayout *layout = [[KYExpressionContainerLayout alloc] init];
//    layout.itemSize = KYSizeOrientationMake(CGSizeMake(50, 50), CGSizeMake(40, 40));
//    layout.itemSpacing = KYFloatOrientationMake(20, 10);
//    layout.numberOfRow = KYUIntegerOrientationMake(3, 6);
//    
//    KYExpressionViewContainer *container = [KYExpressionViewContainer containerWithLayout:layout items:items];
//    [inputView addToolbarItemWithImage:nil title:@"hah" container:container];
    
    
    inputView.delegate = self;
    
    
    [inputView setToolbarSendButtonHidden:NO animated:NO];
    self.textField.inputView = inputView;
}

- (void)inputView:(KYExpressionInputView *)inputView didSelectExpression:(id<KYExpressionData>)expression atIndex:(NSUInteger)index container:(KYExpressionViewContainer *)container {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

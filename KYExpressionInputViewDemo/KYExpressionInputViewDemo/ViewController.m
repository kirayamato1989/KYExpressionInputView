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
    
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 0; i < 100; i++) {
        NSString *path = [kExpressionBundle pathForResource:[NSString stringWithFormat:@"%i",arc4random_uniform(5)+1] ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        KYExpressionItem *item = [KYExpressionItem itemWithData:data url:nil];
        [items addObject:item];
    }
    NSString *emojiPath = [kExpressionBundle pathForResource:@"ISEmojiList" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:emojiPath];
    NSMutableArray *emojiItems = [NSMutableArray array];
    for (NSString *text in array) {
        KYExpressionItem *item = [KYExpressionItem itemWithEmoji:text];
        [emojiItems addObject:item];
    }
    
    [inputView setToolbarSendButtonHidden:YES animated:NO];
    
    
    
    [inputView addToolbarItemWithImage:nil title:@"表情" items:emojiItems row:KYUIntegerOrientationMake(4, 5) column:KYUIntegerOrientationMake(8, 14) itemSize:KYSizeOrientationMake(CGSizeMake(36, 36), CGSizeMake(36, 36)) itemSpacing:KYFloatOrientationMake(6, 8)];
    
    
    NSString *iconPath = [kExpressionBundle pathForResource:@"icon" ofType:@"jpg"];
    
    [inputView addToolbarItemWithImage:[UIImage imageWithContentsOfFile:iconPath] title:nil items:items row:KYUIntegerOrientationMake(2, 3) column:KYUIntegerOrientationMake(6, 10) itemSize:KYSizeOrientationMake(CGSizeMake(50, 50), CGSizeMake(44, 44)) itemSpacing:KYFloatOrientationMake(15, 15)];
    
    inputView.delegate = self;
    
    self.textField.inputView = inputView;
}


- (void)inputView:(KYExpressionInputView *)inputView didSelectExpression:(id<KYExpressionData>)expression {
    NSLog(@"%@",[expression image]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

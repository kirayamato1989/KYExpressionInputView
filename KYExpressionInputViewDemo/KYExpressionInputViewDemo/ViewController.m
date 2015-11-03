//
//  ViewController.m
//  KYCustomExpressionView
//
//  Created by YamatoKira on 15/11/2.
//  Copyright © 2015年 YamatoKira. All rights reserved.
//

#import "ViewController.h"
#import "KYExpression.h"


@interface ViewController ()<KYExpressionInputViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)slider:(UISlider *)sender;
- (IBAction)itemSize:(UISlider *)sender;

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
    
    [inputView addToolbarItemWithImage:nil title:@"表情" items:emojiItems row:5 column:10 itemSize:CGSizeMake(36, 36) itemSpacing:6];
    
    
    NSString *iconPath = [kExpressionBundle pathForResource:@"icon" ofType:@"jpg"];
    
    [inputView addToolbarItemWithImage:[UIImage imageWithContentsOfFile:iconPath] title:nil items:items row:2 column:4 itemSize:CGSizeMake(58, 58) itemSpacing:15];
    
    
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

- (IBAction)slider:(UISlider *)sender {
    KYExpressionInputView *inputView = (KYExpressionInputView *)self.textField.inputView;
    
    inputView.itemSpacing = sender.value * 30.f;
}

- (IBAction)itemSize:(UISlider *)sender {
    KYExpressionInputView *inputView = (KYExpressionInputView *)self.textField.inputView;
    
    inputView.itemSize = CGSizeMake(50 * sender.value + 10, 50*sender.value + 10);
    
}


@end

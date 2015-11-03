# KYExpressionInputView

1.初始化

KYExpressionInputView *inputView = [[KYExpressionInputView alloc] init];

2.添加emoji

NSString *emojiPath = [kExpressionBundle pathForResource:@"ISEmojiList" ofType:@"plist"];

NSArray *array = [NSArray arrayWithContentsOfFile:emojiPath];

NSMutableArray *emojiItems = [NSMutableArray array];

for (NSString *text in array) {

    KYExpressionItem *item = [KYExpressionItem itemWithEmoji:text];
    
    [emojiItems addObject:item];
    
}

指定行数列数大小还有间距

[inputView addToolbarItemWithImage:nil title:@"表情" items:emojiItems row:5 column:10 itemSize:CGSizeMake(36, 36) itemSpacing:6];

3.添加图片

NSMutableArray *items = [NSMutableArray array];

for (int i = 0; i < 100; i++) {

    NSString *path = [kExpressionBundle pathForResource:[NSString stringWithFormat:@"%i",arc4random_uniform(5)+1]        ofType:nil];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    KYExpressionItem *item = [KYExpressionItem itemWithData:data url:nil];
    
    [items addObject:item];
    
}

NSString *iconPath = [kExpressionBundle pathForResource:@"icon" ofType:@"jpg"];

[inputView addToolbarItemWithImage:[UIImage imageWithContentsOfFile:iconPath] title:nil items:items row:2 column:4 itemSize:CGSizeMake(58, 58) itemSpacing:15];

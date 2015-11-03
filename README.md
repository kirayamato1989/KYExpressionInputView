# KYExpressionInputView

初始化

KYExpressionInputView *inputView = [[KYExpressionInputView alloc] init];\n

2.添加emoji

NSString *emojiPath = [kExpressionBundle pathForResource:@"ISEmojiList" ofType:@"plist"];\n
NSArray *array = [NSArray arrayWithContentsOfFile:emojiPath];\n
NSMutableArray *emojiItems = [NSMutableArray array];\n
for (NSString *text in array) {\n
    KYExpressionItem *item = [KYExpressionItem itemWithEmoji:text];\n
    [emojiItems addObject:item];\n
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

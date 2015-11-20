# KYExpressionInputView

## Inilization

``` 
KYExpressionInputView *inputView = [[KYExpressionInputView alloc] init];
```

## Add emoji expression input with expressionItems

``` 
// get the emoji strings
NSString *emojiPath = [kExpressionBundle pathForResource:@"ISEmojiList" ofType:@"plist"];

NSArray *array = [NSArray arrayWithContentsOfFile:emojiPath]; 

for (NSString *text in array) {

      KYExpressionItem *item = [KYExpressionItem itemWithEmoji:text];

      [emojiItems addObject:item];

}

[inputView addToolbarItemWithImage:nil title:@"表情" items:emojiItems row:KYUIntegerOrientationMake(4, 5) column:KYUIntegerOrientationMake(8, 14) itemSize:KYSizeOrientationMake(CGSizeMake(36, 36), CGSizeMake(36, 36)) itemSpacing:KYFloatOrientationMake(6, 8)]
;
```

![emoji input image](https://github.com/kirayamato1989/KYExpressionInputView/blob/master/KYExpressionInputViewDemo/KYExpressionInputViewDemo/QQ20151120-0%402x.png)

## Add a image expression input with expressionItems

``` 
NSMutableArray *items = [NSMutableArray array];

for (int i = 0; i < 100; i++) {

      NSString *path = [kExpressionBundle pathForResource:[NSString stringWithFormat:@"%i",arc4random_uniform(5)+1]        ofType:nil];

      NSData *data = [NSData dataWithContentsOfFile:path];

      KYExpressionItem *item = [KYExpressionItem itemWithData:data url:nil];

      [items addObject:item];
}

NSString *iconPath = [kExpressionBundle pathForResource:@"icon" ofType:@"jpg"];

// set the toolBar item' image and title etc.
[inputView addToolbarItemWithImage:[UIImage imageWithContentsOfFile:iconPath] title:nil items:items row:KYUIntegerOrientationMake(2, 3) column:KYUIntegerOrientationMake(6, 10) itemSize:KYSizeOrientationMake(CGSizeMake(50, 50), CGSizeMake(44, 44)) itemSpacing:KYFloatOrientationMake(15, 15)];
```

![image](https://github.com/kirayamato1989/KYExpressionInputView/blob/master/KYExpressionInputViewDemo/KYExpressionInputViewDemo/QQ20151120-1%402x.png)
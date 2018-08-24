//
//  MyTextView.m
//  WLPoetryProject
//
//  Created by 变啦 on 2018/8/24.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "MyTextView.h"
@interface MyTextView()
@property (nonatomic , strong) UIToolbar *keyBordToolBar;

@property (nonatomic , strong) UIBarButtonItem *doneItem;
@end

@implementation MyTextView

- (id)init
{
    self = [super init];
    if (self) {
        [self createTextView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createTextView];
    }
    return self;
}

- (void)createTextView
{
    self.keyBordToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 38)];
    self.keyBordToolBar.barStyle = UIBarStyleDefault;
    self.inputAccessoryView = self.keyBordToolBar;
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    self.doneItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneItemAction:)];
    self.keyBordToolBar.items = @[space,self.doneItem];
}

- (void)doneItemAction:(UIBarButtonItem *)button
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];;
}

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    CGRect originalRect = [super caretRectForPosition:position];
    originalRect.size.height = 24;
    originalRect.size.width = 2;
    return originalRect;
}


@end

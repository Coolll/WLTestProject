//
//  WLTextField.m
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/14.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "WLTextField.h"
@interface WLTextField()
@property (nonatomic , strong) UIToolbar *keyBordToolBar;

@property (nonatomic , strong) UIBarButtonItem *doneItem;
@end

@implementation WLTextField
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
    originalRect.size.height = self.frame.size.height*3/5;
    originalRect.size.width = 2;
    originalRect.origin.y = self.frame.size.height/5;
    return originalRect;
}


@end

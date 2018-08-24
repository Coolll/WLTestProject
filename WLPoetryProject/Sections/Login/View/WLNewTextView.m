//
//  WLNewTextView.m
//  WLPoetryProject
//
//  Created by 变啦 on 2018/8/23.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLNewTextView.h"
typedef void(^CustomTextBlock)(NSString *string);
@interface WLNewTextView()<UITextViewDelegate>
/**
 *  placeHoder
 **/
@property (nonatomic,strong) UILabel *placeHolderLabel;
/**
 *  尺寸
 **/
@property (nonatomic,assign) CGRect viewFrame;

/**
 *  文本
 **/
@property (nonatomic,copy) CustomTextBlock block;
/**
 *  回车按钮的事件
 **/
@property (nonatomic,copy) ReturnKeyBlock returnBlock;


@end
@implementation WLNewTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.viewFrame = frame;
        self.mainTextView = [[MyTextView alloc]init];
        self.mainTextView.backgroundColor = [UIColor clearColor];
        self.mainTextView.delegate = self;
        self.mainTextView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.mainTextView];
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.mainTextView = [[MyTextView alloc]init];
        self.mainTextView.delegate = self;
        self.mainTextView.backgroundColor = [UIColor clearColor];

        [self addSubview:self.mainTextView];
        
        //设置UI布局约束
        [self.mainTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_top).offset(0);//元素顶部约束
            make.leading.equalTo(self.mas_leading).offset(0);//元素左侧约束
            make.trailing.equalTo(self.mas_trailing).offset(0);//元素右侧约束
            make.bottom.equalTo(self.mas_bottom).offset(0);//元素底部约束
        }];
    }
    
    return self;
}


- (void)setPlaceHolderString:(NSString *)placeHolderString
{
    _placeHolderString = placeHolderString;
    
    if (placeHolderString) {
        
        self.placeHolderLabel.text = placeHolderString;
    }
}

- (void)setLeftSpace:(CGFloat)leftSpace
{
    _leftSpace = leftSpace;
    
    if (self.mainTextView.frame.size.width) {
        
        self.placeHolderLabel.frame = CGRectMake(leftSpace, self.placeHolderLabel.frame.origin.y, self.placeHolderLabel.frame.size.width-leftSpace, self.placeHolderLabel.frame.size.height);
        
        self.mainTextView.frame = CGRectMake(leftSpace-2, self.mainTextView.frame.origin.y, self.mainTextView.frame.size.width-leftSpace, self.mainTextView.frame.size.height);
    }else{
        
        [self.placeHolderLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading).offset(leftSpace);
        }];
        
        
        [self.mainTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading).offset(leftSpace-2);
        }];
    }
    
    
}

- (NSString *)contentString
{
    return self.mainTextView.text;
}
- (void)setContentString:(NSString *)contentString
{
    self.mainTextView.text = contentString;
    
    if (contentString.length > 0) {
        self.placeHolderLabel.hidden = YES;
    }
}

- (UILabel*)placeHolderLabel
{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc]init];
        _placeHolderLabel.textColor = [UIColor lightGrayColor];
        _placeHolderLabel.backgroundColor = [UIColor whiteColor];
        _placeHolderLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_placeHolderLabel];
        
        [self sendSubviewToBack:_placeHolderLabel];
        if (self.viewFrame.size.width > 0  && self.viewFrame.size.height > 0 ) {
            _placeHolderLabel.frame = CGRectMake(0, 0, self.viewFrame.size.width, self.viewFrame.size.height);
        }else{
            //设置UI布局约束
            [_placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self.mas_top).offset(0);//元素顶部约束
                make.leading.equalTo(self.mas_leading).offset(0);//元素左侧约束
                make.trailing.equalTo(self.mas_trailing).offset(0);//元素右侧约束
                make.height.mas_equalTo(36);
            }];
        }
        
        
    }
    return _placeHolderLabel;
}

- (void)setPlaceLabelFrame:(CGRect)placeLabelFrame
{
    _placeLabelFrame = placeLabelFrame;
    
    if (self.placeHolderLabel) {
        self.placeHolderLabel.frame = placeLabelFrame;
    }
}

#pragma mark - textField代理




#pragma mark - textField代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    if (![string isEqualToString:@""]) {
        
        //输入只要不是删除键，则把自定义的placeHolder隐藏了
        self.placeHolderLabel.hidden = YES;
        
    }
    
    
    
    if ([string isEqualToString:@""] && range.location == 0 && range.length == 1) {
        
        //输入删除键后，没有字符了，把自定义的placeHolder显示了
        self.placeHolderLabel.hidden = NO;
        
    }
    
    if (self.canInputLength > 0 && textField.text.length == self.canInputLength && ![string isEqualToString:@""]) {
        //如果限制了输入长度，且原先的文本长度已经达到了限制长度，且输入的的不是删除键，则不允许输入内容
        return NO;
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""]) {
        
        //输入只要不是删除键，则把自定义的placeHolder隐藏了
        self.placeHolderLabel.hidden = YES;
        
    }
    
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        
        //输入删除键后，没有字符了，把自定义的placeHolder显示了
        self.placeHolderLabel.hidden = NO;
        
    }
    
    if (self.canInputLength > 0 && textView.text.length == self.canInputLength && ![text isEqualToString:@""]) {
        //如果限制了输入长度，且原先的文本长度已经达到了限制长度，且输入的的不是删除键，则不允许输入内容
        return NO;
    }
    
    return YES;
}



- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.placeHolderLabel.hidden = YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.block) {
        self.block(textView.text);
    }
}


- (void)loadEndEditingText:(void(^)(NSString *contentString))block
{
    if (block) {
        self.block = block;
    }
}

- (void)loadReturnKeyAction:(ReturnKeyBlock)block
{
    if (block) {
        self.returnBlock = block;
    }
}



- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    _keyboardType = keyboardType;
    
    self.mainTextView.keyboardType = keyboardType;
}

- (void)setReturnType:(UIReturnKeyType)returnType
{
    _returnType = returnType;
    self.mainTextView.returnKeyType = returnType;
}

- (void)setTextForUser:(NSString *)textForUser
{
    _textForUser = textForUser;
    
    self.mainTextView.text = textForUser;
    
    if (self.mainTextView.text.length > 0) {
        self.placeHolderLabel.hidden = YES;
    }
}




@end

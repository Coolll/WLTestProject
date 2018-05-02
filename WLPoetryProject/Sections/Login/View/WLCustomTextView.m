//
//  WLCustomTextView.m
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/14.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "WLCustomTextView.h"

typedef void(^CustomTextBlock)(NSString *string);
@interface WLCustomTextView ()<UITextFieldDelegate>
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




@end

@implementation WLCustomTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.viewFrame = frame;
        self.mainTextField = [[WLTextField alloc]init];
        self.mainTextField.delegate = self;
        self.mainTextField.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
//        self.mainTextField.tintColor = [UIColor blackColor];
        
        [self addSubview:self.mainTextField];
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
    
    self.placeHolderLabel.frame = CGRectMake(leftSpace, self.placeHolderLabel.frame.origin.y, self.placeHolderLabel.frame.size.width-leftSpace, self.placeHolderLabel.frame.size.height);
    
    self.mainTextField.frame = CGRectMake(leftSpace-2, self.mainTextField.frame.origin.y, self.mainTextField.frame.size.width-leftSpace, self.mainTextField.frame.size.height);

}

- (NSString *)contentString
{
    return self.mainTextField.text;
}
- (void)setContentString:(NSString *)contentString
{
    self.mainTextField.text = contentString;
    
    if (contentString.length > 0) {
        self.placeHolderLabel.hidden = YES;
    }
}

- (UILabel*)placeHolderLabel
{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc]init];
        _placeHolderLabel.frame = CGRectMake(0, 0, self.viewFrame.size.width, self.viewFrame.size.height);
        _placeHolderLabel.textColor = [UIColor lightGrayColor];
        _placeHolderLabel.backgroundColor = [UIColor whiteColor];
        _placeHolderLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_placeHolderLabel];
        
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

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if (![text isEqualToString:@""]) {
//        
//        //输入只要不是删除键，则把自定义的placeHolder隐藏了
//        self.placeHolderLabel.hidden = YES;
//        
//    }
//    
//    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1 && textView.text.length == 0) {
//        
//        //输入删除键后，没有字符了，把自定义的placeHolder显示了
//        self.placeHolderLabel.hidden = NO;
//        
//    }
//
//    return YES;
//}


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
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.text.length > 0) {
        self.placeHolderLabel.hidden = YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.block) {
        self.block(textField.text);
    }
}

- (void)loadEndEditingText:(void(^)(NSString *contentString))block
{
    if (block) {
        self.block = block;
    }
}



- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    _keyboardType = keyboardType;
    
    self.mainTextField.keyboardType = keyboardType;
}

- (void)setTextForUser:(NSString *)textForUser
{
    _textForUser = textForUser;
    
    self.mainTextField.text = textForUser;
    
    if (self.mainTextField.text.length > 0) {
        self.placeHolderLabel.hidden = YES;
    }
}





@end

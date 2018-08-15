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
        [self addSubview:self.mainTextField];
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.mainTextField = [[WLTextField alloc]init];
        self.mainTextField.delegate = self;
        [self addSubview:self.mainTextField];
        
        //设置UI布局约束
        [self.mainTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            
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
    
    if (self.mainTextField.frame.size.width) {
        
        self.placeHolderLabel.frame = CGRectMake(leftSpace, self.placeHolderLabel.frame.origin.y, self.placeHolderLabel.frame.size.width-leftSpace, self.placeHolderLabel.frame.size.height);
        
        self.mainTextField.frame = CGRectMake(leftSpace-2, self.mainTextField.frame.origin.y, self.mainTextField.frame.size.width-leftSpace, self.mainTextField.frame.size.height);
    }else{
        
        [self.placeHolderLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading).offset(leftSpace);
        }];
        
        
        [self.mainTextField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading).offset(leftSpace-2);
        }];
    }
    

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
        _placeHolderLabel.textColor = [UIColor lightGrayColor];
        _placeHolderLabel.backgroundColor = [UIColor whiteColor];
        _placeHolderLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_placeHolderLabel];
        
        if (self.viewFrame.size.width > 0  && self.viewFrame.size.height > 0 ) {
            _placeHolderLabel.frame = CGRectMake(0, 0, self.viewFrame.size.width, self.viewFrame.size.height);
        }else{
            //设置UI布局约束
            [_placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self.mas_top).offset(0);//元素顶部约束
                make.leading.equalTo(self.mas_leading).offset(0);//元素左侧约束
                make.trailing.equalTo(self.mas_trailing).offset(0);//元素右侧约束
                make.bottom.equalTo(self.mas_bottom).offset(0);//元素底部约束
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

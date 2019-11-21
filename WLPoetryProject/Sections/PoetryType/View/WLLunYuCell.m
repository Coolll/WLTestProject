//
//  WLLunYuCell.m
//  WLPoetryProject
//
//  Created by 龙培 on 2019/4/5.
//  Copyright © 2019年 龙培. All rights reserved.
//

#import "WLLunYuCell.h"
@interface WLLunYuCell()
/**
 *  内容label
 **/
@property (nonatomic,strong) UILabel *contentLabel;
/**
 *  来源label
 **/
@property (nonatomic,strong) UILabel *sourceLabel;
/**
 *  注解label
 **/
@property (nonatomic,strong) UILabel *transLabel;

/**
 *  底部横线
 **/
@property (nonatomic,strong) UIImageView *lineView;
@end
@implementation WLLunYuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(PoetryModel *)model
{
    _model = model;

    self.transferString = model.transferInfo;
    
    self.contentLabel.text = model.content;
    self.transLabel.text = model.transferInfo;
    self.sourceLabel.text = [NSString stringWithFormat:@"——《%@》",model.sourceExplain];
    
    CGFloat height = [WLPublicTool heightForTextString:model.content width:(PhoneScreen_WIDTH-20) font:[UIFont systemFontOfSize:16.f]]+4;
    //元素的布局
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(height);
        
    }];
    
    CGFloat transferHeight = [WLPublicTool heightForTextString:model.transferInfo width:(PhoneScreen_WIDTH-20) font:[UIFont systemFontOfSize:14.f]]+4;
    //元素的布局
    [self.transLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(transferHeight);
        
    }];
    
    
    
}

- (void)setShowTransfer:(BOOL)showTransfer
{
    _showTransfer = showTransfer;
    if (showTransfer) {
        if (!self.transLabel) {
            self.transLabel = [[UILabel alloc]init];
            self.transLabel.font = [UIFont systemFontOfSize:14.f];
            self.transLabel.numberOfLines = 0;
            self.transLabel.textColor = [UIColor colorWithRed:53/255.f green:162/255.f blue:250/255.f alpha:1.0];
            [self.contentView addSubview:self.transLabel];
            //元素的布局
            [self.transLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.equalTo(self.contentView.mas_leading).offset(10);
                make.top.equalTo(self.sourceLabel.mas_bottom).offset(6);
                make.trailing.equalTo(self.contentView.mas_trailing).offset(-10);
                
            }];
        }
    }else{
        [self.transLabel removeFromSuperview];
        self.transLabel = nil;
    }
}
- (void)loadCellContent
{
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.font = [UIFont systemFontOfSize:16.f];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    //元素的布局
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        
    }];
    
    self.sourceLabel = [[UILabel alloc]init];
    self.sourceLabel.font = [UIFont systemFontOfSize:14.f];
    self.sourceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.sourceLabel];
    //元素的布局
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentLabel.mas_left).offset(0);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(6);
        make.right.equalTo(self.contentLabel.mas_right).offset(0);
        make.height.mas_equalTo(24);
    }];
    
    
    
    if (!self.lineView) {
        self.lineView = [[UIImageView alloc]init];
        self.lineView.image = [UIImage imageNamed:@"lineImage"];
        [self.contentView addSubview:self.lineView];
        //元素的布局
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.height.mas_equalTo(1);
            
        }];
    }
}

+ (CGFloat)heightForCellWithModel:(PoetryModel *)model isShow:(BOOL)isShow
{
    NSString *string = model.content;
    CGFloat contentHeight = [WLPublicTool heightForTextString:string width:(PhoneScreen_WIDTH-20) font:[UIFont systemFontOfSize:16.f]]+4;
    
    
    if (isShow) {
        NSString *transfer = model.transferInfo;
        CGFloat transferHeight = [WLPublicTool heightForTextString:transfer width:(PhoneScreen_WIDTH-20) font:[UIFont systemFontOfSize:14.f]]+4;
        return contentHeight + 50 + transferHeight;
    }else{
        return contentHeight+50;
    }
    return contentHeight+50;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

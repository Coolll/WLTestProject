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


@end
@implementation WLLunYuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(PoetryModel *)model
{
    _model = model;
    self.contentString = model.content;
    self.transferString = model.transferInfo;
    self.source = model.source;
    [self loadCellContent];
}

- (void)loadCellContent
{
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.text = self.contentString;
    self.contentLabel.font = [UIFont systemFontOfSize:16.f];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    CGFloat height = [WLPublicTool heightForTextString:self.contentString width:(PhoneScreen_WIDTH-20) font:[UIFont systemFontOfSize:16.f]]+4;
    //元素的布局
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(height);
        
    }];
    
    self.sourceLabel = [[UILabel alloc]init];
    self.sourceLabel.text = self.source;
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
}

+ (CGFloat)heightForCellWithModel:(PoetryModel *)model isShow:(BOOL)isShow
{
    NSString *string = model.content;
    CGFloat height = [WLPublicTool heightForTextString:string width:(PhoneScreen_WIDTH-20) font:[UIFont systemFontOfSize:16.f]]+4;
    if (isShow) {
        
    }else{
        return height+8+24;
    }
    return 100;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

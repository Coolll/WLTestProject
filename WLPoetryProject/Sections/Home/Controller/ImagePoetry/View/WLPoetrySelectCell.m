//
//  WLPoetrySelectCell.m
//  WLPoetryProject
//
//  Created by 龙培 on 2021/7/15.
//  Copyright © 2021 龙培. All rights reserved.
//

#import "WLPoetrySelectCell.h"
@interface WLPoetrySelectCell()
/**
 *  图片
 **/
@property (nonatomic,strong) UIImageView *selectImageView;
/**
 *  文本
 **/
@property (nonatomic,strong) UILabel *myLabel;
@end

@implementation WLPoetrySelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadItems];
    }
    return self;
}

- (void)loadItems{
    self.selectImageView = [[UIImageView alloc]init];
    self.selectImageView.frame = CGRectMake(16, 13, 24, 24);
    self.selectImageView.image = [UIImage imageNamed:@"selectPoetryContent"];
    [self.contentView addSubview:self.selectImageView];
    
    self.myLabel = [[UILabel alloc]init];
    self.myLabel.frame = CGRectMake(48, 5, PhoneScreen_WIDTH-64, 40);
    self.myLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.myLabel];
}

- (void)setTextString:(NSString *)textString{
    _textString = textString;
    
    self.myLabel.text = textString;
}

- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    if (isSelect) {
        self.selectImageView.image = [UIImage imageNamed:@"selectPoetryContent"];
        self.myLabel.textColor = RGBCOLOR(25, 19, 0, 1);
    }else{
        self.selectImageView.image = [UIImage imageNamed:@"unselectPoetryContent"];
        self.myLabel.textColor = RGBCOLOR(136, 136, 136, 1);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

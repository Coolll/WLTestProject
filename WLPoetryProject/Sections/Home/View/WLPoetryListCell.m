//
//  WLPoetryListCell.m
//  WLPoetryProject
//
//  Created by 龙培 on 2018/4/21.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLPoetryListCell.h"

static const CGFloat lineWidth = 2;//四条线的lineW
static const CGFloat leftSpace = 10;//左右线条距离父视图的左右距离
static const CGFloat topSpce = 10;//上下线条距离父视图的底部距离
static const CGFloat itemSpace = 5;//元素之间的距离
static const CGFloat nameHeight = 25;//名字、作者等信息的高度

@interface WLPoetryListCell()
/**
 *  诗词名
 **/
@property (nonatomic,strong) UILabel *nameLabel;

/**
 *  作者名
 **/
@property (nonatomic,strong) UILabel *authorLabel;

/**
 *  诗词内容
 **/
@property (nonatomic,strong) UILabel *contentLabel;

/**
 *  上下左右的线条
 **/
@property (nonatomic,strong) UIView *topLine,*bottomLine,*leftLine,*rightLine;


@end
@implementation WLPoetryListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadCellContentView];
    }
    return self;
}

- (void)setDataModel:(PoetryModel *)dataModel
{
    _dataModel = dataModel;
    self.nameLabel.text = dataModel.name;
    self.authorLabel.text = dataModel.author;
    self.contentLabel.text = dataModel.firstLineString;
}

- (void)loadCellContentView
{
    
    self.leftLine = [[UIView alloc]init];
    self.leftLine.backgroundColor = RGBCOLOR(100, 100, 100, 1.0);
    [self addSubview:self.leftLine];
    
    self.rightLine = [[UIView alloc]init];
    self.rightLine.backgroundColor = RGBCOLOR(100, 100, 100, 1.0);
    [self addSubview:self.rightLine];
    
    self.topLine = [[UIView alloc]init];
    self.topLine.backgroundColor = RGBCOLOR(100, 100, 100, 1.0);
    [self addSubview:self.topLine];
    
    self.bottomLine = [[UIView alloc]init];
    self.bottomLine.backgroundColor = RGBCOLOR(100, 100, 100, 1.0);
    [self addSubview:self.bottomLine];
    
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont systemFontOfSize:16.f];
    [self addSubview:self.nameLabel];
   
    self.authorLabel = [[UILabel alloc]init];
    self.authorLabel.font = [UIFont systemFontOfSize:16.f];
    [self addSubview:self.authorLabel];
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.font = [UIFont systemFontOfSize:16.f];
    self.contentLabel.numberOfLines = 0;
    [self addSubview:self.contentLabel];
    
    [self loadViewLayout];
}

- (void)loadViewLayout
{
    
    
    //左侧线条的布局
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(leftSpace);
        make.top.equalTo(self.mas_top).offset(topSpce);
        make.bottom.equalTo(self.mas_bottom).offset(-topSpce);
        make.width.mas_equalTo(lineWidth);
    }];
    
    //右侧线条的布局
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.leftLine.mas_top).offset(0);
        make.bottom.equalTo(self.leftLine.mas_bottom).offset(0);
        make.right.equalTo(self.mas_right).offset(-leftSpace);
        make.width.mas_equalTo(lineWidth);
    }];
    
    //顶部线条的布局
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.leftLine.mas_right).offset(0);
        make.top.equalTo(self.leftLine.mas_top).offset(0);
        make.right.equalTo(self.rightLine.mas_left).offset(-0);
        make.height.mas_equalTo(lineWidth);
    }];
    
    //底部线条的布局
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.leftLine.mas_right).offset(0);
        make.bottom.equalTo(self.leftLine.mas_bottom).offset(0);
        make.right.equalTo(self.rightLine.mas_left).offset(-0);
        make.height.mas_equalTo(lineWidth);
    }];
    
    //诗词名字的布局
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.leftLine.mas_right).offset(itemSpace);
        make.top.equalTo(self.topLine.mas_bottom).offset(itemSpace);
        make.right.equalTo(self.rightLine.mas_left).offset(-itemSpace);
        make.height.mas_equalTo(nameHeight);
        
    }];

    //诗词作者的布局
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.leftLine.mas_right).offset(itemSpace);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(itemSpace);
        make.right.equalTo(self.rightLine.mas_left).offset(-itemSpace);
        make.height.mas_equalTo(nameHeight);
    }];
    
    //第一句诗词的布局
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.leftLine.mas_right).offset(itemSpace);
        make.top.equalTo(self.authorLabel.mas_bottom).offset(itemSpace);
        make.right.equalTo(self.rightLine.mas_left).offset(-itemSpace);

    }];
    

}

+ (CGFloat)heightForFirstLine:(PoetryModel*)model
{
    /*
     top
     linew
     itemspace
     nameHeight
     itemSpace
     nameHeight
     itemspace
     contentHeight
     itemspace
     lineW
     top
     */
    NSString *firstLine = model.firstLineString;
    
    CGFloat otherHeight = topSpce*2+lineWidth*2+itemSpace*4+nameHeight*2;
    CGFloat firstLineHeight = [WLPublicTool heightForTextString:firstLine width:(PhoneScreen_WIDTH-leftSpace*2-lineWidth*2-itemSpace*2) fontSize:16.f]+2;

    return otherHeight+firstLineHeight+5;//5为文本与底部横线的距离
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

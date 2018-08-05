//
//  WLHomePoetryCell.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/7/12.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLHomePoetryCell.h"
static const CGFloat lineWidth = 2;//四条线的lineW
static const CGFloat leftSpace = 15;//左右线条距离父视图的左右距离
static const CGFloat topSpce = 15;//上下线条距离父视图的底部距离
static const CGFloat itemSpace = 8;//元素之间的距离
static const CGFloat nameHeight = 25;//名字、作者等信息的高度


@interface WLHomePoetryCell()
/**
 *  背景
 **/
@property (nonatomic,strong) UIView *bgView;

/**
 *  诗词的作者
 **/
@property (nonatomic, strong) UIImageView *authorImageView;
/**
 *  作者的姓
 **/
@property (nonatomic, strong) UILabel *authorLastName;

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
@implementation WLHomePoetryCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setDataModel:(PoetryModel *)dataModel
{
    _dataModel = dataModel;
    [self loadCellContentView];
    
    
    self.nameLabel.text = dataModel.name;
    self.authorLabel.text = dataModel.author;
    self.contentLabel.text = dataModel.firstLineString;
    if (dataModel.author.length > 0) {
        self.authorLastName.text = [dataModel.author substringToIndex:1];
    }
}

- (void)loadCellContentView
{
    self.bgView.backgroundColor = [UIColor whiteColor];
    //元素的布局
    if (self.isLast) {
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(leftSpace);
            make.top.equalTo(self.mas_top).offset(topSpce*2);
            make.bottom.equalTo(self.mas_bottom).offset(-topSpce*2);
            make.right.equalTo(self.mas_right).offset(-leftSpace);
            
            
        }];
    }else{
        
        if (self.isFirst) {
            //有 题画 诗词 顶部间距减小
            [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self.mas_left).offset(leftSpace);
                make.top.equalTo(self.mas_top).offset(topSpce-10);
                make.bottom.equalTo(self.mas_bottom).offset(0);
                make.right.equalTo(self.mas_right).offset(-leftSpace);
                
                
            }];
        }else{
            [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self.mas_left).offset(leftSpace);
                make.top.equalTo(self.mas_top).offset(topSpce*2);
                make.bottom.equalTo(self.mas_bottom).offset(0);
                make.right.equalTo(self.mas_right).offset(-leftSpace);
                
                
            }];
        }
        
    }
    
    

    self.nameLabel.textColor = RGBCOLOR(60, 60, 60, 1.0);
    
    self.authorLabel.textColor = RGBCOLOR(40, 40, 40, 1.0);
    
    self.authorImageView.image = [UIImage imageNamed:@"homeAuthorBg"];
    
    self.authorLastName.numberOfLines = 1;
    
    self.contentLabel.textColor = RGBCOLOR(20, 20, 20, 1.0);
    
    [self loadViewLayouts];
}



- (void)loadViewLayouts
{
    
    //设置UI布局约束
    [self.authorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bgView.mas_top).offset(10);//元素顶部约束
        make.trailing.equalTo(self.bgView.mas_trailing).offset(-10);//元素右侧侧约束
        make.width.mas_equalTo(40);//元素宽度
        make.height.mas_equalTo(40);//元素高度
    }];
    
    //设置UI布局约束
    [self.authorLastName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.authorImageView.mas_top).offset(8);//元素顶部约束
        make.leading.equalTo(self.authorImageView.mas_leading).offset(8);//元素左侧约束
        make.trailing.equalTo(self.authorImageView.mas_trailing).offset(-8);//元素右侧约束
        make.bottom.equalTo(self.authorImageView.mas_bottom).offset(-8);//元素底部约束
        
    }];
    
    //诗词名字的布局
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.bgView.mas_leading).offset(itemSpace);
        make.top.equalTo(self.bgView.mas_top).offset(itemSpace);
        make.trailing.equalTo(self.authorImageView.mas_leading).offset(-itemSpace);
        make.height.mas_equalTo(nameHeight);
        
    }];
    
    //诗词作者的布局
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.nameLabel.mas_leading).offset(0);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(itemSpace);
        make.right.equalTo(self.nameLabel.mas_right).offset(0);
        make.height.mas_equalTo(nameHeight);
    }];
    
    //第一句诗词的布局
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLabel.mas_left).offset(0);
        make.top.equalTo(self.authorLabel.mas_bottom).offset(itemSpace);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
        
    }];
    
    
}


+ (CGFloat)heightForLastCell:(PoetryModel*)model
{
    return [self heightForFirstLine:model]+topSpce*2;
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
    
    return otherHeight+firstLineHeight;//5为文本与底部横线的距离
}

- (UIView*)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.layer.cornerRadius = 4.f;
        [self addSubview:_bgView];
    }
    return _bgView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:16.f];
        _nameLabel.numberOfLines = 1;
        [self.bgView addSubview:_nameLabel];
    }
    return _nameLabel;
}
- (UILabel *)authorLabel
{
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc]init];
        _authorLabel.font = [UIFont systemFontOfSize:14.f];
        _authorLabel.numberOfLines = 1;
        [self.bgView addSubview:_authorLabel];
    }
    return _authorLabel;
}

- (UIImageView*)authorImageView
{
    if (!_authorImageView) {
        _authorImageView = [[UIImageView alloc]init];
        [self.bgView addSubview:_authorImageView];
        
    }
    return _authorImageView;
}

- (UILabel*)authorLastName
{
    if (!_authorLastName) {
        _authorLastName = [[UILabel alloc]init];
        _authorLastName.font = [UIFont boldSystemFontOfSize:16.f];
        _authorLastName.textAlignment = NSTextAlignmentCenter;
        [self.authorImageView addSubview:_authorLastName];
    }
    return _authorLastName;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:16.f];
        _contentLabel.numberOfLines = 0;
        [self.bgView addSubview:_contentLabel];
    }
    return _contentLabel;
}
@end

//
//  SearchPoetryCell.m
//  WLPoetryProject
//
//  Created by 变啦 on 2019/11/19.
//  Copyright © 2019 龙培. All rights reserved.
//

#import "SearchPoetryCell.h"
static const CGFloat lineWidth = 2;//四条线的lineW
static const CGFloat leftSpace = 15;//左右线条距离父视图的左右距离
static const CGFloat topSpce = 5;//上下线条距离父视图的底部距离
static const CGFloat itemSpace = 8;//元素之间的距离
static const CGFloat nameHeight = 25;//名字、作者等信息的高度

@interface SearchPoetryCell()
/**
 *  背景
 **/
@property (nonatomic,strong) UIView *bgView;


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
 *  分割线
 **/
@property (nonatomic,strong) UIView *lineView;





@end
@implementation SearchPoetryCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

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
    if (!_nameLabel || !_authorLabel || !_contentLabel) {
        [self loadCellContentView];
    }
    self.frame = CGRectMake(0, 0, PhoneScreen_WIDTH, dataModel.heightForCell);
    
    [self dealDifferentCell];
    self.nameLabel.text = dataModel.name;
    self.authorLabel.text = dataModel.author;
    self.contentLabel.text = dataModel.firstLineString;
}

- (void)dealDifferentCell
{
    
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.mas_leading).offset(leftSpace);
        make.top.equalTo(self.mas_top).offset(topSpce);
        make.bottom.equalTo(self.mas_bottom).offset(-topSpce);
        make.trailing.equalTo(self.mas_trailing).offset(-leftSpace);
        
    }];
    
}
- (void)loadCellContentView
{
    self.bgView = [[UIView alloc]init];
    self.bgView.layer.cornerRadius = 4.f;
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    
    
    self.nameLabel.textColor = RGBCOLOR(60, 60, 60, 1.0);
    
    self.authorLabel.textColor = RGBCOLOR(40, 40, 40, 1.0);
    
    self.contentLabel.textColor = RGBCOLOR(20, 20, 20, 1.0);
    
    self.lineView.backgroundColor = RGBCOLOR(240, 240, 240, 1.0);

    [self loadViewLayouts];
}

- (void)loadLineWithRadius:(CGFloat)radius withTopSpace:(CGFloat)topSpace withLeftSpace:(CGFloat)leftSpace
{
    UIColor *lineColor = RGBCOLOR(103, 172, 58, 1.0);
    
    CGFloat width = PhoneScreen_WIDTH;
    CGFloat height = [SearchPoetryCell heightForFirstLine:_dataModel];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(leftSpace+radius, topSpace)];
    [path addLineToPoint:CGPointMake(width-leftSpace-radius, topSpace)];
    [path addArcWithCenter:CGPointMake(width-leftSpace-radius,topSpace+radius) radius:radius startAngle:-(M_PI_2) endAngle:0 clockwise:YES];
    
    [path addLineToPoint:CGPointMake(width-leftSpace,height-topSpace-radius)];
    [path addArcWithCenter:CGPointMake(width-leftSpace-radius, height-topSpace-radius) radius:radius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(leftSpace+radius, height-topSpace)];
    [path addArcWithCenter:CGPointMake(leftSpace+radius, height-topSpace-radius) radius:radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(leftSpace, topSpace+radius)];
    [path addArcWithCenter:CGPointMake(leftSpace+radius, topSpace+radius) radius:radius startAngle:M_PI endAngle:M_PI_2*3 clockwise:YES];
    
    layer.path = path.CGPath;
    layer.strokeColor = lineColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 0.8;
    
    [self.layer addSublayer:layer];
}

- (void)loadViewLayouts
{
    //诗词名字的布局
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.bgView.mas_leading).offset(itemSpace);
        make.top.equalTo(self.bgView.mas_top).offset(itemSpace);
        make.trailing.equalTo(self.bgView.mas_trailing).offset(-itemSpace);
        make.height.mas_equalTo(nameHeight);
        
    }];
    
    //诗词作者的布局
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.mas_leading).offset(leftSpace+ itemSpace);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(itemSpace);
        make.trailing.equalTo(self.nameLabel.mas_trailing).offset(0);
        make.height.mas_equalTo(nameHeight);
    }];
    
    //第一句诗词的布局
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.nameLabel.mas_leading).offset(0);
        make.top.equalTo(self.authorLabel.mas_bottom).offset(itemSpace);
        make.trailing.equalTo(self.nameLabel.mas_trailing).offset(0);
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

- (UIView*)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        [self addSubview:_lineView];
        
        //元素的布局
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.mas_leading).offset(leftSpace);
            make.bottom.equalTo(self.mas_bottom).offset(-1);
            make.trailing.equalTo(self.mas_trailing).offset(-leftSpace);
            make.height.mas_equalTo(0.7);
            
        }];
    }
    return _lineView;
}

@end

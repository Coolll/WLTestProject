//
//  WLPoetryListCell.m
//  WLPoetryProject
//
//  Created by 龙培 on 2018/4/21.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLPoetryListCell.h"

static const CGFloat lineWidth = 2;//四条线的lineW
static const CGFloat leftSpace = 15;//左右线条距离父视图的左右距离
static const CGFloat topSpce = 15;//上下线条距离父视图的底部距离
static const CGFloat itemSpace = 8;//元素之间的距离
static const CGFloat nameHeight = 25;//名字、作者等信息的高度

@interface WLPoetryListCell()
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
}

- (void)loadCellContentView
{
    self.bgView = [[UIView alloc]init];
    self.bgView.layer.cornerRadius = 4.f;
//    self.bgView.layer.borderColor = RGBCOLOR(103, 172, 58, 1.0).CGColor;
//    self.bgView.layer.borderWidth = 0.8;
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    //元素的布局
    if (self.isLast) {
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(leftSpace);
            make.top.equalTo(self.mas_top).offset(topSpce*2);
            make.bottom.equalTo(self.mas_bottom).offset(-topSpce*2);
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
    
//    [self loadLineWithRadius:4 withTopSpace:topSpce withLeftSpace:leftSpace];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:16.f];
    self.nameLabel.textColor = RGBCOLOR(60, 60, 60, 1.0);
    [self.bgView addSubview:self.nameLabel];
   
    self.authorLabel = [[UILabel alloc]init];
    self.authorLabel.font = [UIFont systemFontOfSize:14.f];
    self.nameLabel.textColor = RGBCOLOR(40, 40, 40, 1.0);
    [self.bgView addSubview:self.authorLabel];
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.font = [UIFont systemFontOfSize:16.f];
    self.contentLabel.textColor = RGBCOLOR(20, 20, 20, 1.0);
    self.contentLabel.numberOfLines = 0;
    [self.bgView addSubview:self.contentLabel];
    
    [self loadViewLayouts];
}

- (void)loadLineWithRadius:(CGFloat)radius withTopSpace:(CGFloat)topSpace withLeftSpace:(CGFloat)leftSpace
{
    UIColor *lineColor = RGBCOLOR(103, 172, 58, 1.0);

    CGFloat width = PhoneScreen_WIDTH;
    CGFloat height = [WLPoetryListCell heightForFirstLine:_dataModel];
    
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
        
        make.left.equalTo(self.bgView.mas_left).offset(itemSpace);
        make.top.equalTo(self.bgView.mas_top).offset(itemSpace);
        make.right.equalTo(self.bgView.mas_right).offset(-itemSpace);
        make.height.mas_equalTo(nameHeight);
        
    }];
    
    //诗词作者的布局
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(leftSpace+ itemSpace);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(itemSpace);
        make.right.equalTo(self.nameLabel.mas_right).offset(0);
        make.height.mas_equalTo(nameHeight);
    }];
    
    //第一句诗词的布局
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLabel.mas_left).offset(0);
        make.top.equalTo(self.authorLabel.mas_bottom).offset(itemSpace);
        make.right.equalTo(self.nameLabel.mas_right).offset(0);
        
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



//-------
//@interface WLPoetryListCell()
///**
// *  诗词名
// **/
//@property (nonatomic,strong) UILabel *nameLabel;
//
///**
// *  作者名
// **/
//@property (nonatomic,strong) UILabel *authorLabel;
//
///**
// *  诗词内容
// **/
//@property (nonatomic,strong) UILabel *contentLabel;
//
///**
// *  上下左右的线条
// **/
//@property (nonatomic,strong) UIView *topLine,*bottomLine,*leftLine,*rightLine;
//
//
//@end
//@implementation WLPoetryListCell
//
//- (void)awakeFromNib {
//    [super awakeFromNib];
//}
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//
//    }
//    return self;
//}
//
//- (void)setDataModel:(PoetryModel *)dataModel
//{
//    _dataModel = dataModel;
//    [self loadCellContentView];
//
//
//    self.nameLabel.text = dataModel.name;
//    self.authorLabel.text = dataModel.author;
//    self.contentLabel.text = dataModel.firstLineString;
//}
//
//- (void)loadCellContentView
//{
//
//    [self loadLineWithRadius:4 withTopSpace:leftSpace withLeftSpace:topSpce];
//
//    self.nameLabel = [[UILabel alloc]init];
//    self.nameLabel.font = [UIFont boldSystemFontOfSize:16.f];
//    self.nameLabel.textColor = RGBCOLOR(60, 60, 60, 1.0);
//    [self addSubview:self.nameLabel];
//
//    self.authorLabel = [[UILabel alloc]init];
//    self.authorLabel.font = [UIFont systemFontOfSize:14.f];
//    self.nameLabel.textColor = RGBCOLOR(40, 40, 40, 1.0);
//    [self addSubview:self.authorLabel];
//
//    self.contentLabel = [[UILabel alloc]init];
//    self.contentLabel.font = [UIFont systemFontOfSize:16.f];
//    self.contentLabel.textColor = RGBCOLOR(20, 20, 20, 1.0);
//    self.contentLabel.numberOfLines = 0;
//    [self addSubview:self.contentLabel];
//
//    [self loadViewLayouts];
//}
//
//- (void)loadLineWithRadius:(CGFloat)radius withTopSpace:(CGFloat)topSpace withLeftSpace:(CGFloat)leftSpace
//{
//    UIColor *lineColor = RGBCOLOR(103, 172, 58, 1.0);
//
//    CGFloat width = PhoneScreen_WIDTH;
//    CGFloat height = [WLPoetryListCell heightForFirstLine:_dataModel];
//
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(leftSpace+radius, topSpace)];
//    [path addLineToPoint:CGPointMake(width-leftSpace-radius, topSpace)];
//    [path addArcWithCenter:CGPointMake(width-leftSpace-radius,topSpace+radius) radius:radius startAngle:-(M_PI_2) endAngle:0 clockwise:YES];
//
//    [path addLineToPoint:CGPointMake(width-leftSpace,height-topSpace-radius)];
//    [path addArcWithCenter:CGPointMake(width-leftSpace-radius, height-topSpace-radius) radius:radius startAngle:0 endAngle:M_PI_2 clockwise:YES];
//    [path addLineToPoint:CGPointMake(leftSpace+radius, height-topSpace)];
//    [path addArcWithCenter:CGPointMake(leftSpace+radius, height-topSpace-radius) radius:radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
//    [path addLineToPoint:CGPointMake(leftSpace, topSpace+radius)];
//    [path addArcWithCenter:CGPointMake(leftSpace+radius, topSpace+radius) radius:radius startAngle:M_PI endAngle:M_PI_2*3 clockwise:YES];
//
//    layer.path = path.CGPath;
//    layer.strokeColor = lineColor.CGColor;
//    layer.fillColor = [UIColor clearColor].CGColor;
//    layer.lineWidth = 0.8;
//
//    [self.layer addSublayer:layer];
//}
//
//- (void)loadViewLayouts
//{
//    //诗词名字的布局
//    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(self.mas_left).offset(leftSpace+itemSpace);
//        make.top.equalTo(self.mas_top).offset(topSpce+itemSpace);
//        make.right.equalTo(self.mas_right).offset(-itemSpace-leftSpace);
//        make.height.mas_equalTo(nameHeight);
//
//    }];
//
//    //诗词作者的布局
//    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(self.mas_left).offset(leftSpace+ itemSpace);
//        make.top.equalTo(self.nameLabel.mas_bottom).offset(itemSpace);
//        make.right.equalTo(self.nameLabel.mas_right).offset(0);
//        make.height.mas_equalTo(nameHeight);
//    }];
//
//    //第一句诗词的布局
//    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(self.nameLabel.mas_left).offset(0);
//        make.top.equalTo(self.authorLabel.mas_bottom).offset(itemSpace);
//        make.right.equalTo(self.nameLabel.mas_right).offset(0);
//
//    }];
//
//
//}
//
//
//
//+ (CGFloat)heightForFirstLine:(PoetryModel*)model
//{
//    /*
//     top
//     linew
//     itemspace
//     nameHeight
//     itemSpace
//     nameHeight
//     itemspace
//     contentHeight
//     itemspace
//     lineW
//     top
//     */
//    NSString *firstLine = model.firstLineString;
//
//    CGFloat otherHeight = topSpce*2+lineWidth*2+itemSpace*4+nameHeight*2;
//    CGFloat firstLineHeight = [WLPublicTool heightForTextString:firstLine width:(PhoneScreen_WIDTH-leftSpace*2-lineWidth*2-itemSpace*2) fontSize:16.f]+2;
//
//    return otherHeight+firstLineHeight+5;//5为文本与底部横线的距离
//}
//





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  WLRecitePoetryCell.m
//  WLPoetryProject
//
//  Created by 变啦 on 2018/11/7.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLRecitePoetryCell.h"
@interface WLRecitePoetryCell()
/**
 *  内容label
 **/
@property (nonatomic,strong) UILabel *contentLabel;
/**
 *  是否触摸
 */
@property (nonatomic,assign) BOOL isTouch;
/**
 *  覆盖的图片
 */
@property (nonatomic,strong) UIImageView *coverImageView;

@end
@implementation WLRecitePoetryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadContentView];
    }
    return self;
}

- (void)loadContentView
{
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.font = [AppConfig config].contentFont;
    self.contentLabel.textColor = RGBCOLOR(60, 60, 120, 1.0);
    [self.contentView addSubview:self.contentLabel];
    //元素的布局
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.contentView.mas_leading).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-10);
        
    }];
    
    
//    UIImageView *lineImageView = [[UIImageView alloc]init];
//    lineImageView.image = [UIImage imageNamed:@"lineImage"];
//    [self.contentLabel addSubview:lineImageView];
//    //元素的布局
//    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.leading.equalTo(self.contentLabel.mas_leading).offset(0);
//        make.top.equalTo(self.contentLabel.mas_bottom).offset(1);
//        make.trailing.equalTo(self.contentLabel.mas_trailing).offset(0);
//        make.height.mas_equalTo(0.8);
//
//    }];
}

- (void)setContentString:(NSString *)contentString
{
    _contentString = contentString;
    if ([contentString isKindOfClass:[NSString class]] && contentString.length > 0) {
        self.contentLabel.text = contentString;
        CGFloat width = [WLPublicTool widthForTextString:contentString height:self.cellHeight fontSize:[AppConfig config].contentFont.pointSize]+6;
        [self.coverImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX).offset(-2);
            make.width.mas_equalTo(width);
            make.top.equalTo(self.contentView.mas_top).offset(5);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isTouch = YES;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isTouch) {
        // 开启上下文
        UIGraphicsBeginImageContext(self.coverImageView.frame.size);
        // 将图片绘制到图形上下文中
        [self.coverImageView.image drawInRect:self.coverImageView.bounds];
        // 清空手指触摸的位置
        // 拿到手指,根据手指的位置,让对应的位置成为透明
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:touch.view];
        CGRect rect = CGRectMake(point.x - 10, point.y - 10, 20, 20);
        // 清空rect
        CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
        
        // 取出会之后的图片赋值给imageB
        self.coverImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        // 关闭图形上下文
        UIGraphicsEndImageContext();
    }
}
- (void)setNeedHide:(BOOL)needHide
{
    _needHide = needHide;
    if (needHide) {
        self.coverImageView.hidden = NO;
    }else{
        self.coverImageView.hidden = YES;
    }
    
}
+ (CGFloat)heightForContent:(NSString*)content withWidth:(CGFloat)width
{
    
    CGFloat contentHeight = [WLPublicTool heightForTextString:content width:width fontSize:[AppConfig config].contentFont.pointSize]+2;
    
    if (contentHeight < 40) {
        return 40;
    }
    return contentHeight;
}


- (UIImageView*)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc]init];
        _coverImageView.image = [UIImage imageNamed:@"cover"];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.hidden = YES;
        [self.contentView addSubview:_coverImageView];
        //元素的布局
        [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.contentView.mas_leading).offset(0);
            make.top.equalTo(self.contentView.mas_top).offset(0);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
            make.trailing.equalTo(self.contentView.mas_trailing).offset(0);
            
        }];
    }
    return _coverImageView;
}
@end

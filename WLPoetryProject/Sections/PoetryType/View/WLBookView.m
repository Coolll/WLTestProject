//
//  WLBookView.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/7/10.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLBookView.h"
@interface WLBookView ()
/**
 *  点击的block
 **/
@property (nonatomic,copy) BookViewClickBlock block;

/**
 *  视图的宽度和高度
 **/
@property (nonatomic,assign) CGFloat viewWidth,viewHeight;


@end
@implementation WLBookView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewWidth = frame.size.width;
        self.viewHeight = frame.size.height;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)loadCustomView
{
    CGFloat cornerR = 6;
    
    CGFloat leftSpace = 10;//书本与主视图左侧间距
    CGFloat topSpace = 10;//书本与主视图顶部间距
    CGFloat labelHeight = 0;//底部的标题高度
    CGFloat lineWidth = 3;//右侧分割线的宽度
    
    //除去左右间距以及线条宽度剩余的宽度
    CGFloat totalWidthLeft = self.viewWidth-leftSpace*2-lineWidth;
    //除去上下间距以及label剩余的高度
    CGFloat totalHeightLeft = self.viewHeight-topSpace*2-labelHeight;
    
    //左侧的宽度占5/6
    CGFloat leftWidth = totalWidthLeft*5/6.f;
    //右侧的宽度1/6
    CGFloat rightWidth = totalWidthLeft/6.f;
    
    //背景颜色
    UIColor *bgColor = RGBCOLOR(200, 200, 200, 1.0);
    
    //左侧主视图
    UIView *leftMainView = [[UIView alloc]initWithFrame:CGRectMake(leftSpace, topSpace, leftWidth, totalHeightLeft)];
    leftMainView.backgroundColor = bgColor;
    [self addSubview:leftMainView];
    
    //添加圆角
    [[WLPublicTool shareTool] addCornerForView:leftMainView withTopLeft:YES withTopRight:NO withBottomLeft:YES withBottomRight:NO withCornerRadius:cornerR];
    
    //书名的宽度
    CGFloat nameWidth = 20;
    //书名的左侧间距 与左侧主视图
    CGFloat nameLeft = 20;
    //书名的顶部间距 与左侧主视图
    CGFloat nameTop = 20;
    //书名的高度
    CGFloat nameHeight = 60;
    //书名与线条的间距
    CGFloat nameSpace = 5;
    
    //线条
    UIView *nameBgView = [[UIView alloc]initWithFrame:CGRectMake(nameLeft-nameSpace, nameTop-nameSpace, nameWidth+nameSpace*2, nameHeight+nameSpace*2)];
    nameBgView.backgroundColor = bgColor;
    nameBgView.layer.cornerRadius = 4.f;
    nameBgView.layer.borderColor = [UIColor whiteColor].CGColor;
    nameBgView.layer.borderWidth = 1.f;
    [leftMainView addSubview:nameBgView];
    
    //书名
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.frame = CGRectMake(nameLeft, nameTop, nameWidth, nameHeight);
    nameLabel.font = [UIFont systemFontOfSize:12.f];
    nameLabel.numberOfLines = 0;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.backgroundColor = [UIColor whiteColor];
    nameLabel.text = self.bookName;
    [leftMainView addSubview:nameLabel];
    
    
    NSInteger rateOne = 1;
    NSInteger rateTwo = 2;
    NSInteger rateThree = 3;
    CGFloat singleHeight = (totalHeightLeft-4*lineWidth)/(rateOne+rateTwo+rateThree+rateTwo+rateOne);
    CGFloat xPosition = leftSpace+leftWidth+lineWidth;
    
    
    UIView *rightOneView = [[UIView alloc]initWithFrame:CGRectMake(xPosition, topSpace, rightWidth, singleHeight)];
    rightOneView.backgroundColor = bgColor;
    [self addSubview:rightOneView];
    [[WLPublicTool shareTool] addCornerForView:rightOneView withTopLeft:NO withTopRight:YES withBottomLeft:NO withBottomRight:NO withCornerRadius:cornerR];
    
    UIView *rightTwoView = [[UIView alloc]initWithFrame:CGRectMake(xPosition, topSpace+singleHeight*rateOne+lineWidth, rightWidth, singleHeight*2)];
    rightTwoView.backgroundColor = bgColor;
    [self addSubview:rightTwoView];
    
    
    UIView *rightThreeView = [[UIView alloc]initWithFrame:CGRectMake(xPosition, topSpace+singleHeight*(rateOne+rateTwo)+lineWidth*2, rightWidth, singleHeight*rateThree)];
    rightThreeView.backgroundColor = bgColor;
    [self addSubview:rightThreeView];
    
    UIView *rightFourView = [[UIView alloc]initWithFrame:CGRectMake(xPosition, topSpace+singleHeight*(rateOne+rateTwo+rateThree)+lineWidth*3, rightWidth, singleHeight*rateTwo)];
    rightFourView.backgroundColor = bgColor;
    [self addSubview:rightFourView];
    
    UIView *righgFiveView = [[UIView alloc]initWithFrame:CGRectMake(xPosition, topSpace+singleHeight*(rateOne+rateTwo+rateThree+rateTwo)+lineWidth*4, rightWidth, singleHeight*rateOne)];
    righgFiveView.backgroundColor = bgColor;
    [self addSubview:righgFiveView];
    [[WLPublicTool shareTool]addCornerForView:righgFiveView withTopLeft:NO withTopRight:NO withBottomLeft:NO withBottomRight:YES withCornerRadius:cornerR];
    
    UILabel *bookLabel = [[UILabel alloc]init];
    bookLabel.frame = CGRectMake(0, topSpace+totalHeightLeft, self.viewWidth, labelHeight);
    bookLabel.textAlignment = NSTextAlignmentCenter;
    bookLabel.text = self.bookName;
    bookLabel.font = [UIFont systemFontOfSize:16.f];//字号设置
    [self addSubview:bookLabel];
    
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
    [clearBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clearBtn];
}

- (void)clickAction:(UIButton*)sender
{
    if (self.block) {
        self.block(self.index);
    }
}
- (void)clickBookWithBlock:(BookViewClickBlock)block
{
    if (block) {
        self.block = block;
    }
}




@end

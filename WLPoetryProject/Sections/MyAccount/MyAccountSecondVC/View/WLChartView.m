//
//  WLChartView.m
//  BLBalance
//
//  Created by 变啦 on 2018/10/17.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLChartView.h"
#import "WLShapeLayer.h"
@interface WLChartView()
/**
 *  layer数组，做动画用的
 **/
@property (nonatomic,strong) NSMutableArray *layerArray;
/**
 *  背景layer
 **/
@property (nonatomic,strong) NSMutableArray *bgLayerArray;

/**
 *  内容视图
 **/
@property (nonatomic,strong) UIView *mainView;



@end

@implementation WLChartView

- (void)configureView
{
    CGFloat labelH = 24;//底部label高度
    CGFloat contentLeft = 15;//主体视图的左侧间距
    
    self.mainView = [[UIView alloc]init];
    self.mainView.layer.cornerRadius = 6.f;
    self.mainView.backgroundColor = [UIColor whiteColor];
    self.mainView.layer.borderWidth = 1.0f;
    self.mainView.userInteractionEnabled = YES;
    self.mainView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self addSubview:self.mainView];
    self.userInteractionEnabled = YES;
    
    //元素的布局
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.mas_leading).offset(contentLeft);
        make.top.equalTo(self.mas_top).offset(0);
        make.width.mas_equalTo(self.viewW-contentLeft*2);
        make.height.mas_equalTo(self.viewH-labelH);//预留出label高度
        
    }];
    
    self.layerArray = [NSMutableArray array];
    self.bgLayerArray = [NSMutableArray array];
    
    //数据源总个数
    NSInteger chartCount = self.dataArray.count;
    //第一个柱子的左侧间距
    CGFloat firstLeft = self.leftSpace >= 0 ? self.leftSpace : 15;
    //视图减去框框外面的30，减去框框内部的间距 除以个数，得到单个的宽度（柱子+空白 总宽度）
    CGFloat itemW = (self.viewW - 30 - firstLeft*2)/chartCount;
    //单个柱子的宽度 = 总宽度*比例  如果没设置比例，则比例为0.5
    CGFloat wRate = (self.widthRate > 0 && self.widthRate < 1) ? self.widthRate : 0.5;
    CGFloat chartW = itemW*wRate;
    
    if (self.widthForChart > 0 && self.widthForChart < itemW) {
        //如果用户设置了单个柱子的宽度，则使用该宽度（前提是不能小于0，不能大于最大宽度）
        chartW = self.widthForChart;
        //微调一下单个元素的宽度 因为有3个柱子时，只有2个空白间隙
        //单元宽度（一个柱子+一个空白的宽度） = [（总宽度-框框外部的30-左右间距）-柱子总共的宽度 ]/空白的个数  +  柱子的宽度
        if (chartCount > 1) {
            itemW = ((self.viewW-30-firstLeft*2)-(chartCount*chartW))/(chartCount-1) + chartW;
        }else{
            //如果只有一个元素，则此时应该调整一下，否则除数无穷大了
            itemW = self.viewW-30-firstLeft*2;
        }
        
    }else{
        if (self.widthRate == 0) {
            self.widthRate = 0.5;
        }
        //如果用户没有设置柱子的的宽度，我们根据比例来算
        //单元宽度（一个柱子+一个空白的宽度） = （总宽度-框框外部的30-左右间距）/[ 柱子个数*柱子宽度比例  + 空白个数*空白宽度比例 ]
        itemW = (self.viewW-30-firstLeft*2)/((chartCount*self.widthRate)+(chartCount-1)*(1-self.widthRate));
        chartW = itemW * self.widthRate;
    }
    
    
    if (self.widthForSpace > 0 && self.widthForSpace + chartW < itemW) {
        itemW = self.widthForSpace + chartW;
    }
   
    
    //柱子的最大高度
    CGFloat chartMaxH = self.viewH-labelH-20;//最大高度为：视图高度-底部文本高度-20间距（不让柱子顶部抵着线了）
    
    //所有的数值中的最大值
    NSInteger max = self.maxValue;
    for (int i =0 ; i < self.dataArray.count ;i++ ) {
        NSInteger value = [self.dataArray[i] integerValue];
        max = value > max ? value : max;
    }
    
    
    //x的值
    CGFloat xValue = firstLeft;
    
    BOOL sameCount = NO;
    if (self.titleArray.count == self.dataArray.count) {
        sameCount = YES;
    }
    for (int i =0 ; i < self.dataArray.count ;i++ ) {
        NSInteger value = [self.dataArray[i] integerValue];
        //用当前值和最大值进行比较，比率乘以最大高度，得到当前的高度
        CGFloat chartH = value*chartMaxH/max;

        
        WLShapeLayer *layer = [WLShapeLayer layer];
        [self.mainView.layer addSublayer:layer];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(xValue+chartW/2, self.viewH-labelH)];
        [path addLineToPoint:CGPointMake(xValue+chartW/2, self.viewH- labelH - chartH)];
        layer.lineWidth = chartW;
        layer.strokeStart = 0;
        layer.strokeEnd = 0;
        layer.strokeColor = RGBCOLOR(59, 167, 249, 1.0).CGColor;
        layer.path = path.CGPath;
        layer.chartTopY = self.viewH-labelH-chartH;
        layer.chartCenterX = xValue + chartW/2;
        [self.layerArray addObject:layer];

        
        WLShapeLayer *bgLayer = [WLShapeLayer layer];
        bgLayer.fillColor = [UIColor clearColor].CGColor;
        [self.mainView.layer addSublayer:bgLayer];
        
        UIBezierPath *bgPath = [UIBezierPath bezierPath];
        [bgPath moveToPoint:CGPointMake(xValue, self.viewH-labelH)];
        [bgPath addLineToPoint:CGPointMake(xValue, self.viewH-labelH-chartMaxH)];
        [bgPath addLineToPoint:CGPointMake(xValue+itemW, self.viewH-labelH-chartMaxH)];
        [bgPath addLineToPoint:CGPointMake(xValue+itemW, self.viewH-labelH)];
        [bgPath addLineToPoint:CGPointMake(xValue, self.viewH-labelH)];
        bgLayer.path = bgPath.CGPath;
        [self.bgLayerArray addObject:bgLayer];

        
        
        if (sameCount) {
            //如果数据源和标题一一对应，则数据从titleArray中拿
            UILabel *label = [[UILabel alloc]init];
            label.text = [self.titleArray objectAtIndex:i];
            label.font = [UIFont systemFontOfSize:14.f];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            
            //元素的布局
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_leading).offset(contentLeft+xValue+chartW/2);
                make.top.equalTo(self.mainView.mas_bottom).offset(0);
                make.width.mas_equalTo(40);
                make.height.mas_equalTo(labelH);
                
            }];
        }else{
            //如果数据源和标题个数不对应，则说明title存在省略，数据从titleDic中获取
            for (int j = 0; j < self.titleDic.allKeys.count; j++) {
                NSInteger index = [[self.titleDic.allKeys objectAtIndex:j] integerValue];
                if (index == i) {
                    UILabel *label = [[UILabel alloc]init];
                    label.text = [self.titleDic.allValues objectAtIndex:j];
                    label.font = [UIFont systemFontOfSize:14.f];
                    label.textAlignment = NSTextAlignmentCenter;
                    [self addSubview:label];
                    
                    //元素的布局
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.mas_leading).offset(contentLeft+xValue+chartW/2);
                        make.top.equalTo(self.mainView.mas_bottom).offset(0);
                        make.width.mas_equalTo(40);
                        make.height.mas_equalTo(labelH);
                        
                    }];
                }
            }
        }
        
        
        xValue += itemW;
        
    }
    
    for (int i = 0; i < self.titleArray.count; i++ ) {
        
    }
    
    for (WLShapeLayer *layer in self.layerArray) {
        [self doCustomAnimationWithLayer:layer];
    }
    
    if (self.needAnimation) {
        
    }
    
}

- (void)doCustomAnimationWithLayer:(CAShapeLayer*)layer
{
    CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnimation.fromValue = @(0);
    
    if (_animateTime >0 ) {
        strokeAnimation.duration = _animateTime;
        
    }else{
        strokeAnimation.duration = 1;
    }
    
    strokeAnimation.toValue = @(1);
    strokeAnimation.autoreverses = NO;
    strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    strokeAnimation.removedOnCompletion = YES;
    [layer addAnimation:strokeAnimation forKey:@"strokeEnd"];
    layer.strokeEnd = 1;
}

#pragma mark - 点击事件

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.mainView];
    for (int i =0;i < self.bgLayerArray.count;i++) {
        WLShapeLayer *layer = self.bgLayerArray[i];
        if (CGPathContainsPoint(layer.path, 0, touchPoint, YES)) {
            NSLog(@"点击了bgLayer");
            WLShapeLayer *contentLayer = self.layerArray[i];
            contentLayer.supView = self.mainView;
            contentLayer.text = self.dataArray[i];
            contentLayer.isSelected = !contentLayer.isSelected;
        }else{
            WLShapeLayer *contentLayer = self.layerArray[i];
            contentLayer.supView = self.mainView;
            contentLayer.text = self.dataArray[i];
            contentLayer.isSelected = NO;
        }
        
        
    }
}

- (void)reloadChartView
{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self.layerArray removeAllObjects];
    [self configureView];
}

@end

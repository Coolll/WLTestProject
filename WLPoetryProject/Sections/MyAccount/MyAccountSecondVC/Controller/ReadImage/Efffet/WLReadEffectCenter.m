//
//  WLReadEffectCenter.m
//  WLPoetryProject
//
//  Created by 龙培 on 2020/10/29.
//  Copyright © 2020 龙培. All rights reserved.
//

#import "WLReadEffectCenter.h"

@implementation WLReadEffectCenter
+ (WLReadEffectCenter *)shareCenter{
    static WLReadEffectCenter *center = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[WLReadEffectCenter alloc] init];
    });
    return center;
}

- (void)loadSnowEffectWithSuperView:(UIView*)superView{
    UIView *sparkView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, PhoneScreen_WIDTH, PhoneScreen_HEIGHT-200)];
    sparkView.alpha = 1.0;
    [superView addSubview:sparkView];
    //初始化粒子发射layer
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    //发射layer的frame
    emitter.frame = sparkView.bounds;
    //添加发射layer
    [sparkView.layer addSublayer:emitter];
    //渲染模式
    emitter.renderMode = kCAEmitterLayerUnordered;
    //发射源形状
    emitter.emitterShape = kCAEmitterLayerLine;
    //发射源的尺寸
    emitter.emitterSize = CGSizeMake(PhoneScreen_WIDTH, 10);
    //发射源的发射位置
    emitter.emitterPosition = CGPointMake(PhoneScreen_WIDTH/2, 0);
    //发射layer的产生速率
    emitter.birthRate = 3.0;
    //创建爱心形状的粒子
    CAEmitterCell *cell = [[CAEmitterCell alloc]init];
    //粒子要展现的图片
    cell.contents = (__bridge id)[UIImage imageNamed:@"effect_snow"].CGImage;
    //粒子产生的速率
    cell.birthRate = 1;
    //粒子的存在时间
    cell.lifetime = 8.0;
    //粒子的存在时间的波动范围
    cell.lifetimeRange = 1;
    cell.color = RGBCOLOR(255, 255, 255, 1).CGColor;
    //粒子的透明度的变化速度
    cell.alphaSpeed = -0.15;
    //粒子运动的速度
    cell.velocity = 60;
    //粒子运动速度波动范围
    cell.velocityRange = 20;
    //发射的范围，为一弧度值，大于0的话，就会以发射源为顶点，emissionRange角为顶角，创建一个圆锥，粒子会在该圆锥中发射
    cell.emissionRange = 0;
    //粒子的经度，xy平面上，与x轴的夹角
    cell.emissionLongitude = -M_PI;
    //粒子的旋转速度（周）
    cell.spin = 0.1;
    //粒子的旋转速度可波动范围
    cell.spinRange = 0.05;
    //粒子的缩放
    cell.scale = 0.1;
    //粒子的缩放波动范围
    cell.scaleRange = 0.05;
    emitter.emitterCells = @[cell];
}

- (void)loadFlowerEffectWithSuperView:(UIView*)superView{
    UIView *sparkView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, PhoneScreen_WIDTH, PhoneScreen_HEIGHT-200)];
    sparkView.alpha = 1.0;
    [superView addSubview:sparkView];
    //初始化粒子发射layer
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    //发射layer的frame
    emitter.frame = sparkView.bounds;
    //添加发射layer
    [sparkView.layer addSublayer:emitter];
    //渲染模式
    emitter.renderMode = kCAEmitterLayerUnordered;
    //发射源形状
    emitter.emitterShape = kCAEmitterLayerLine;
    //发射源的尺寸
    emitter.emitterSize = CGSizeMake(PhoneScreen_WIDTH, 10);
    //发射源的发射位置
    emitter.emitterPosition = CGPointMake(PhoneScreen_WIDTH/2, 0);
    //发射layer的产生速率
    emitter.birthRate = 3.0;
    //创建爱心形状的粒子
    CAEmitterCell *cell = [[CAEmitterCell alloc]init];
    //粒子要展现的图片
    cell.contents = (__bridge id)[UIImage imageNamed:@"effect_flower"].CGImage;
    //粒子产生的速率
    cell.birthRate = 1;
    //粒子的存在时间
    cell.lifetime = 8.0;
    //粒子的存在时间的波动范围
    cell.lifetimeRange = 1;
    cell.color = RGBCOLOR(255, 255, 255, 1).CGColor;
    //粒子的透明度的变化速度
    cell.alphaSpeed = -0.15;
    //粒子运动的速度
    cell.velocity = 60;
    //粒子运动速度波动范围
    cell.velocityRange = 20;
    //发射的范围，为一弧度值，大于0的话，就会以发射源为顶点，emissionRange角为顶角，创建一个圆锥，粒子会在该圆锥中发射
    cell.emissionRange = 0;
    //粒子的经度，xy平面上，与x轴的夹角
    cell.emissionLongitude = -M_PI;
    //粒子的旋转速度（周）
    cell.spin = 0.5;
    //粒子的旋转速度可波动范围
    cell.spinRange = 0.2;
    //粒子的缩放
    cell.scale = 0.15;
    //粒子的缩放波动范围
    cell.scaleRange = 0.15;
    emitter.emitterCells = @[cell];
}

@end

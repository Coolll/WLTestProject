//
//  WLMyHeaderTableViewCell.h
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/14.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLMyHeaderTableViewCell : UITableViewCell

/**
 *  是否登录
 **/
@property (nonatomic,assign) BOOL isLogin;

/**
 *  头像的URL
 **/
@property (nonatomic,copy) NSString *imageURL;

/**
 *  昵称
 **/
@property (nonatomic,copy) NSString *nameString;

- (void)clickHeadImageBlock:(void(^)(BOOL isLogin))block;

- (void)clickLoginBlock:(void(^)(void))block;

- (void)clickEditBlock:(void(^)(void))block;


@end

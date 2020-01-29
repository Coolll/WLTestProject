//
//  WLImageCell.h
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/6/22.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ImageCellTouchBlock) (void);

@interface WLImageCell : UITableViewCell
/**
 *  图片url
 **/
@property (nonatomic,copy) NSString *imageURL;


- (void)touchImageWithBlock:(ImageCellTouchBlock)block;

- (void)loadCustomView;

@end

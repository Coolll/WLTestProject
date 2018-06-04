//
//  WLPoetryListController.h
//  WLPoetryProject
//
//  Created by 龙培 on 2018/5/7.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger , PoetrySource) {
    PoetrySourceGradeOne,
    PoetrySourceGradeTwo,
    PoetrySourceGradeThree,
    PoetrySourceGradeFour,
    PoetrySourceGradeFive,
    PoetrySourceGradeSix,
    PoetrySourceGradeSevenOne,
    PoetrySourceGradeSevenTwo,
    PoetrySourceGradeEightOne,
    PoetrySourceGradeEightTwo,
    PoetrySourceGradeNineOne,
    PoetrySourceGradeNineTwo,
    PoetrySourceTangOne,
    PoetrySourceTangTwo,
    PoetrySourceTangThree,
    PoetrySourceTangFour,
    PoetrySourceTangFive,
    PoetrySourceTangSix,
    PoetrySourceTangSeven,
    PoetrySourceSongOne,
    PoetrySourceSongTwo,
    PoetrySourceSongThree,
    PoetrySourceSongFour,
    PoetrySourceSongFive,
    PoetrySourceSongSix,
    PoetrySourceSongSeven,
    PoetrySourceSongEight,
    PoetrySourceSongNine,
    PoetrySourceSongTen,
    PoetrySourceRecommend
};

@interface WLPoetryListController : BaseViewController
/**
 *  诗词类型
 **/
@property (nonatomic,assign) PoetrySource source;


@end

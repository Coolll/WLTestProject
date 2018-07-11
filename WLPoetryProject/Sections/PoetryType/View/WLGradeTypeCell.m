//
//  WLGradeTypeCell.m
//  WLPoetryProject
//
//  Created by chuchengpeng on 2018/7/10.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLGradeTypeCell.h"
#import "WLBookView.h"
@interface WLGradeTypeCell ()
/**
 *  点击事件
 **/
@property (nonatomic,copy) GradeClickBlock clickBlock;


@end
@implementation WLGradeTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];

}


- (void)clickWithBlock:(GradeClickBlock)block
{
    if (block) {
        self.clickBlock = block;
    }
}


- (void)loadCustomView
{
    NSInteger countEachLine = 3;//每行的个数
    CGFloat leftSpace = 10;//左侧间距
    CGFloat topSpace = 10;//顶部间距
    CGFloat itemHorizonSpace = 10;//元素水平间距
    CGFloat itemVerticalSpace = 10;//元素垂直间距
    CGFloat itemHeight = 150;//单个元素的高度
    CGFloat itemWidth = (PhoneScreen_WIDTH-leftSpace*2-itemHorizonSpace*(countEachLine-1))/countEachLine;//在固定元素水平间距时，元素的宽度
    
    bool staticWidth = YES;
    if (staticWidth) {
        itemWidth = 100;//固定元素的宽度
        CGFloat totalSpace = PhoneScreen_WIDTH-leftSpace*2-countEachLine*itemWidth;//排列固定列数的剩余宽度
        CGFloat addSpace = PhoneScreen_WIDTH-leftSpace*2-(countEachLine-1)*itemWidth;//排列固定列数-1的剩余宽度
        itemHorizonSpace = totalSpace>0?(totalSpace/countEachLine):(addSpace/(countEachLine-1));//计算出元素的水平间距
    }
    for (int i =0 ; i< self.booksArray.count; i++) {
        
        NSInteger line = i/countEachLine;//第几行
        NSInteger row = i%countEachLine;//第几列
        CGFloat xPosition = leftSpace+row*itemWidth+row*itemHorizonSpace;
        CGFloat yPosition = topSpace+line*itemHeight+line*itemVerticalSpace;
        WLBookView *view = [[WLBookView alloc]initWithFrame:CGRectMake(xPosition, yPosition, itemWidth, itemHeight)];
        view.index = i;
        view.bookName = [NSString stringWithFormat:@"%@",[self.booksArray objectAtIndex:i]];
        [view clickBookWithBlock:^(NSInteger index) {
            if (self.clickBlock) {
                self.clickBlock(index);
            }
        }];
        [view loadCustomView];
        [self addSubview:view];
        
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

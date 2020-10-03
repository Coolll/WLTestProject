//
//  WLAnalysesView.m
//  WLPoetryProject
//
//  Created by 变啦 on 2020/4/28.
//  Copyright © 2020 龙培. All rights reserved.
//

#import "WLAnalysesView.h"

@interface WLAnalysesView()
/**
 *  内容视图
 **/
@property (nonatomic,strong) UIView *contentView;
/**
 *  主滑动视图
 **/
@property (nonatomic,strong) UIScrollView *mainScroll;
/**
 *  注释label
 **/
@property (nonatomic,strong) UILabel *additionLabel;
/**
 *  翻译label
 **/
@property (nonatomic,strong) UILabel *transferLabel;
/**
 *  鉴赏label
 **/
@property (nonatomic,strong) UILabel *analysesLabel;
/**
 *  背景label
 **/
@property (nonatomic,strong) UILabel *backgroundLabel;

/**
 *  底部的间距
 **/
@property (nonatomic,assign) CGFloat scrollBottomSpace;

/**
 *  展示的总高度（视图高度-顶部的title高度）
 **/
@property (nonatomic,assign) CGFloat showHeight;

@end


@implementation WLAnalysesView

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)configureView{
    [self loadCustomData];
    [self loadCustomView];
}

- (void)loadCustomData{
    self.scrollBottomSpace = 30;
    self.showHeight = (PhoneScreen_HEIGHT/2)-50;
}


- (void)loadCustomView{
    self.frame = CGRectMake(0, PhoneScreen_HEIGHT, PhoneScreen_WIDTH, PhoneScreen_HEIGHT);
    self.backgroundColor = [UIColor whiteColor];
    [[WLPublicTool shareTool] addCornerForView:self withCornerRadius:40];
    
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    //元素的布局
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.width.mas_equalTo(PhoneScreen_WIDTH);
        make.height.mas_equalTo(PhoneScreen_HEIGHT/2);
    }];
    
    CGFloat labelWidth = (PhoneScreen_WIDTH-60)/4;
    
    NSArray *textArray = [NSArray arrayWithObjects:@"释",@"译",@"鉴",@"背",nil];
    
    for (int i = 0; i < textArray.count; i ++ ) {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:14.f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = [textArray objectAtIndex:i];
        titleLabel.tag = 1000+i;
        titleLabel.textColor = [UIColor colorWithRed:62/255.f green:172/255.f blue:249/255.f alpha:1.0];
        titleLabel.layer.cornerRadius = 15;
        titleLabel.clipsToBounds = YES;
        titleLabel.layer.borderColor = [UIColor colorWithRed:62/255.f green:172/255.f blue:249/255.f alpha:1.0].CGColor;
        titleLabel.layer.borderWidth = 1.0f;
        if (i == 0) {
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.backgroundColor = [UIColor colorWithRed:62/255.f green:172/255.f blue:249/255.f alpha:1.0];
        }
        [self.contentView addSubview:titleLabel];
        //元素的布局
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView.mas_leading).offset(15+i*labelWidth+i*10);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.width.mas_equalTo(labelWidth);
            make.height.mas_equalTo(30);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheSection:)];
        [titleLabel addGestureRecognizer:tap];
        titleLabel.userInteractionEnabled = YES;
        
    }
    
    self.mainScroll = [[UIScrollView alloc]init];
    [self.contentView addSubview:self.mainScroll];
    //元素的布局
    [self.mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.contentView.mas_leading).offset(0);
        make.top.equalTo(self.contentView.mas_top).offset(50);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        make.width.mas_equalTo(PhoneScreen_WIDTH);
    }];
    
    [self loadAdditionLabel];
    [self loadTransferLabel];
    [self loadAnalysesLabel];
    [self loadBackgroundLabel];
    
}

- (void)loadAdditionLabel{
    self.additionLabel = [[UILabel alloc]init];
    self.additionLabel.numberOfLines = 0;
    NSMutableString *dataString = [NSMutableString string];
    
    if (self.additionInfo && [self.additionInfo isKindOfClass:[NSString class]] && self.additionInfo.length > 0) {
        dataString = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@",self.additionInfo]];
    }
    
    if (kStringIsEmpty(dataString)) {
        dataString = [@"暂无" mutableCopy];
    }
    NSString *showAdditionOne = [dataString stringByReplacingOccurrencesOfString:@"？" withString:@"？\n"];
    NSString *showAdditionTwo = [showAdditionOne stringByReplacingOccurrencesOfString:@"！" withString:@"！\n"];
    NSString *showAdditionThree = [showAdditionTwo stringByReplacingOccurrencesOfString:@"。" withString:@"。\n"];
    self.additionLabel.text = [NSString stringWithFormat:@"注释\n%@",showAdditionThree];
    [self updateTitleWithLabel:self.additionLabel withCount:2 needChangeParagraph:YES];
    [self.mainScroll addSubview:self.additionLabel];
    //元素的布局
    [self.additionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mainScroll.mas_leading).offset(15);
        make.top.equalTo(self.mainScroll.mas_top).offset(0);
        make.width.mas_equalTo(PhoneScreen_WIDTH-30);
    }];
    
}

- (void)loadTransferLabel{
    self.transferLabel = [[UILabel alloc]init];
    self.transferLabel.numberOfLines = 0;
    NSMutableString *dataString = [NSMutableString string];
    
    if (self.transferInfo && [self.transferInfo isKindOfClass:[NSString class]] && self.transferInfo.length > 0) {
        dataString = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@",self.transferInfo]];
    }
    
    if (kStringIsEmpty(dataString)) {
        dataString = [@"暂无" mutableCopy];
    }

    NSString *showText = [dataString stringByReplacingOccurrencesOfString:@"。" withString:@"。\n"];
    self.transferLabel.text = [NSString stringWithFormat:@"译文\n%@",showText];
    [self updateTitleWithLabel:self.transferLabel withCount:2 needChangeParagraph:YES];
    [self.mainScroll addSubview:self.transferLabel];
    //元素的布局
    [self.transferLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mainScroll.mas_leading).offset(15);
        make.top.equalTo(self.additionLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(PhoneScreen_WIDTH-30);
    }];
}

- (void)loadAnalysesLabel{
    self.analysesLabel = [[UILabel alloc]init];
    self.analysesLabel.numberOfLines = 0;
    NSMutableString *dataString = [NSMutableString string];
    
    if (self.analysesInfo && [self.analysesInfo isKindOfClass:[NSString class]] && self.analysesInfo.length > 0) {
        dataString = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@",self.analysesInfo]];
    }
    
    if (kStringIsEmpty(dataString)) {
        dataString = [@"暂无" mutableCopy];
    }
    
    NSString *showText = [dataString stringByReplacingOccurrencesOfString:@"&&&" withString:@"\n"];
    self.analysesLabel.text = [NSString stringWithFormat:@"鉴赏\n%@",showText];
    [self updateTitleWithLabel:self.analysesLabel withCount:2 needChangeParagraph:YES];
    [self.mainScroll addSubview:self.analysesLabel];
    //元素的布局
    [self.analysesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mainScroll.mas_leading).offset(15);
        make.top.equalTo(self.transferLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(PhoneScreen_WIDTH-30);
    }];
}

- (void)loadBackgroundLabel{
    self.backgroundLabel = [[UILabel alloc]init];
    self.backgroundLabel.numberOfLines = 0;
    NSMutableString *dataString = [NSMutableString string];
    
    if (self.backgroundInfo && [self.backgroundInfo isKindOfClass:[NSString class]] && self.backgroundInfo.length > 0) {
        dataString = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@",self.backgroundInfo]];
    }
    
    if (kStringIsEmpty(dataString)) {
        dataString = [@"暂无" mutableCopy];
    }
    
    NSString *showText = [dataString stringByReplacingOccurrencesOfString:@"&&&" withString:@"\n"];
    self.backgroundLabel.text = [NSString stringWithFormat:@"背景\n%@",showText];
    [self updateTitleWithLabel:self.backgroundLabel withCount:2 needChangeParagraph:YES];
    [self.mainScroll addSubview:self.backgroundLabel];
    //元素的布局
    [self.backgroundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mainScroll.mas_leading).offset(15);
        make.top.equalTo(self.analysesLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(PhoneScreen_WIDTH-30);
    }];
    
    [self.mainScroll mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backgroundLabel.mas_bottom).offset(self.scrollBottomSpace);
    }];
}

- (void)tapTheSection:(UITapGestureRecognizer*)tap{
    NSInteger index = tap.view.tag-1000;
    NSLog(@"点击:%ld",(long)index);
    
    for (int i = 0; i < 4; i++) {
        UILabel *titleLabel = (UILabel*)[self viewWithTag:i+1000];
        
        if (i == index) {
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.backgroundColor = [UIColor colorWithRed:62/255.f green:172/255.f blue:249/255.f alpha:1.0];
        }else{
            titleLabel.textColor = [UIColor colorWithRed:62/255.f green:172/255.f blue:249/255.f alpha:1.0];
            titleLabel.layer.borderColor = [UIColor colorWithRed:62/255.f green:172/255.f blue:249/255.f alpha:1.0].CGColor;
            titleLabel.backgroundColor = [UIColor whiteColor];
        }
    }
    
    if (index == 0) {
        [self scrollToAdditionInfo];
    }else if (index == 1){
        [self scrollToTransferInfo];
    }else if (index == 2){
        [self scrollToAnalysesInfo];
    }else if (index == 3){
        [self scrollToBackgroundInfo];
    }
}

- (void)scrollToAdditionInfo{
    [self.mainScroll setContentOffset:CGPointMake(0, 0)];
}
- (void)scrollToTransferInfo{
    CGFloat tranferTop = self.transferLabel.frame.origin.y;
    [self.mainScroll setContentOffset:CGPointMake(0, tranferTop)];
}
- (void)scrollToAnalysesInfo{
    CGFloat analyseTop = self.analysesLabel.frame.origin.y;
    [self.mainScroll setContentOffset:CGPointMake(0, analyseTop)];

}
- (void)scrollToBackgroundInfo{
    CGFloat backgroundTop = self.backgroundLabel.frame.origin.y;
    CGFloat backgroundHeight = self.backgroundLabel.frame.size.height;
    if ((backgroundHeight + self.scrollBottomSpace) < self.showHeight) {
        [self.mainScroll setContentOffset:CGPointMake(0, (backgroundTop+backgroundHeight+self.scrollBottomSpace)-self.showHeight)];
    }else{
        [self.mainScroll setContentOffset:CGPointMake(0, backgroundTop)];
    }
}

- (void)updateTitleWithLabel:(UILabel*)label withCount:(NSInteger)count needChangeParagraph:(BOOL)needChange{
    if (label.text.length == 0) {
        return;
    }
    
    NSRange titleRange = NSMakeRange(0, count);
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:label.text];
    [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:titleRange];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:62/255.f green:172/255.f blue:249/255.f alpha:1.0] range:titleRange];
    if (needChange) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc]init];
        paragraph.lineSpacing = 8;
        paragraph.paragraphSpacing = 15;
        [string addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, label.text.length)];
    }else{
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc]init];
        paragraph.lineSpacing = 3;
        [string addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, count)];
    }
    
    label.attributedText = string;
    
}




@end

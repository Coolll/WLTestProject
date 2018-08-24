//
//  WLMyHeaderTableViewCell.m
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/14.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "WLMyHeaderTableViewCell.h"

typedef void(^HeadImageBlock)(BOOL isLogin);
typedef void(^LoginBlock)(void);
typedef void(^EditBlock)(void);

@interface WLMyHeaderTableViewCell ()
/**
 *  头像
 **/
@property (nonatomic,strong) UIImageView *headerImageView;

/**
 *  昵称
 **/
@property (nonatomic,strong) UILabel *nameLabel;

/**
 *  副标题
 **/
@property (nonatomic,strong) UILabel *subTitleLabel;

/**
 *  编辑资料
 **/
@property (nonatomic,strong) UILabel *editLabel;

/**
 *  编辑按钮
 **/
@property (nonatomic,strong) UIImageView *editImageView;

/**
 *  登录后编辑资料的按钮
 **/
@property (nonatomic,strong) UIButton *editButton;

/**
 *  点击头像的block
 **/
@property (nonatomic,copy) HeadImageBlock headBlock;
/**
 *  立即登录的block
 **/
@property (nonatomic,copy) LoginBlock loginBlock;

/**
 *  编辑的block
 **/
@property (nonatomic,copy) EditBlock editBlock;






@end
@implementation WLMyHeaderTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self loadCustomViewWithFrame:frame];
        
    }
    return self;
}

- (void)loadCustomViewWithFrame:(CGRect)frame
{
    self.backgroundColor = NavigationColor;
    
    CGFloat imageW = 77;
    CGFloat imageH = 77;
    CGFloat leftSpace = 22;
    CGFloat topSpace = (125-imageH)/2;
    
    //头像
    self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(leftSpace, topSpace, imageW, imageH)];
    self.headerImageView.image = [UIImage imageNamed:@"headerUnlogin"];
    self.headerImageView.layer.cornerRadius = imageW/2;
    self.headerImageView.clipsToBounds = YES;
    self.headerImageView.backgroundColor = [UIColor whiteColor];
    self.headerImageView.userInteractionEnabled = YES;
    [self addSubview:self.headerImageView];
    
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeImageAction:)];
    [self.headerImageView addGestureRecognizer:tapImage];
    
    CGFloat nameLeft = 41;
    CGFloat nameH = 20;
    CGFloat nameSpace = 15;
    CGFloat subTitleH = 16;
    
    CGFloat nameTop = (frame.size.height-nameH-nameSpace-subTitleH)/2;
    
    //昵称
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftSpace+imageW+nameLeft, nameTop, frame.size.width-imageW-leftSpace-nameLeft, nameH)];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont systemFontOfSize:16.0];
    self.nameLabel.userInteractionEnabled = YES;
    [self addSubview:self.nameLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loginAction:)];
    [self.nameLabel addGestureRecognizer:tap];
    
    
    //副标题
    self.subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.frame.origin.x, nameTop+nameH+nameSpace, self.nameLabel.frame.size.width, subTitleH)];
    self.subTitleLabel.hidden = YES;
    self.subTitleLabel.font = [UIFont systemFontOfSize:12.0];
    self.subTitleLabel.text = @"极速登录，即可收藏诗词";
    self.subTitleLabel.textColor = [UIColor whiteColor];
    self.subTitleLabel.userInteractionEnabled = YES;
    [self addSubview:self.subTitleLabel];
    
    UITapGestureRecognizer *subTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loginAction:)];
    [self.subTitleLabel addGestureRecognizer:subTap];

    
    
    
}

#pragma mark - 点击响应事件


- (void)changeImageAction:(UITapGestureRecognizer*)tap
{
    if (self.headBlock) {
        self.headBlock(_isLogin);
    }
}

- (void)loginAction:(UITapGestureRecognizer*)tap
{
    //登录操作，如果已登录，不做处理
    if (self.isLogin) {
        return;
    }
    
    if (self.loginBlock) {
        self.loginBlock();
    }
}

- (void)editInformationAction:(UIButton*)sender
{
    if (self.editBlock) {
        self.editBlock();
    }
    
}

#pragma mark - 三个点击事件

- (void)clickHeadImageBlock:(void(^)(BOOL isLogin))block
{
    if (block) {
        self.headBlock = block;
    }
}

- (void)clickLoginBlock:(void(^)(void))block
{
    if (block) {
        self.loginBlock = block;
    }
}
- (void)clickEditBlock:(void(^)(void))block
{
    if (block) {
        self.editBlock = block;
    }
}

#pragma mark - 是否登录

- (void)setIsLogin:(BOOL)isLogin
{
    _isLogin = isLogin;
    
    if (isLogin) {
        self.subTitleLabel.hidden = YES;
        self.editLabel.hidden = NO;
        self.editImageView.hidden = NO;
        self.editButton.enabled = YES;
    }else{
        self.nameLabel.text = @"立即登录";
        self.subTitleLabel.hidden = NO;
        self.editImageView.hidden = YES;
        self.editLabel.hidden = YES;
        self.editButton.enabled = NO;
    }
}

- (void)setNameString:(NSString *)nameString
{
    _nameString = nameString;
    
    self.nameLabel.text = nameString;
    
    if (!_isLogin) {
        self.nameLabel.text = @"立即登录";
    }
    
}

- (void)setImageURL:(NSString *)imageURL
{
    _imageURL = imageURL;
    
    if (imageURL.length > 0 && _isLogin) {
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"headerUnlogin"]];

    }else{
        if (self.isLogin) {
            self.headerImageView.image = [UIImage imageNamed:@"defaultHeader"];

        }else{
            self.headerImageView.image = [UIImage imageNamed:@"headerUnlogin"];

        }
    }
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

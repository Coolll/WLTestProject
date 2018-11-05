//
//  PoetryDetailViewController.m
//  WLPoetryProject
//
//  Created by 龙培 on 2018/4/23.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "PoetryDetailViewController.h"
#import "WLPoetryContentCell.h"
#import <BmobSDK/Bmob.h>
#import "RecitePoetryController.h"
static const CGFloat leftSpace = 10;//诗句的左右间距
static const CGFloat topSpace = 15;//诗句与标题的上间距

@interface PoetryDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

/**
 *  诗词内容table
 **/
@property (nonatomic,strong) UITableView *mainTable;
/**
 *  诗词句子
 **/
@property (nonatomic,strong) NSArray *dataArray;
/**
 *  作者
 **/
@property (nonatomic,strong) UILabel *authorLabel;

/**
 *  是否收藏的图片
 **/
@property (nonatomic, strong) UIImageView *likeImage;
/**
 *  是否收藏
 **/
@property (nonatomic, assign) BOOL isLike;
/**
 *  喜欢的点击事件
 **/
@property (nonatomic, copy) LikeBlock likeBlock;

/**
 *  主图片背景
 **/
@property (nonatomic, strong) UIImageView *mainImageView;
@end

@implementation PoetryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleForNavi = self.dataModel.name;
    [self loadMainBackImageView];//背景
    [self addFullTitleLabel];//诗词名字 添加背景之后调用，否则会被背景图遮住

    [self loadCustomData];//加载数据
    
    [self addBackButtonForFullScreen];//返回按钮，需要最后添加
    
    [self loadLikeData];
    
}

- (void)loadLikeData
{
    
    id token = kUserToken;
    if (!token) {
        token = @"";
    }
    
    NSString *tokenString = [NSString stringWithFormat:@"%@",token];
    //如果本地没有token，那么就意味着用户没有登录，不需要去拿收藏列表,该数据为未收藏
    if (tokenString.length == 0) {
        self.isLike = NO;
        [self loadLikeButton];
        return;
    }
    
    
    BmobUser *user = [BmobUser currentUser];
    
    if (user) {
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:[user objectForKey:@"likePoetryIDList"]];
        
        if (array.count == 0) {
            self.isLike = NO;
            [self loadLikeButton];
            return;
        }
        
        BOOL isContain = NO;
        for (NSString *poetryIdString in array) {
            //已经收藏了的诗词
            if ([poetryIdString isEqualToString:self.dataModel.poetryID]) {
                self.isLike = YES;
                [self loadLikeButton];
                return;
            }
        }
        
        if (!isContain) {
            self.isLike = NO;
            [self loadLikeButton];
        }
        
    }
    
    
}
#pragma mark - 初始化数据和视图

- (void)loadCustomData
{
    self.dataArray = [NSArray array];
    
    self.dataArray = [[WLPublicTool shareTool] poetrySeperateWithOrigin:self.dataModel.content];
    
    [self loadContentTableView];

}

- (void)queryPoetryImageData
{
    BmobQuery *query = [BmobQuery queryWithClassName:@"ImageList"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (array.count > 0) {
            BmobObject *obc = [array firstObject];
            NSString *url = [obc objectForKey:@"imageURL"];
            NSLog(@"imageURL:%@",url);
            [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:url]];
        }
    }];
}


- (void)loadMainBackImageView
{
    //诗词主背景
    self.mainImageView = [[UIImageView alloc]init];
    [self.view addSubview:self.mainImageView];
    
    NSString *imageName = [NSString stringWithFormat:@"%@",[[AppConfig config].bgImageInfo objectForKey:self.dataModel.classInfo]];
    if (imageName.length > 0 && ![imageName isEqualToString:@"(null)"]) {
//        self.mainImageView.image = [UIImage imageNamed:imageName];
        [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
    }else{
        self.mainImageView.image = [UIImage imageNamed:@"poetryBack.jpg"];

    }
    
    
    //元素的布局
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.leading.equalTo(self.view.mas_leading).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.trailing.equalTo(self.view.mas_trailing).offset(0);

    }];
    
}

- (void)loadContentTableView
{
    self.authorLabel.text = self.dataModel.author;
    self.mainTable.backgroundColor = [UIColor clearColor];
}

- (void)clickLikeWithBlock:(LikeBlock)block
{
    if (block) {
        self.likeBlock = block;
    }
}

- (void)loadLikeButton
{
    self.likeImage = [[UIImageView alloc]init];
    if (self.isLike) {
        self.likeImage.image = [UIImage imageNamed:@"likePoetry"];
    }else{
        self.likeImage.image = [UIImage imageNamed:@"unlikePoetry"];
    }
    [self.view addSubview:self.likeImage];
    
    
    if (@available(iOS 11.0, *)) {
        //元素的布局
        [self.likeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(35);
            make.trailing.equalTo(self.view.mas_trailing).offset(-20);
            make.width.mas_equalTo(20);//元素宽度
            make.height.mas_equalTo(20);//元素高度
            
        }];
    }else{
        //设置UI布局约束
        [self.likeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.view.mas_top).offset(24);//元素顶部约束
            make.trailing.equalTo(self.view.mas_trailing).offset(-20);//元素右侧约束
            make.width.mas_equalTo(20);//元素宽度
            make.height.mas_equalTo(20);//元素高度
        }];
    }
    
    
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    likeBtn.backgroundColor = [UIColor clearColor];
    [likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:likeBtn];
    //设置UI布局约束
    [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.likeImage.mas_top).offset(-10);//元素顶部约束
        make.trailing.equalTo(self.likeImage.mas_trailing).offset(10);//元素右侧约束
        make.bottom.equalTo(self.likeImage.mas_bottom).offset(10);//元素底部约束
        make.leading.equalTo(self.likeImage.mas_leading).offset(-10);
    }];
    
    
    UIImageView *shareImage = [[UIImageView alloc]init];
    shareImage.image = [UIImage imageNamed:@"shareIcon"];
    [self.view addSubview:shareImage];
    //设置UI布局约束
    [shareImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.likeImage.mas_bottom).offset(20);//元素顶部约束
        make.leading.equalTo(self.likeImage.mas_leading).offset(0);//元素左侧约束
        make.width.mas_equalTo(20);//元素宽度
        make.height.mas_equalTo(20);//元素高度
    }];
    
    
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.backgroundColor = [UIColor clearColor];
    [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    //设置UI布局约束
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(shareImage.mas_top).offset(-10);//元素顶部约束
        make.trailing.equalTo(shareImage.mas_trailing).offset(10);//元素右侧约束
        make.bottom.equalTo(shareImage.mas_bottom).offset(10);//元素底部约束
        make.leading.equalTo(shareImage.mas_leading).offset(-10);
    }];
    
    
    UIImageView *reciteImage = [[UIImageView alloc]init];
    reciteImage.image = [UIImage imageNamed:@"reciteIcon"];
    [self.view addSubview:reciteImage];
    //设置UI布局约束
    [reciteImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(shareImage.mas_bottom).offset(20);//元素顶部约束
        make.leading.equalTo(self.likeImage.mas_leading).offset(0);//元素左侧约束
        make.width.mas_equalTo(20);//元素宽度
        make.height.mas_equalTo(20);//元素高度
    }];
    
    
    
    UIButton *reciteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reciteBtn.backgroundColor = [UIColor clearColor];
    [reciteBtn addTarget:self action:@selector(reciteAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reciteBtn];
    //设置UI布局约束
    [reciteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(reciteImage.mas_top).offset(-10);//元素顶部约束
        make.trailing.equalTo(reciteImage.mas_trailing).offset(10);//元素右侧约束
        make.bottom.equalTo(reciteImage.mas_bottom).offset(10);//元素底部约束
        make.leading.equalTo(reciteImage.mas_leading).offset(-10);
    }];
    
}

#pragma mark - 收藏
- (void)likeAction:(UIButton*)sender
{
    
    id token = kUserToken;
    if (!token) {
        token = @"";
    }
    
    NSString *tokenString = [NSString stringWithFormat:@"%@",token];
    //如果本地没有token，那么就意味着用户没有登录，无法进行收藏
    if (tokenString.length == 0) {
        [self showHUDWithText:@"您尚未登录，请登录后重试"];
        return;
    }
    
    
    NSString *userId = kUserID;
    if (!userId || userId.length == 0) {
        userId = @"";
    }
    NSString *userIDString = [NSString stringWithFormat:@"%@",userId];
    
    BmobUser *user = [BmobUser currentUser];
    
    NSString *userBmobId = user.objectId;
//    NSMutableArray *array = [NSMutableArray arrayWithArray:[user objectForKey:@"likePoetryIDList"]];
    NSArray *array = [NSArray arrayWithObject:self.dataModel.poetryID];
    if ([userBmobId isEqualToString:userIDString]) {
        
        if (self.isLike) {
            //如果之前是喜欢，点击按钮，则移除
//            [array removeObject:self.dataModel.poetryID];
            [user removeObjectsInArray:[array copy] forKey:@"likePoetryIDList"];


        }else{
            //如果之前未喜欢，点击按钮，则收藏
//            [array addObject:self.dataModel.poetryID];
            [user addObjectsFromArray:[array copy] forKey:@"likePoetryIDList"];

        }
        
        [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            NSLog(@"error %@",[error description]);
            if (isSuccessful) {
                self.isLike = !self.isLike;
                
                if (self.isLike) {
                    self.likeImage.image = [UIImage imageNamed:@"likePoetry"];
                }else{
                    self.likeImage.image = [UIImage imageNamed:@"unlikePoetry"];
                }
                
                //点击收藏/取消收藏后，我的收藏列表的数据需要更新
                if (self.likeBlock) {
                    self.likeBlock(self.isLike);
                }
                
            }
        }];
    }
    
}

- (void)shareAction:(UIButton*)sender
{
    UIImage *image =  [self fullScreenShot];
    [self shareWithImageArray:@[image]];
    
}
//截取全屏 高效 支持Retina屏
- (UIImage*)fullScreenShot
{
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context, -[window bounds].size.width*[[window layer] anchorPoint].x, -[window bounds].size.height*[[window layer] anchorPoint].y);
            [[window layer] renderInContext:context];
            CGContextRestoreGState(context);
            
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

- (void)reciteAction:(UIButton*)sender
{
    NSLog(@"背诵");
    RecitePoetryController *vc = [[RecitePoetryController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TableView 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataArray.count) {
        NSString *content = self.dataArray[indexPath.row];
        return [WLPoetryContentCell heightForContent:content withWidth:(PhoneScreen_WIDTH-2*leftSpace-20)];
    }
    
    return 0;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WLPoetryContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"WLPoetryContentCell"];
    if (!contentCell) {
        
        CGFloat cellHeight = 0;
        if (indexPath.row < self.dataArray.count) {
            NSString *content = self.dataArray[indexPath.row];
            cellHeight = [WLPoetryContentCell heightForContent:content withWidth:(PhoneScreen_WIDTH-2*leftSpace-20)];
        }
        contentCell = [[WLPoetryContentCell alloc]initWithFrame:CGRectMake(0, 0, PhoneScreen_WIDTH-2*leftSpace-20, cellHeight)];
    }
    contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    contentCell.backgroundColor = [UIColor clearColor];
    contentCell.contentString = self.dataArray[indexPath.row];
    return contentCell;
}
#pragma mark - 点击事件

- (void)backAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Property
- (UITableView*)mainTable
{
    if (!_mainTable) {
        
        _mainTable = [[UITableView alloc]init];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.showsVerticalScrollIndicator= NO;
        [self.view addSubview:_mainTable];
        //元素的布局
        [_mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.view.mas_leading).offset(leftSpace);
            make.top.equalTo(self.authorLabel.mas_bottom).offset(topSpace);
            make.bottom.equalTo(self.view.mas_bottom).offset(-topSpace);
            make.trailing.equalTo(self.view.mas_trailing).offset(-leftSpace);
            
        }];
    }
    return _mainTable;
}

- (UILabel *)authorLabel
{
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc]init];
        _authorLabel.textAlignment = NSTextAlignmentCenter;
        _authorLabel.textColor = RGBCOLOR(60, 60, 60, 1.0);
        _authorLabel.font = [AppConfig config].authorFont;
        [self.view addSubview:_authorLabel];
        //元素的布局
        [_authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.view.mas_leading).offset(leftSpace);
            make.top.equalTo(self.titleFullLabel.mas_bottom).offset(topSpace);
            make.trailing.equalTo(self.view.mas_trailing).offset(-leftSpace);
            make.height.mas_equalTo(24);
            
        }];
    }
    return _authorLabel;
}


@end

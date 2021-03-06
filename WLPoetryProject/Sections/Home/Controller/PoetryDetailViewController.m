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
@property (nonatomic,strong) NSMutableArray *dataArray;
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
    self.dataArray = [NSMutableArray array];
    //是否含有句号
    BOOL isContainEnd = [self.dataModel.content containsString:@"。"];
    //是否含有感叹号
    BOOL isContainExclamation = [self.dataModel.content containsString:@"！"];
    //是否含有问号
    BOOL isContainQuestion = [self.dataModel.content containsString:@"？"];
    //是否含有冒号
    BOOL isContainColon = [self.dataModel.content containsString:@"："];
    //是否含有分号
    BOOL isContainSemicolon = [self.dataModel.content containsString:@"；"];
    
    //有的话，按句号划分
    if (isContainEnd) {
        //拆分成数组
        NSArray *arr = [self.dataModel.content componentsSeparatedByString:@"。"];
        for (NSString *content in arr) {
            //如果是诗句末尾的句号，则会拆分多出来一个空的字符，判断处理一下
            if (content.length > 0) {
                
                NSString *fullString;
                //取最后一个字符
                NSString *contentLastChar = [content substringFromIndex:content.length-1];
                if ([contentLastChar isEqualToString:@"？"] || [contentLastChar isEqualToString:@"！"]) {
                    //如果是问号或者感叹号结尾，则不处理
                    fullString = content;
                }else{
                    //把句号补上
                    fullString = [NSString stringWithFormat:@"%@。",content];
                }

                
                NSArray *partArr = [self dealPartWithOrigin:fullString];
                
                //上一步的数据源
                NSMutableArray *exclamationArr = [NSMutableArray arrayWithArray:partArr];
                //如果包含符号
                if (isContainExclamation) {
                    //把数据移除
                    [exclamationArr removeAllObjects];
                    //遍历原数据
                    for (NSString *subString in partArr) {
                        //按符号分割
                        NSArray *exclamationArray = [self dealExclamationWithOrigin:subString];
                        for (NSString *separateString in exclamationArray) {
                            //分割后的添加到目标数组中
                            [exclamationArr addObject:separateString];
                        }
                    }
                }
                
                //上一步的数据源
                NSMutableArray *questionArr = [NSMutableArray arrayWithArray:exclamationArr];
                //如果包含符号
                if (isContainQuestion) {
                    //把数据移除
                    [questionArr removeAllObjects];
                    //遍历原数据
                    for (NSString *subString in exclamationArr) {
                        //按符号分割
                        NSArray *questionArray = [self dealQuestionWithOrigin:subString];
                        for (NSString *separateString in questionArray) {
                            //分割后的添加到目标数组中
                            [questionArr addObject:separateString];
                        }
                    }
                }

                //上一步的数据源
                NSMutableArray *colonArr = [NSMutableArray arrayWithArray:questionArr];
                //如果包含符号
                if (isContainColon) {
                    //把数据移除
                    [colonArr removeAllObjects];
                    //遍历原数据
                    for (NSString *subString in questionArr) {
                        //按符号分割
                        NSArray *colonArray = [self dealColonWithOrigin:subString];
                        for (NSString *separateString in colonArray) {
                            //分割后的添加到目标数组中
                            [colonArr addObject:separateString];
                        }
                    }
                }
                
                //上一步的数据源
                NSMutableArray *semicolonArr = [NSMutableArray arrayWithArray:colonArr];
                //如果包含符号
                if (isContainSemicolon) {
                    //把数据移除
                    [semicolonArr removeAllObjects];
                    //遍历原数据
                    for (NSString *subString in colonArr) {
                        //按符号分割
                        NSArray *semicolonArray = [self dealSemicolonWithOrigin:subString];
                        for (NSString *separateString in semicolonArray) {
                            //分割后的添加到目标数组中
                            [semicolonArr addObject:separateString];
                        }
                    }
                }
                
                for (NSString *subString in semicolonArr) {
                    [self.dataArray addObject:subString];
                }
                
                
                //非空诗句添加到数组中
                
                
            }
           
            //循环处理了全部诗词
        }
        
        //加载诗句
        [self loadContentTableView];
    }
    
    
    
}


- (NSArray*)dealPartWithOrigin:(NSString*)contentString
{
    NSMutableArray *arr = [NSMutableArray array];
    
    if (contentString.length < 8) {
        //如果诗句少于8个字，则直接添加该诗句，不处理逗号
        [arr addObject:contentString];
        return arr;
    }else{
        //诗句大于8个字，能否拆出来一部分
        //是否包含逗号
        BOOL isContainPart = [contentString containsString:@"，"];
       
        if (isContainPart) {
            //按照逗号分割一次
            NSArray *partArray = [contentString componentsSeparatedByString:@"，"];
            
            for (int i = 0; i< partArray.count; i++) {
                
                NSString *partStr =  partArray[i];
                //最后一项不需要补充逗号
                if (i == partArray.count -1) {
                    [arr addObject:partStr];
                }else{
                    [arr addObject:[NSString stringWithFormat:@"%@，",partStr]];
                }
            }
            
        }else{
            //如果没有逗号，则直接添加该诗句
            [arr addObject:contentString];
        }
        
        
    }
    return arr;
}
- (NSArray*)dealExclamationWithOrigin:(NSString*)contentString
{
    NSMutableArray *arr = [NSMutableArray array];

    //当前句子是否包含感叹号
    BOOL isContainExclamation = [contentString containsString:@"！"];

    
    if (isContainExclamation) {
        //按照感叹号 分割一次
        NSArray *partArray = [contentString componentsSeparatedByString:@"！"];
        
        for (int i = 0; i< partArray.count; i++) {
            
            NSString *partStr =  partArray[i];
            //拆分后不是空的字符串
            if (partStr.length > 0) {
                
                //最后一项不需要补充感叹号
                if (i == partArray.count -1) {
                    [arr addObject:partStr];
                }else{
                    [arr addObject:[NSString stringWithFormat:@"%@！",partStr]];
                }
            }
            
        }
        
    }else{
        //如果没有感叹号，则直接添加该诗句
        [arr addObject:contentString];
    }
    
    return arr;
}
- (NSArray*)dealQuestionWithOrigin:(NSString*)contentString
{
    NSMutableArray *arr = [NSMutableArray array];
    
    //当前句子是否包含问号
    BOOL isContainExclamation = [contentString containsString:@"？"];
    
    
    if (isContainExclamation) {
        //按照问号 分割一次
        NSArray *partArray = [contentString componentsSeparatedByString:@"？"];
        
        for (int i = 0; i< partArray.count; i++) {
            
            NSString *partStr =  partArray[i];
            //如果不是空的字符串
            if (partStr.length > 0) {
                //最后一项不需要补充问号
                if (i == partArray.count -1) {
                    [arr addObject:partStr];
                }else{
                    [arr addObject:[NSString stringWithFormat:@"%@？",partStr]];
                }
            }
           
        }
        
    }else{
        //如果没有问号，则直接添加该诗句
        [arr addObject:contentString];
    }
    
    return arr;
}
- (NSArray*)dealColonWithOrigin:(NSString*)contentString
{
    NSMutableArray *arr = [NSMutableArray array];
    
    //当前句子是否包含冒号号
    BOOL isContainExclamation = [contentString containsString:@"："];
    
    
    if (isContainExclamation) {
        //按照冒号 分割一次
        NSArray *partArray = [contentString componentsSeparatedByString:@"："];
        
        for (int i = 0; i< partArray.count; i++) {
            
            NSString *partStr =  partArray[i];
            //拆分后不是空的字符串
            if (partStr.length > 0) {
                
                //最后一项不需要补充冒号
                if (i == partArray.count -1) {
                    [arr addObject:partStr];
                }else{
                    [arr addObject:[NSString stringWithFormat:@"%@：",partStr]];
                }
            }
            
        }
        
    }else{
        //如果没有冒号，则直接添加该诗句
        [arr addObject:contentString];
    }
    
    return arr;
}
    
- (NSArray*)dealSemicolonWithOrigin:(NSString*)contentString
{
    NSMutableArray *arr = [NSMutableArray array];
    
    //当前句子是否包含分号
    BOOL isContainExclamation = [contentString containsString:@"；"];
    
    
    if (isContainExclamation) {
        //按照分号 分割一次
        NSArray *partArray = [contentString componentsSeparatedByString:@"；"];
        
        for (int i = 0; i< partArray.count; i++) {
            
            NSString *partStr =  partArray[i];
            //拆分后不是空的字符串
            if (partStr.length > 0) {
                
                //最后一项不需要补充分号
                if (i == partArray.count -1) {
                    [arr addObject:partStr];
                }else{
                    [arr addObject:[NSString stringWithFormat:@"%@；",partStr]];
                }
            }
            
        }
        
    }else{
        //如果没有分号，则直接添加该诗句
        [arr addObject:contentString];
    }
    
    return arr;
}
- (void)loadMainBackImageView
{
    //诗词主背景
    UIImageView *mainImageView = [[UIImageView alloc]init];
    [self.view addSubview:mainImageView];
    
    NSString *imageName = [NSString stringWithFormat:@"%@",[[AppConfig config].bgImageInfo objectForKey:self.dataModel.classInfo]];
    if (imageName.length > 0 && ![imageName isEqualToString:@"(null)"]) {
        mainImageView.image = [UIImage imageNamed:imageName];
    }else{
        mainImageView.image = [UIImage imageNamed:@"poetryBack.jpg"];

    }
    
    
    //元素的布局
    [mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);

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
            make.right.equalTo(self.view.mas_right).offset(-20);
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
    
    
}

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
            
            make.left.equalTo(self.view.mas_left).offset(leftSpace);
            make.top.equalTo(self.authorLabel.mas_bottom).offset(topSpace);
            make.bottom.equalTo(self.view.mas_bottom).offset(-topSpace);
            make.right.equalTo(self.view.mas_right).offset(-leftSpace);
            
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
            
            make.left.equalTo(self.view.mas_left).offset(leftSpace);
            make.top.equalTo(self.titleFullLabel.mas_bottom).offset(topSpace);
            make.right.equalTo(self.view.mas_right).offset(-leftSpace);
            make.height.mas_equalTo(24);
            
        }];
    }
    return _authorLabel;
}


@end

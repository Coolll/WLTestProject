//
//  WLLoginViewController.m
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/14.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "WLLoginViewController.h"
#import "WLCustomTextView.h"
#import "WLUserAgreementView.h"
#import "WLSaveLocalHelper.h"
#import "MBProgressHUD.h"
#import <BmobSDK/Bmob.h>

/*
 #import "Masonry.h"
 #import "UIImageView+WebCache.h"
 #import "AppMacro.h"
 #import "NetworkCenter.h"
 #import "MJRefresh.h"
 #import "WLPublicTool.h"
 #import "WLRequestHelper.h"
 #import "UserInformation.h"
 #import "WLSaveLocalHelper.h"
 #import "AppConfig.h"
 */
typedef void(^LoginSuccessBlock)(UserInformation *user);

@interface WLLoginViewController ()
/**
 *  手机号
 **/
@property (nonatomic,strong) WLCustomTextView *nameTextField;

/**
 *  验证码
 **/
@property (nonatomic,strong) WLCustomTextView *passwordTextField;

/**
 *  获取验证码的label
 **/
@property (nonatomic,strong) UILabel *getCodeLabel;

/**
 *  选中imageView
 **/
@property (nonatomic,strong) UIImageView *selectImageView;

/**
 *  是否选中同意
 **/
@property (nonatomic,assign) BOOL isAgree;

/**
 *  协议视图
 **/
@property (nonatomic,strong) WLUserAgreementView *agreeView;

/**
 *  按钮
 **/
@property (nonatomic,strong) UIButton *loginBtn;
/**
 *  获取验证码按钮
 **/
@property (nonatomic,strong) UIButton *randomBtn;

/**
 *  登录成功返回信息
 **/
@property (nonatomic,copy) LoginSuccessBlock successBlock;
/**
 *  三字名字
 **/
@property (nonatomic, copy) NSArray *threeNameArray;
/**
 *  四字名字
 **/
@property (nonatomic, copy) NSArray *fourNameArray;

/**
 *  选中图片
 **/
@property (nonatomic, strong) UIImageView *checkBoxImageView;

/**
 *  是否需要保存帐号密码
 **/
@property (nonatomic, assign) BOOL needSaveAccount;
/**
 *  记住帐号密码
 **/
@property (nonatomic, strong) UILabel *saveTipLabel;
@end

@implementation WLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBackgroundColor;
    self.titleForNavi = @"登录";
    self.isShowBack = YES;
    [self loadCustomData];
    [self loadCustomView];
    
}


#pragma mark - 初始化数据

- (void)loadCustomData
{
    self.isAgree = YES;
    self.fourNameArray = @[@"梦醒如初",@"夕夏余温",@"空城旧梦",@"浅唱蝶羽",@"流年之殇",@"浮生如梦",@"淡墨文竹",@"陌上烟雨",@"墨羽尘曦",@"雨和潇韵",@"半世流离",@"花开妍沫",@"半夏如烟",@"浅色夏至",@"蔷薇未开",@"踏光琉璃",@"绯色浮华",@"月色殇人",@"来日可期",@"半颗雨韵",@"紫色风铃",@"温风如酒",@"陌路人生",@"孤心木偶",@"笑迎冷风",@"凉城听暖",@"浅冬未晴",@"一顾辗转",@"余音未觉",@"听风而遇",@"南城少年",@"暮雪白头",@"云烟成雨",@"烟雨旧巷",@"清风疏影",@"折扇书生",@"北陌离歌",@"木槿何年",@"归人未归",@"月光倾城",@"清茶煨酒",@"笑靥如故",@"落雪倾城",@"青杉忆笙",@"薄荷微凉",@"落英纷飞",@"漫天花雨",@"墨染樱飞",@"烟雨霓裳",@"梦忆长安",@"清风伴酒",@"墨似流年",@"一指流花",@"倾城之殇",@"半世之泪",@"安之若素",@"宣墨公子",@"伊人旧梦",@"旧岛听风",@"清欢半世",@"青花忆尘",@"酒醉倚梦",@"听风吟月",@"琉璃岁月",@"半城烟沙",@"细雨斜风",@"夜半诗人",@"吹乱心海",@"鱼书雁信",@"空城少年",@"酒伴孤独",@"断桥微雨",@"千城盛雪",@"琴断朱弦",@"入骨相思",@"初雪未央"];
    self.threeNameArray = @[@"冷夜夕",@"蓑笠湿",@"离城梦",@"巴黎醉",@"水无忧",@"离人醉",@"君子傲",@"南风瑾",@"冷月魄",@"南笙离",@"格子秋",@"烟花碎",@"梦依旧",@"冰琉璃",@"清风渡",@"执风晚",@"九天雪",@"萧墨尘",@"十里寂",@"风净松",@"云熙然",@"凝残月",@"断秋风",@"暮成雪",@"安卿尘",@"峰无痕",@"三千寒",@"柳絮声",@"酒倦客",@"笑忘歌",@"故人叹",@"月光蓝",@"挽兰芝",@"秋意浓",@"红人馆",@"紫荆风",@"倾城泪",@"空心人",@"兰芝殇",@"莫言殇",@"离魂殇",@"叶枫下",@"听风起",@"葬风雪",@"凉槿花",@"安若琴",@"葬花吟",@"樱花飞",@"西风残",@"初相识",@"孤行者",@"淡如墨",@"雨潇潇",@"墨香袭",@"七堇年",@"听雨眠",@"洛拾忆",@"冷月处",@"相思醉",@"陌小言",@"葬昔夕",@"一帘梦",@"落红尘",@"伊慕雪",@"浮萍子",@"繁花落",@"无归期",@"醉笙情",@"苏墨染",@"赋流云",@"拂霓裳",@"花寒弦",@"空回眸",@"韶华负",@"阙惜花",@"梦若雨",@"往昔竹",@"梅花弱",@"琰未兮",@"培新雪",@"夏浅浅",@"等风人",@"心微凉",@"陌上桑",@"纸相思",@"路望断",@"红尘梦",@"思归人",@"日月明",@"南乔枝",@"饮长风",@"醉扶月",@"独念旧",@"青杉旧",@"紫精灵",@"百日醉",@"苍暮颜",@"长明灯",@"楚碧瑶",@"苍山林",@"桂花落",@"花锦瑟",@"借一世",@"惊鸿照",@"箜篌引",@"岚风殇",@"冷星魂",@"露海夜",@"惊楼兰",@"醉江山",@"寐年约",@"莫阑珊",@"千杯尽",@"青隐篱",@"清歌终"];
    
    
}
#pragma mark - 返回
- (void)backAction:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 加载视图

- (void)loadCustomView
{
    CGFloat topSpace = 30;
    CGFloat leftSpace = 22;
    CGFloat inputH = 50;
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = ViewBackgroundColor;
    [self.view addSubview:contentView];
    //元素的布局
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.naviView.mas_bottom).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        
    }];
    
    self.nameTextField = [[WLCustomTextView alloc]initWithFrame:CGRectMake(leftSpace, topSpace, PhoneScreen_WIDTH-leftSpace*2, inputH)];
    self.nameTextField.backgroundColor = [UIColor whiteColor];
    self.nameTextField.placeHolderString = @"请输入您的用户名";
    self.nameTextField.leftSpace = 10;
    self.nameTextField.keyboardType = UIKeyboardTypeNumberPad;
    [contentView addSubview:self.nameTextField];

    
    [[WLPublicTool shareTool] addCornerForView:self.nameTextField withTopLeft:YES withTopRight:YES withBottomLeft:NO withBottomRight:NO withCornerRadius:5.0];
    
    CGFloat lineH = 0.7;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(leftSpace, topSpace+inputH, self.nameTextField.frame.size.width, lineH)];
    lineView.backgroundColor = RGBCOLOR(161, 165, 166, 1.0);
    [contentView addSubview:lineView];

    self.passwordTextField = [[WLCustomTextView alloc]initWithFrame:CGRectMake(leftSpace, topSpace+inputH+lineH, self.nameTextField.frame.size.width, inputH)];
    self.passwordTextField.placeHolderString = @"请输入您的密码";
    self.passwordTextField.leftSpace = 10;
    self.passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordTextField.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:self.passwordTextField];
    
    [[WLPublicTool shareTool] addCornerForView:self.passwordTextField withTopLeft:NO withTopRight:NO withBottomLeft:YES withBottomRight:YES withCornerRadius:5.0];
    
    //随即配置按钮
    self.randomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.randomBtn.backgroundColor = [UIColor whiteColor];
    [self.randomBtn addTarget:self action:@selector(getRandomName:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:self.randomBtn];
    
    [self.randomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameTextField.mas_top).offset(0);
        make.bottom.equalTo(self.nameTextField.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(-leftSpace);
        make.width.mas_equalTo(80);
    }];
    
    self.getCodeLabel = [[UILabel alloc]init];
    self.getCodeLabel.layer.borderWidth = 1.0;
    self.getCodeLabel.layer.borderColor = NavigationColor.CGColor;
    self.getCodeLabel.text = @"随机设置";
    self.getCodeLabel.textAlignment = NSTextAlignmentCenter;
    self.getCodeLabel.textColor = NavigationColor;
    self.getCodeLabel.font = [UIFont systemFontOfSize:10.0];
    self.getCodeLabel.layer.cornerRadius = 5.0;
    [contentView addSubview:self.getCodeLabel];
    
    CGFloat codeH = 23;
    CGFloat codeTop = (inputH-codeH)/2;
    CGFloat codeRight = 10;
    [self.getCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.randomBtn.mas_left).offset(0);
        make.top.equalTo(self.nameTextField.mas_top).offset(codeTop);
        make.right.equalTo(self.nameTextField.mas_right).offset(-codeRight);
        make.height.mas_equalTo(codeH);
    }];
    
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.backgroundColor = ViewBackgroundColor;
    [saveBtn addTarget:self action:@selector(changeSaveAccount:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:saveBtn];
    //设置UI布局约束
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(15);//元素顶部约束
        make.leading.equalTo(self.passwordTextField.mas_leading).offset(0);//元素左侧约束
        make.trailing.equalTo(self.passwordTextField.mas_trailing).offset(0);//元素右侧约束
        make.height.mas_equalTo(20);//元素高度
    }];
    
    self.checkBoxImageView = [[UIImageView alloc]init];
    [contentView addSubview:self.checkBoxImageView];
    //设置UI布局约束
    [self.checkBoxImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(15);//元素顶部约束
        make.leading.equalTo(self.passwordTextField.mas_leading).offset(0);//元素左侧约束
        make.width.mas_equalTo(20);//元素宽度
        make.height.mas_equalTo(20);//元素高度
    }];
    
    self.saveTipLabel = [[UILabel alloc]init];
    self.saveTipLabel.text = @"记住帐号密码";//设置文本
    self.saveTipLabel.textColor = RGBCOLOR(50, 50, 50, 1.0);
    self.saveTipLabel.font = [UIFont systemFontOfSize:14];//字号设置
    [contentView addSubview:self.saveTipLabel];
    //设置UI布局约束
    [self.saveTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.checkBoxImageView.mas_top).offset(0);//元素顶部约束
        make.leading.equalTo(self.checkBoxImageView.mas_trailing).offset(10);//元素左侧约束
        make.trailing.equalTo(self.passwordTextField.mas_trailing).offset(0);//元素右侧约束
        make.bottom.equalTo(self.checkBoxImageView.mas_bottom).offset(0);//元素底部约束
       
    }];
    
    
    CGFloat btnHeight = 40;
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.layer.cornerRadius = 5.0f;
    self.loginBtn.backgroundColor = NavigationColor;
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:self.loginBtn];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(leftSpace);
        make.top.equalTo(self.checkBoxImageView.mas_bottom).offset(topSpace);
        make.right.equalTo(self.view.mas_right).offset(-leftSpace);
        make.height.mas_equalTo(btnHeight);
    }];
    
    
  
    CGFloat selectH = 14;
    CGFloat selectTop = 23;
    CGFloat contentH = 15;
    CGFloat contentW = [self widthForTextString:@"注册并登录代表您同意诗词汇用户协议" height:contentH fontSize:10.0];
    CGFloat selectSpace = 4;
    CGFloat selectLeft = (PhoneScreen_WIDTH-selectH-selectSpace-contentW)/2;
    
    
    //选中图片
    self.selectImageView = [[UIImageView alloc]init];
    self.selectImageView.image = self.isAgree ? [UIImage imageNamed:@"select_circle"]:[UIImage imageNamed:@"normal_circle"];
    self.selectImageView.userInteractionEnabled = YES;
    [contentView addSubview:self.selectImageView];
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(selectLeft);
        make.top.equalTo(self.loginBtn.mas_bottom).offset(selectTop);
        make.height.mas_equalTo(selectH);
        make.width.mas_equalTo(selectH);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTheSelectImage:)];
    [self.selectImageView addGestureRecognizer:tap];
    
    
    
    //文本点击事件
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.backgroundColor = RGBCOLOR(238, 241, 245, 1.0);
    [backBtn addTarget:self action:@selector(touchTheUserDelegate:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:backBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.selectImageView.mas_right).offset(selectSpace);
        make.top.equalTo(self.selectImageView.mas_top).offset(0);
        make.height.mas_equalTo(contentH);
        make.width.mas_equalTo(contentW);
    }];

    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.backgroundColor = RGBCOLOR(238, 241, 245, 1.0);
    [contentLabel setTextColor:NavigationColor];
    [contentLabel setText:@"注册并登录代表您同意诗词汇用户协议"];
    contentLabel.font = [UIFont systemFontOfSize:10.0];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    [contentView addSubview:contentLabel];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.selectImageView.mas_right).offset(selectSpace);
        make.top.equalTo(self.selectImageView.mas_top).offset(0);
        make.height.mas_equalTo(contentH);
        make.width.mas_equalTo(contentW);
    }];
    
    [self readLocalData];
    
}


- (void)readLocalData
{
    id localSave = [WLSaveLocalHelper loadObjectForKey:@"needSaveAccount"];
    if (!localSave) {
        localSave = @"";
    }
    NSString *string = [NSString stringWithFormat:@"%@",localSave];
    if ([string isEqualToString:@"0"]) {
        self.needSaveAccount = NO;
        self.checkBoxImageView.image = [UIImage imageNamed:@"check_box"];

    }else{
        self.needSaveAccount = YES;
        self.checkBoxImageView.image = [UIImage imageNamed:@"check_box_sel"];

        id name = kUserName;
        id password = kUserPassword;
        if (!name) {
            name = @"";
        }
        if (!password) {
            password = @"";
        }
        NSString *lastUserName = [NSString stringWithFormat:@"%@",name];
        NSString *lastUserPsd = [NSString stringWithFormat:@"%@",password];
        self.nameTextField.contentString = lastUserName;
        self.passwordTextField.contentString = lastUserPsd;
        self.passwordTextField.mainTextField.secureTextEntry = YES;
    }
}
#pragma mark 计算文本宽度
- (CGFloat) widthForTextString:(NSString *)tStr height:(CGFloat)tHeight fontSize:(CGFloat)tSize{
    
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:tSize]};
    CGRect rect = [tStr boundingRectWithSize:CGSizeMake(MAXFLOAT, tHeight) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width+5;
    
}




#pragma mark - 随机设置
- (void)getRandomName:(UIButton*)sender
{
    NSInteger three = self.threeNameArray.count;
    NSInteger threeIndex = arc4random()%three;
    
    NSInteger four = self.fourNameArray.count;
    NSInteger fourIndex = arc4random()%four;
    
    NSString *name = [NSString stringWithFormat:@"%@丶%@",self.threeNameArray[threeIndex],self.fourNameArray[fourIndex]];
    self.nameTextField.contentString = name;
    
    self.passwordTextField.contentString = @"12345678";
    self.passwordTextField.mainTextField.secureTextEntry = NO;

}


- (void)changeSaveAccount:(UIButton*)sender
{
    if (self.needSaveAccount) {
        self.needSaveAccount = NO;
        [WLSaveLocalHelper saveObject:@"0" forKey:@"needSaveAccount"];
        self.saveTipLabel.textColor = RGBCOLOR(150, 150, 150, 1.0);
        self.checkBoxImageView.image = [UIImage imageNamed:@"check_box"];
        
    }else{
        self.needSaveAccount = YES;
        [WLSaveLocalHelper saveObject:@"1" forKey:@"needSaveAccount"];
        self.saveTipLabel.textColor = RGBCOLOR(50, 50, 50, 1.0);
        self.checkBoxImageView.image = [UIImage imageNamed:@"check_box_sel"];

    }
    
    
}
#pragma mark - 用户登录
- (void)buttonAction:(UIButton*)sender
{
    HidenKeybory;
    self.nameTextField.contentString = @"刘备";
    if (self.nameTextField.contentString.length == 0) {
        
        [self showHUDWithText:@"用户名不可为空"];
        return;
    }
    
    if (self.passwordTextField.contentString.length != 8 ) {
        
        [self showHUDWithText:@"请输入八位数密码"];
        return;
    }
    
    NSLog(@"登录");
    
    [WLSaveLocalHelper saveObject:@"" forKey:LoginTokenKey];
    [WLSaveLocalHelper saveObject:@"" forKey:LoginUserNameKey];
    [WLSaveLocalHelper saveObject:@"" forKey:LoginHeadImageKey];

//    MBProgressHUD *hud = [MBProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow];
//
//    if (!hud) {
//        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//
//        hud.label.text = @"正在处理...";
//    }
    
    [self showLoadingHUDWithText:@"正在登录..."];

    [self registerAction];
   
    
    
    
}

- (void)registerAction
{
    //登录
    BmobUser *bUser = [[BmobUser alloc]init];
    [bUser setUsername:self.nameTextField.contentString];//区分大小写
    [bUser setPassword:self.passwordTextField.contentString];
//    [bUser setObject:@"" forKey:@"totalCount"];
//    [bUser setObject:@"" forKey:@"currentCount"];
//    [bUser setObject:@"" forKey:@"address"];
//    [bUser setObject:@"" forKey:@"accountValue"];
    [bUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            NSLog(@"用户成功注册");
            [self loginAction];
        }else{
            NSLog(@"注册失败");
            if (error.code == 202) {
                //用户已注册
                [self loginAction];
            }
        }
    }];
}

- (void)loginAction
{
    NSLog(@"开始登录");
    
    [BmobUser loginInbackgroundWithAccount:self.nameTextField.contentString andPassword:self.passwordTextField.contentString block:^(BmobUser *user, NSError *error) {
        
        [self hideHUD];
        
        if (user) {
            NSLog(@"登录user:%@",user);
            
            NSDictionary *dataDic = [self responseDataWithUser:user];
            
            [[UserInformation shareUser] refreshUserTokenWithDictionary:dataDic];
            
            [WLSaveLocalHelper saveObject:[self notNillValueWithKey:@"token" withDic:dataDic] forKey:LoginTokenKey];
            [WLSaveLocalHelper saveObject:[self notNillValueWithKey:@"userName" withDic:dataDic] forKey:LoginUserNameKey];
            [WLSaveLocalHelper saveObject:self.passwordTextField.contentString forKey:LoginUserPasswordKey];
            [WLSaveLocalHelper saveObject:user.objectId forKey:LoginUserIDKey];
            [WLSaveLocalHelper saveObject:@"" forKey:LoginHeadImageKey];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.successBlock) {
                    self.successBlock([UserInformation shareUser]);
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                
            });
            
        }else{
            NSLog(@"登录error:%@",error);
        }
    }];

}


- (NSString*)notNillValueWithKey:(NSString*)key withDic:(NSDictionary*)dic
{
    id object = [dic objectForKey:key];
    
    if (object) {
        
        NSString *string = [NSString stringWithFormat:@"%@",object];
        return string;
    }
    
    return @"";
    
}

- (NSDictionary*)responseDataWithUser:(BmobUser*)user
{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    NSString *userName = [NSString stringWithFormat:@"%@",[user objectForKey:@"username"]];
    NSString *userId = [NSString stringWithFormat:@"%@",user.objectId];
    NSString *sessionToken = [NSString stringWithFormat:@"%@",[user objectForKey:@"sessionToken"]];

    [dataDic setObject:userName forKey:@"userName"];
    [dataDic setObject:userId forKey:@"userId"];
    [dataDic setObject:self.passwordTextField.contentString forKey:@"password"];
    [dataDic setObject:sessionToken forKey:@"token"];
    
    return dataDic;
}


#pragma mark - 底部的勾选图片点击
- (void)touchTheSelectImage:(UITapGestureRecognizer*)tap
{
    self.isAgree = !self.isAgree;
    
    self.selectImageView.image = self.isAgree ? [UIImage imageNamed:@"select_circle"]:[UIImage imageNamed:@"normal_circle"];
    
    if (self.isAgree) {
        self.selectImageView.image = [UIImage imageNamed:@"select_circle"];
        self.loginBtn.backgroundColor = NavigationColor;
        self.loginBtn.enabled = YES;
    }else{
        self.selectImageView.image = [UIImage imageNamed:@"normal_circle"];
        self.loginBtn.backgroundColor = [UIColor lightGrayColor];
        self.loginBtn.enabled = NO;
    }


}


#pragma mark - 用户协议点击
- (void)touchTheUserDelegate:(UIButton*)sender
{
    HidenKeybory;

    if (!self.agreeView) {
        self.agreeView = [[WLUserAgreementView alloc]init];
        
        __weak __typeof(self)weakSelf = self;
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        [self.agreeView clickButtonWithBlock:^(BOOL isAgree) {
            
            [strongSelf userDealAction:isAgree];
            
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:self.agreeView];

    }
    
    [self.agreeView showAgreementView];
}

#pragma mark - 用户处理用户协议
- (void)userDealAction:(BOOL)isAgree
{
    NSLog(@"用户%@了协议",isAgree?@"同意":@"拒绝");
    
    if (isAgree) {
        self.isAgree = YES;
        self.selectImageView.image = [UIImage imageNamed:@"select_circle"];
        self.loginBtn.backgroundColor = NavigationColor;
        self.loginBtn.enabled = YES;
    }else{
        self.isAgree = NO;
        self.selectImageView.image = [UIImage imageNamed:@"normal_circle"];
        self.loginBtn.backgroundColor = [UIColor lightGrayColor];
        self.loginBtn.enabled = NO;
    }
    
}

#pragma mark - 登录成功

- (void)loginSuccessWithBlock:(void(^)(UserInformation *user))block
{
    if (block) {
        self.successBlock = block;
    }
}


 - (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

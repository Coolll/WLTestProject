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

#import "UserInfoModel.h"
#import "KeyChainHelper.h"
#import "NetworkHelper.h"
static NSString *keyInTheKeyChain = @"com.wangqilong.wqlPoetryProject";
/*
 #import "Masonry.h"
 #import "UIImageView+WebCache.h"
 #import "AppMacro.h"
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
 *  主内容View
 **/
@property (nonatomic,strong) UIView *contentView;


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
 *  是否需要显示密码
 **/
@property (nonatomic, assign) BOOL needShowPassword;

/**
 *  记住帐号密码
 **/
@property (nonatomic, strong) UILabel *saveTipLabel;
/**
 *  展示/隐藏 密码
 **/
@property (nonatomic,strong) UIImageView *showPwdImageView;
/**
 *  注册时提示密码错误的解释
 **/
@property (nonatomic,strong) UIView *errorTipView;



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
    
    id object = [KeyChainHelper loadDataWithKey:keyInTheKeyChain];
    
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
    
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = ViewBackgroundColor;
    [self.view addSubview:self.contentView];
    //元素的布局
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.view.mas_leading).offset(0);
        make.top.equalTo(self.naviView.mas_bottom).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.trailing.equalTo(self.view.mas_trailing).offset(0);
        
    }];
    
    self.nameTextField = [[WLCustomTextView alloc]initWithFrame:CGRectMake(leftSpace, topSpace, PhoneScreen_WIDTH-leftSpace*2, inputH)];
    self.nameTextField.backgroundColor = [UIColor whiteColor];
    self.nameTextField.placeHolderString = @"请输入您的用户名";
    self.nameTextField.leftSpace = 10;
    [self.contentView addSubview:self.nameTextField];

    
    [[WLPublicTool shareTool] addCornerForView:self.nameTextField withTopLeft:YES withTopRight:YES withBottomLeft:NO withBottomRight:NO withCornerRadius:5.0];
    
    CGFloat lineH = 0.7;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(leftSpace, topSpace+inputH, self.nameTextField.frame.size.width, lineH)];
    lineView.backgroundColor = RGBCOLOR(161, 165, 166, 1.0);
    [self.contentView addSubview:lineView];

    self.passwordTextField = [[WLCustomTextView alloc]initWithFrame:CGRectMake(leftSpace, topSpace+inputH+lineH, self.nameTextField.frame.size.width, inputH)];
    self.passwordTextField.placeHolderString = @"请输入您的密码";
    self.passwordTextField.leftSpace = 10;
    self.passwordTextField.canInputLength = 8;
    self.passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordTextField.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.passwordTextField];
    
    [[WLPublicTool shareTool] addCornerForView:self.passwordTextField withTopLeft:NO withTopRight:NO withBottomLeft:YES withBottomRight:YES withCornerRadius:5.0];
    
    //随机配置按钮
    self.randomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.randomBtn.backgroundColor = [UIColor whiteColor];
    [self.randomBtn addTarget:self action:@selector(getRandomName:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.randomBtn];
    
    [self.randomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameTextField.mas_top).offset(0);
        make.bottom.equalTo(self.nameTextField.mas_bottom).offset(0);
        make.trailing.equalTo(self.view.mas_trailing).offset(-leftSpace);
        make.width.mas_equalTo(80);
    }];
    
    self.getCodeLabel = [[UILabel alloc]init];
    self.getCodeLabel.layer.borderWidth = 1.0;
    self.getCodeLabel.layer.borderColor = NavigationColor.CGColor;
    self.getCodeLabel.text = @"快速设置";
    self.getCodeLabel.textAlignment = NSTextAlignmentCenter;
    self.getCodeLabel.textColor = NavigationColor;
    self.getCodeLabel.font = [UIFont systemFontOfSize:10.0];
    self.getCodeLabel.layer.cornerRadius = 5.0;
    [self.contentView addSubview:self.getCodeLabel];
    
    CGFloat codeH = 23;
    CGFloat codeTop = (inputH-codeH)/2;
    CGFloat codeRight = 10;
    [self.getCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.randomBtn.mas_leading).offset(0);
        make.top.equalTo(self.nameTextField.mas_top).offset(codeTop);
        make.trailing.equalTo(self.nameTextField.mas_trailing).offset(-codeRight);
        make.height.mas_equalTo(codeH);
    }];
    
    
    
    //隐藏密码按钮
    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showBtn.backgroundColor = [UIColor whiteColor];
    [showBtn addTarget:self action:@selector(changePasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:showBtn];
    
    [showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.passwordTextField.mas_top).offset(0);
        make.bottom.equalTo(self.passwordTextField.mas_bottom).offset(0);
        make.trailing.equalTo(self.view.mas_trailing).offset(-leftSpace);
        make.width.mas_equalTo(100);
    }];
    
    self.showPwdImageView = [[UIImageView alloc]init];
    self.showPwdImageView.image = [UIImage imageNamed:@""];
    self.showPwdImageView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.showPwdImageView];
    
    CGFloat imageW = 20;
    CGFloat imageH = 23;
    CGFloat imageTop = (inputH-imageH)/2;
    [self.showPwdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.passwordTextField.mas_top).offset(imageTop);
        make.centerX.equalTo(self.getCodeLabel.mas_centerX);
        make.width.mas_equalTo(imageW);
        make.height.mas_equalTo(imageH);
    }];
    
    
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.backgroundColor = ViewBackgroundColor;
    [saveBtn addTarget:self action:@selector(changeSaveAccount:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:saveBtn];
    //设置UI布局约束
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(10);//元素顶部约束
        make.leading.equalTo(self.passwordTextField.mas_leading).offset(0);//元素左侧约束
        make.trailing.equalTo(self.passwordTextField.mas_trailing).offset(0);//元素右侧约束
        make.height.mas_equalTo(30);//元素高度
    }];
    
    self.checkBoxImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.checkBoxImageView];
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
    [self.contentView addSubview:self.saveTipLabel];
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
    [self.contentView addSubview:self.loginBtn];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.view.mas_leading).offset(leftSpace);
        make.top.equalTo(self.checkBoxImageView.mas_bottom).offset(topSpace);
        make.trailing.equalTo(self.view.mas_trailing).offset(-leftSpace);
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
    [self.contentView addSubview:self.selectImageView];
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.view.mas_leading).offset(selectLeft);
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
    [self.contentView addSubview:backBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.selectImageView.mas_trailing).offset(selectSpace);
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
    [self.contentView addSubview:contentLabel];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.selectImageView.mas_trailing).offset(selectSpace);
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
        
        if (lastUserPsd.length > 0 && lastUserName.length > 0) {
            self.nameTextField.contentString = lastUserName;
            self.passwordTextField.contentString = lastUserPsd;
            self.passwordTextField.mainTextField.secureTextEntry = YES;
        }else if (lastUserPsd.length == 0 && lastUserName.length > 0){
            self.nameTextField.contentString = lastUserName;
            self.passwordTextField.mainTextField.secureTextEntry = YES;
        }
        
    }
    
    
    //是否需要展示密码
    id localShowPwd = [WLSaveLocalHelper loadObjectForKey:@"needShowPassword"];
    if (!localShowPwd) {
        localShowPwd = @"1";
    }
    NSString *showPwd = [NSString stringWithFormat:@"%@",localShowPwd];
    if ([showPwd isEqualToString:@"1"]) {
        self.needShowPassword = YES;
        self.showPwdImageView.image = [UIImage imageNamed:@"showPassword"];
        self.passwordTextField.mainTextField.secureTextEntry = NO;
    }else{
        self.needShowPassword = NO;
        self.showPwdImageView.image = [UIImage imageNamed:@"hidePassword"];
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
    
    NSInteger count = 1000+arc4random()%8888;
    
    NSString *name = [NSString stringWithFormat:@"%@丶%@%ld",self.threeNameArray[threeIndex],self.fourNameArray[fourIndex],(long)count];
    self.nameTextField.contentString = name;
    
    
    NSInteger pwd = 10000000+arc4random()%89999999;

    self.passwordTextField.contentString = [NSString stringWithFormat:@"%ld",(long)pwd];
    
    //随机设置的话，需要把密码展示给用户
    self.passwordTextField.mainTextField.secureTextEntry = NO;
    self.needShowPassword = YES;
    self.showPwdImageView.image = [UIImage imageNamed:@"showPassword"];
    [WLSaveLocalHelper saveObject:@"1" forKey:@"needShowPassword"];

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

- (void)changePasswordAction:(UIButton*)sender
{
    if (self.needShowPassword) {
        self.needShowPassword = NO;
        [WLSaveLocalHelper saveObject:@"0" forKey:@"needShowPassword"];
        self.showPwdImageView.image = [UIImage imageNamed:@"hidePassword"];
        self.passwordTextField.mainTextField.secureTextEntry = YES;
    }else{
        self.needShowPassword = YES;
        [WLSaveLocalHelper saveObject:@"1" forKey:@"needShowPassword"];
        self.showPwdImageView.image = [UIImage imageNamed:@"showPassword"];
        self.passwordTextField.mainTextField.secureTextEntry = NO;
        
    }
}
#pragma mark - 用户登录
- (void)buttonAction:(UIButton*)sender
{
    HidenKeybory;

    if (self.nameTextField.contentString.length == 0) {
        
        [self showHUDWithText:@"用户名不可为空"];
        return;
    }
    
    if (self.passwordTextField.contentString.length != 8 ) {
        
        [self showHUDWithText:@"密码为8位数字"];
        return;
    }
    
    NSLog(@"登录");
    
    
    [self showLoadingHUDWithText:@"校验账户信息..."];

    [self registerAction];
   
    
}

- (void)registerAction
{
    [[NetworkHelper shareHelper] loginWithUserName:self.nameTextField.contentString password:self.passwordTextField.contentString withCompletion:^(BOOL success, NSDictionary *dic, NSError *error) {
        
        [self hideHUD];
        if (success) {
            
            NSString *code = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
            if (![code isEqualToString:@"1000"]) {
                NSString *tipMessage = [dic objectForKey:@"message"];
                [self showHUDWithText:tipMessage];
                return ;
            }
            
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            //保存登录信息到本地
            [WLSaveLocalHelper saveUserInfo:dataDic];
            //更新基本信息
            [[UserInformation shareUser] refreshUserWithDictionary:dataDic];
            
            

        
            [WLSaveLocalHelper saveObject:@"1" forKey:LoginStatusKey];//登录成功
            
            
            //需要记住密码，则保存，不需要，则保存空字符串
            if (self.needSaveAccount) {
                NSDictionary *dic = @{@"account":self.nameTextField.contentString,@"password":self.passwordTextField.contentString};
                if (dic) {
                    [KeyChainHelper saveKey:keyInTheKeyChain withValue:dic];
                }
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.successBlock) {
                    self.successBlock([UserInformation shareUser]);
                }
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }

    }];
    
}



- (void)showErrorTipView
{
    self.errorTipView.hidden = NO;
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.view.mas_leading).offset(0);
        make.top.equalTo(self.errorTipView.mas_bottom).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.trailing.equalTo(self.view.mas_trailing).offset(0);
            
    }];
    
}

- (void)hideErrorTipAction:(UIButton*)sender
{
    self.errorTipView.hidden = YES;
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.view.mas_leading).offset(0);
        make.top.equalTo(self.naviView.mas_bottom).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.trailing.equalTo(self.view.mas_trailing).offset(0);
        
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


#pragma mark - 属性
- (UIView*)errorTipView
{
    if (!_errorTipView) {
        NSString *tipString = @"首次登录时账号会自动注册，若登录失败，建议您核对密码或修改用户名后重试~";
        UIFont *font = [UIFont systemFontOfSize:12.f];
        
        CGFloat leftSpace = 22;
        CGFloat rightSpace = 30;
        
        _errorTipView = [[UIView alloc]init];
        _errorTipView.backgroundColor = RGBCOLOR(249, 72, 35, 1.0);
        [self.view addSubview:_errorTipView];
        CGFloat height = [WLPublicTool heightForTextString:tipString width:(PhoneScreen_WIDTH-leftSpace-rightSpace) font:font];
        //元素的布局
        [_errorTipView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.view.mas_leading).offset(0);
            make.top.equalTo(self.naviView.mas_bottom).offset(0);
            make.trailing.equalTo(self.view.mas_trailing).offset(0);
            make.height.mas_equalTo(height+10);
            
        }];
        
        UILabel *tipLabel = [[UILabel alloc]init];
        tipLabel.text = tipString;
        tipLabel.font = font;
        tipLabel.numberOfLines = 0;
        tipLabel.textColor = RGBCOLOR(255, 255, 255, 1.0);
        [_errorTipView addSubview:tipLabel];
        //元素的布局
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(_errorTipView.mas_leading).offset(leftSpace);
            make.top.equalTo(_errorTipView.mas_top).offset(5);
            make.trailing.equalTo(_errorTipView.mas_trailing).offset(-rightSpace);
            make.height.mas_equalTo(height);
            
        }];
        
        UIImageView *closeImage = [[UIImageView alloc]init];
        closeImage.image = [UIImage imageNamed:@"closeTip"];
        [_errorTipView addSubview:closeImage];
        //元素的布局
        [closeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_errorTipView.mas_top).offset((height-10)/2);
            make.trailing.equalTo(_errorTipView.mas_trailing).offset(-5);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
            
        }];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton addTarget:self action:@selector(hideErrorTipAction:) forControlEvents:UIControlEventTouchUpInside];
        [_errorTipView addSubview:closeButton];
        //元素的布局
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(tipLabel.mas_trailing).offset(0);
            make.top.equalTo(_errorTipView.mas_top).offset(0);
            make.bottom.equalTo(_errorTipView.mas_bottom).offset(-0);
            make.trailing.equalTo(_errorTipView.mas_trailing).offset(0);
            
        }];
        
    }
    return _errorTipView;
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

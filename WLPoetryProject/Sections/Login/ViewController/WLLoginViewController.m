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
 *  名字
 **/
@property (nonatomic, copy) NSArray *randomNameArray;


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
//    self.randomNameArray = @[@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",@"<##>",];

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
    
    //获取验证码按钮
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
    
    
    CGFloat btnHeight = 40;
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.layer.cornerRadius = 5.0f;
    self.loginBtn.backgroundColor = NavigationColor;
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:self.loginBtn];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(leftSpace);
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(topSpace);
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
    
}


#pragma mark - 用户登录
- (void)loginAction:(UIButton*)sender
{
    HidenKeybory;
    
    if (![self checkStringWithOrigin:self.nameTextField.contentString]) {
        
        [self showHUDWithText:@"请检查手机号"];
        return;
    }
    
    if (self.nameTextField.contentString.length != 11 ) {
        
        [self showHUDWithText:@"请检查手机号"];
        return;
    }
    

    NSLog(@"登录");
    
    [WLSaveLocalHelper saveObject:@"" forKey:LoginTokenKey];
    [WLSaveLocalHelper saveObject:@"" forKey:LoginUserNameKey];
    [WLSaveLocalHelper saveObject:@"" forKey:LoginHeadImageKey];

    
    NSString *url = WL_BASE_URL(@"public/api/1.0/login");
    NSDictionary *param = @{@"userName":self.nameTextField.contentString,
                            @"checkCode":self.passwordTextField.contentString};

    [[NetworkCenter shareCenter] requestDataWithURL:url withParams:param withHttpType:POST_HttpType withProgress:nil withResult:^(id result) {
        NSLog(@"Login:%@",result);
        NSString *codeString = [NSString stringWithFormat:@"%@",[result objectForKey:@"code"]];
        
        if ([codeString isEqualToString:@"1000"]) {
            
            NSDictionary *data = result[@"data"];
            
            [[UserInformation shareUser] refreshUserTokenWithDictionary:data];
            
            [WLSaveLocalHelper saveObject:[self notNillValueWithKey:@"token" withDic:data] forKey:LoginTokenKey];
            [WLSaveLocalHelper saveObject:[self notNillValueWithKey:@"userName" withDic:data] forKey:LoginUserNameKey];

            NSString *imagePath = [self notNillValueWithKey:@"userImgurl" withDic:data];
            NSString *fullPath = [NSString stringWithFormat:@"%@%@",UserHeadImageBase,imagePath];
            [WLSaveLocalHelper saveObject:fullPath forKey:LoginHeadImageKey];

            [WLSaveLocalHelper saveObject:[self notNillValueWithKey:@"ubalance" withDic:data] forKey:LoginkUserBalanceKey];
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (self.successBlock) {
                    self.successBlock([UserInformation shareUser]);
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                
            });
            
           

            
            
        }else{
            
            NSString *errorString = [NSString stringWithFormat:@"服务不可用"];
            
            [self showHUDWithText:errorString];
            
        }

        
    } withError:^(NSInteger errorCode, NSString *errorMsg) {
//        [self showHUDWithText:RequestFailed];
    } isSupportHUD:YES];
    
}

- (BOOL)checkStringWithOrigin:(NSString*)origin
{
    NSString *regex = @"^[1][3,4,5,7,8]([0-9]){9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [pred evaluateWithObject:origin];
    if (isValid) {
        NSLog(@"可用");
        return YES;
    }else{
        NSLog(@"不可用");
        return NO;
    }
    
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

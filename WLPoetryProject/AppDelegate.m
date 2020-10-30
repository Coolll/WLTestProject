//
//  AppDelegate.m
//  WLPoetryProject
//
//  Created by 龙培 on 2018/4/2.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "AppDelegate.h"
#import "YLTabbarController.h"
#import "LeadViewController.h"
#import "BaseNavigationController.h"
#import "YLHomeViewController.h"
#import "PoetryModel.h"
#import "WLSaveLocalHelper.h"
#import "LaunchController.h"
#import "WLLaunchView.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
#import "UserInfoModel.h"

#define FIRSTOPENAPP  @"FirstLoadPoetryProject"

@interface AppDelegate ()
/**
 *  tabbar
 **/
@property (nonatomic,strong) YLTabbarController *tabbarVC;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    

    [self getCurrentUserLikeLists];

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    [self loadCustomTabbar];

    [self recordOpenApp];
    [self registShareSDK];
        

    
    
    NSLog(@"在DevBranch添加");
    return YES;
}


- (void)registShareSDK
{
    /**初始化ShareSDK应用
     
     @param activePlatforms
     
     使用的分享平台集合
     
     @param importHandler (onImport)
     
     导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作
     
     @param configurationHandler (onConfiguration)
     
     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
     
     */
    
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ),
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
                 
             default:
                 break;
         }
     }onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo){
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"569824601"
                                           appSecret:@"4da74feaa80d24c3f6cf5f9ee6acbec7"
                                         redirectUri:@"https://www.jianshu.com/u/542d8ac6eb58"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx1069708dea249294"
                                       appSecret:@"9aa6b97f9719584286c528e13cfc2f2a"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1106986720"
                                      appKey:@"ecagpQBO9lf3wJBe"
                                    authType:SSDKAuthTypeBoth];
                 break;
                 
                 
                 break;
             default:
                 break;
         }
     }];
    
}


- (void)loadLaunchImage
{
    
    CGSize viewSize = [UIApplication sharedApplication].keyWindow.bounds.size;
    NSString*viewOrientation =@"Portrait";//横屏请设置成 @"Landscape"
    NSString*launchImage =nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for(NSDictionary* dict in imagesDict) {
        CGSize imageSize =CGSizeFromString(dict[@"UILaunchImageSize"]);
        if(CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    

    WLLaunchView *view = [[WLLaunchView alloc]init];
    view.frame = [UIScreen mainScreen].bounds;
    view.bgImage = [UIImage imageNamed:launchImage];
    [self.window addSubview:view];
    
    [self.window bringSubviewToFront:view];
}




- (void)loadCustomTabbar
{
    
    self.tabbarVC = [[YLTabbarController alloc]init];
    
    self.window.rootViewController = self.tabbarVC;
    
    [self loadLaunchImage];
    
}

- (void)recordOpenApp{
    id userId = kUserID;
    if (!userId || ![userId isKindOfClass:[NSString class]] || kStringIsEmpty(userId)) {
        return;
    }
    [[NetworkHelper shareHelper] updateUserOpenAppWithCompletion:^(BOOL success, NSDictionary * _Nullable dic, NSError * _Nullable error) {
        
    }];
}

- (void)getCurrentUserLikeLists
{
    id token = kUserToken;
    if (!token) {
        token = @"";
    }
    
    NSString *tokenString = [NSString stringWithFormat:@"%@",token];
    //如果本地没有token，那么就意味着用户没有登录，不需要去拿收藏列表,该数据为未收藏
    if (tokenString.length == 0) {
        return;
    }
    
    id userId = kUserID;
    if (!userId) {
        userId = @"";
    }
    NSString *userIdString = [NSString stringWithFormat:@"%@",userId];
    
    [[NetworkHelper shareHelper] requestUserAllLikes:userIdString withCompletion:^(BOOL success, NSDictionary *dic, NSError *error) {
        
        if (success) {
            
            NSString *code = [NSString stringWithFormat:@"%@",[dic objectForKey:@"retCode"]];
            if (![code isEqualToString:@"1000"]) {
                return;
            }
            
            NSArray *dataArr = [dic objectForKey:@"data"];
            [WLSaveLocalHelper saveLikeList:dataArr];
            
        }
        
    }];
    
}

- (void)loginAction
{
    NSLog(@"开始登录");
    
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}




@end


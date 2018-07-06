//
//  AppMacro.h
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/1.
//  Copyright © 2017年 龙培. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

#define PhoneScreen_HEIGHT [UIScreen mainScreen].bounds.size.height
#define PhoneScreen_WIDTH [UIScreen mainScreen].bounds.size.width
#define RGBCOLOR(r,g,b,_alpha) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:_alpha]

#define TabbarTextNormalColor RGBCOLOR(180,180,180,1.0)
#define TabbarTextSelectColor RGBCOLOR(66,130,191,1.0)
#define NavigationColor RGBCOLOR(65, 160, 225, 1.0)
#define ViewBackgroundColor RGBCOLOR(240, 240, 240, 1.0)
#define RequestFailed @"请稍后重试"
//刘 本机的
//#define WL_BASE_URL(_PATH_) [@"http://192.168.1.151:8080/poker-view-service/" stringByAppendingString:_PATH_]
//#define WL_H5_URL(_PATH_) [@"http://192.168.1.151/poker-theory/" stringByAppendingString:_PATH_]

//测试的

//http://poker-t.pokershove.com
//121.196.204.216

//#define WL_BASE_URL(_PATH_) [@"http://pker.pokershove.com/poker-view-service/" stringByAppendingString:_PATH_]
//#define WL_Mall_RequestURL @"http://pker.pokershove.com/Integral-Service/poker/redirect"
//#define WL_H5_URL(_PATH_) [@"http://pker.pokershove.com/poker-theory/" stringByAppendingString:_PATH_]
//#define ImageBaseURL @"http://pker.pokershove.com/"
//#define UserHeadImageBase @"http://pker.pokershove.com/poker-view-service/"



//#define WL_BASE_URL(_PATH_) [@"http://121.196.204.216/poker-view-service/" stringByAppendingString:_PATH_]
//#define WL_Mall_RequestURL @"http://121.196.204.216/Integral-Service/poker/redirect"
//#define WL_H5_URL(_PATH_) [@"http://121.196.204.216/poker-theory/" stringByAppendingString:_PATH_]
//#define ImageBaseURL @"http://121.196.204.216/"
//#define UserHeadImageBase @"http://121.196.204.216/poker-view-service/"


//正式
#define WL_BASE_URL(_PATH_) [@"http://106.14.59.104/poker-view-service/" stringByAppendingString:_PATH_]
#define WL_Mall_RequestURL @"http://106.14.59.104/Integral-Service/poker/redirect"
#define WL_H5_URL(_PATH_) [@"http://106.14.59.104/poker-theory/" stringByAppendingString:_PATH_]
//#define WL_H5_URL(_PATH_) [@"http://www.pokershove.com/poker-theory/" stringByAppendingString:_PATH_]

#define ImageBaseURL @"http://106.14.59.104/"
#define UserHeadImageBase @"http://106.14.59.104/poker-view-service/"



#define HidenKeybory {[[[UIApplication sharedApplication] keyWindow] endEditing:YES];}

//用户的token
#define kUserToken [WLSaveLocalHelper loadObjectForKey:LoginTokenKey]
#define LoginTokenKey @"WLUserLoginToken"

//用户的登录名
#define kUserName [WLSaveLocalHelper loadObjectForKey:LoginUserNameKey]
#define LoginUserNameKey @"WLUserLoginUserName"

//用户的密码
#define kUserPassword [WLSaveLocalHelper loadObjectForKey:LoginUserPasswordKey]
#define LoginUserPasswordKey @"WLUserLoginUserPassword"

//用户的头像
#define kUserHeadImage [WLSaveLocalHelper loadObjectForKey:LoginHeadImageKey]
#define LoginHeadImageKey @"WLUserLoginUserHeadImage"

//用户的userId
#define kUserID [WLSaveLocalHelper loadObjectForKey:LoginUserIDKey]
#define LoginUserIDKey @"WLUserLoginUserID"

//用户的本地设置，诸如诗词的字号
#define kUserConfigure [WLSaveLocalHelper loadObjectForKey:UserPoetryConfigure]
#define UserPoetryConfigure @"WLUserPoetryConfigure"


#define kNotAlertUserUpdateVersion @"WLNotAlertUserUpdateVersion"


#ifdef DEBUG
#define NSLog(FORMAT, ...) {\
NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];\
[dateFormatter setDateStyle:NSDateFormatterFullStyle];\
[dateFormatter setTimeStyle:NSDateFormatterFullStyle];\
[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"]; \
NSString *str = [dateFormatter stringFromDate:[NSDate date]];\
fprintf(stderr,"%s [%s  %d行] %s\n",[str UTF8String],[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);\
}

#else
#define DELog(...)
#endif


#endif /* AppMacro_h */

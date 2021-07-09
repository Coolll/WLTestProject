//
//  AppMacro.h
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/1.
//  Copyright © 2017年 龙培. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h


///环境
#ifdef DEBUG
//#define BaseURL @"http://192.168.0.108:8080/"//测试渠道
#define BaseURL @"https://www.wqldeveloper.com/poetry/"//测试渠道

#else

///生产环境
#define BaseURL @"https://www.wqldeveloper.com/poetry/"//正式环境

#endif


#define PhoneScreen_HEIGHT [UIScreen mainScreen].bounds.size.height
#define PhoneScreen_WIDTH [UIScreen mainScreen].bounds.size.width
#define RGBCOLOR(r,g,b,_alpha) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:_alpha]

#define TabbarTextNormalColor RGBCOLOR(180,180,180,1.0)
#define TabbarTextSelectColor RGBCOLOR(66,130,191,1.0)
#define NavigationColor RGBCOLOR(65, 160, 225, 1.0)
#define ViewBackgroundColor RGBCOLOR(240, 240, 240, 1.0)
#define RequestFailed @"请稍后重试"
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || [[NSString stringWithFormat:@"%@",str] isEqualToString: @"(null)"]|| [[NSString stringWithFormat:@"%@",str] isEqualToString: @"<null>"] ||[[NSString stringWithFormat:@"%@",str] isEqualToString: @""]|| str == nil || [[NSString stringWithFormat:@"%@",str] length] < 1 ? YES : NO )




#define HidenKeybory {[[[UIApplication sharedApplication] keyWindow] endEditing:YES];}

//用户的token
#define kUserToken [WLSaveLocalHelper fetchUserToken]

//用户的登录名
#define kUserName [WLSaveLocalHelper fetchUserName]

//用户的密码
#define kUserPassword [WLSaveLocalHelper fetchUserPassword]

//用户的头像
#define kUserHeadImage [WLSaveLocalHelper fetchUserHeadImage]

//用户的userId
#define kUserID [WLSaveLocalHelper fetchUserID]

//用户的登录状态
#define kLoginStatus [WLSaveLocalHelper loadObjectForKey:LoginStatusKey]
#define LoginStatusKey @"UserCurrentLoginStatus"




//用户的本地设置，诸如诗词的字号
#define kUserConfigure [WLSaveLocalHelper loadObjectForKey:UserPoetryConfigure]
#define UserPoetryConfigure @"WLUserPoetryConfigure"


#define kNotAlertUserUpdateVersion @"WLNotAlertUserUpdateVersion"

//屏幕的宽高比
#define kWRate PhoneScreen_WIDTH/414.f
#define kHRate PhoneScreen_HEIGHT/736.f

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

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



#define HidenKeybory {[[[UIApplication sharedApplication] keyWindow] endEditing:YES];}

//用户的token
#define kUserToken [[[WLCoreDataHelper shareHelper] fetchCurrentUserModel] fetchToken]

//用户的登录名
#define kUserName [[[WLCoreDataHelper shareHelper] fetchCurrentUserModel] fetchName]

//用户的密码
#define kUserPassword [[[WLCoreDataHelper shareHelper] fetchCurrentUserModel] fetchPassword]

//用户的头像
#define kUserHeadImage [[[WLCoreDataHelper shareHelper] fetchCurrentUserModel] fetchImageURL]

//用户的userId
#define kUserID [WLSaveLocalHelper loadObjectForKey:LoginUserIDKey]
#define LoginUserIDKey @"CurrentLoginUserID"

//用户的登录状态
#define kLoginStatus [WLSaveLocalHelper loadObjectForKey:LoginStatusKey]
#define LoginStatusKey @"UserCurrentLoginStatus"


#define kClearUserInfo  [[WLCoreDataHelper shareHelper]clearUserInfo]


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

//
//  MyMBProgress.m
//  RemoteAcceptance
//
//  Created by 韩笑 on 2016/10/18.
//  Copyright © 2016年 Hauler. All rights reserved.
//

#import "MyMBProgress.h"
#import "MBProgressHUD.h"
@implementation MyMBProgress

+ (void)showTextMessage:(NSString *)message {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = NSLocalizedString(message, @"HUD message title");
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, 3000);
    [hud hideAnimated:YES afterDelay:3.f];
}
@end

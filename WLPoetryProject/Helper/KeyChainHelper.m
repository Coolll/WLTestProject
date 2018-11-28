//
//  KeyChainHelper.m
//  TestKeyChain
//
//  Created by 龙培 on 17/3/29.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "KeyChainHelper.h"
#import <Security/Security.h>

@implementation KeyChainHelper

+ (NSMutableDictionary*)getKeyChainQuery:(NSString*)service
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,
            (__bridge_transfer id)kSecClass,
            service,
            (__bridge_transfer id)kSecAttrService,
            service,
            (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,
            (__bridge_transfer id)kSecAttrAccessible,nil];
}


+ (void)saveKey:(NSString*)service withValue:(id)data
{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:service];
    
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    
    //添加
    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
}


+ (id)loadDataWithKey:(NSString*)service
{
    id returnValue = nil;
    
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:service];
    
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
  
    /*
     这种方式等价于下面的方式
    NSData *data = NULL;
    CFTypeRef dataTypeRef = (__bridge CFTypeRef)data;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, &dataTypeRef);
    data = (__bridge NSData*)dataTypeRef;
    
    if (status == errSecSuccess) {
        
        if (data) {
            returnValue = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData*)dataTypeRef];
        }
        
    }
    */

    CFDataRef keyData = NULL;

    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            returnValue = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData*)keyData];
            
        } @catch (NSException *exception) {
            NSLog(@"Unarchive of %@ failed:%@",service,exception);

        } @finally {
            
        }
    }
    
    
    return returnValue;
}


//删除数据
+ (void)deleteDataWithKey:(NSString*)service
{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:service];
    
    SecItemDelete((__bridge_retained CFDictionaryRef) keychainQuery);
    
}
@end

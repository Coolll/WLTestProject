//
//  NetworkHelper.m
//  WLPoetryProject
//
//  Created by 变啦 on 2019/10/24.
//  Copyright © 2019 龙培. All rights reserved.
//

#import "NetworkHelper.h"
#import "BaseNetwork.h"
#import "AESCipher.h"
#import "RSAEncryptor.h"
@interface NetworkHelper()
/**
 *  base
 **/
@property (nonatomic,strong) BaseNetwork *baseNetwork;


@end
@implementation NetworkHelper

+ (NetworkHelper *)shareHelper{
    static NetworkHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[NetworkHelper alloc] init];
        helper.baseNetwork = [BaseNetwork shareInstance];
    });
    return helper;
}


#pragma mark - 网络请求

//备份背景图片
- (void)uploadImage:(NSDictionary*)param
{
    NSString *path = @"api/image/insert";
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,path];
    [self.baseNetwork requestPostWithBody:param withUrlString:urlString withCompletion:NULL];
}

//备份诗词
- (void)uploadPoetry:(NSDictionary*)param
{

    [self.baseNetwork requestPostWithBody:param withUrlString:@"api/poetry/insert" withCompletion:NULL];

}
//更新诗词
- (void)updatePoetry:(NSDictionary*)param
{

    [self.baseNetwork requestPostWithBody:param withUrlString:@"api/poetry/update" withCompletion:NULL];

}

//登录
- (void)loginWithUserName:(NSString*)userName password:(NSString*)pwd withCompletion:(RequestResultBlock)block
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:userName forKey:@"nickName"];
    [param setObject:pwd forKey:@"password"];
    NSDictionary *dic = [self operationForParam:param];

    [self.baseNetwork requestPostWithBody:dic withUrlString:@"api/user/loginAndRegister" withCompletion:block];
}
//退出登录
- (void)logoutWithUserID:(NSString*)userID withCompletion:(RequestResultBlock)block
{
    NSInteger user_ID = [userID integerValue];

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSNumber numberWithInteger:user_ID] forKey:@"user_id"];
    NSDictionary *dic = [self operationForParam:param];
    
    [self.baseNetwork requestPostWithBody:dic withUrlString:@"api/user/logout" withCompletion:block];
}

//获取热门诗词
- (void)requestHotPoetry:(NSInteger)from count:(NSInteger)count withCompletion:(RequestResultBlock)block
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInteger:from] forKey:@"from_index"];
    [dic setObject:[NSNumber numberWithInteger:count] forKey:@"count"];
    NSDictionary *param = [self operationForParam:dic];
    
    [self.baseNetwork requestPostWithBody:param withUrlString:@"api/poetry/loadHotPoetry" withCompletion:block];
}

//获取全部的收藏信息(仅仅id)
- (void)requestUserAllLikes:(NSString*)userId withCompletion:(RequestResultBlock)block
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:userId forKey:@"user_id"];
    NSDictionary *param = [self operationForParam:dic];
    
    [self.baseNetwork requestPostWithBody:param withUrlString:@"api/user/allLikesList" withCompletion:block];
}

//获取全部的收藏信息(包含内容)
- (void)requestUserAllCollections:(NSString*)userId from:(NSInteger)from count:(NSInteger)count withCompletion:(RequestResultBlock)block{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:userId forKey:@"user_id"];
    [dic setObject:[NSNumber numberWithInteger:from] forKey:@"from_index"];
    [dic setObject:[NSNumber numberWithInteger:count] forKey:@"count"];
    NSDictionary *param = [self operationForParam:dic];
    
    [self.baseNetwork requestPostWithBody:param withUrlString:@"api/user/loadCollectionList" withCompletion:block];
}


//喜欢诗词
- (void)likePoetry:(NSString*)userIdString poetryId:(NSString*)poetryIDString withCompletion:(RequestResultBlock)block
{
    NSInteger userId = [userIdString integerValue];
    NSInteger poetryID = [poetryIDString integerValue];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInteger:userId] forKey:@"user_id"];
    [dic setObject:[NSNumber numberWithInt:1] forKey:@"like"];
    [dic setObject:[NSNumber numberWithInteger:poetryID] forKey:@"poetry_id"];
    NSDictionary *param = [self operationForParam:dic];
    
    [self.baseNetwork requestPostWithBody:param withUrlString:@"api/poetry/likeOrDislikePoetry" withCompletion:block];
}
//取消喜欢诗词
- (void)dislikePoetry:(NSString*)userIdString poetryId:(NSString*)poetryIDString withCompletion:(RequestResultBlock)block
{
    NSInteger userId = [userIdString integerValue];
    NSInteger poetryID = [poetryIDString integerValue];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInteger:userId] forKey:@"user_id"];
    [dic setObject:[NSNumber numberWithInt:0] forKey:@"like"];
    [dic setObject:[NSNumber numberWithInteger:poetryID] forKey:@"poetry_id"];
    NSDictionary *param = [self operationForParam:dic];
    
    [self.baseNetwork requestPostWithBody:param withUrlString:@"api/poetry/likeOrDislikePoetry" withCompletion:block];
}

//获取全部的背景图片
- (void)requestAllBgImagesWithCompletion:(RequestResultBlock)block
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSDictionary *param = [self operationForParam:dic];
    
    [self.baseNetwork requestPostWithBody:param withUrlString:@"api/poetry/loadAllImages" withCompletion:block];
}

//获取首页的题画图片
- (void)requestHomeTopImageWithCompletion:(RequestResultBlock)block
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSDictionary *param = [self operationForParam:dic];
    [self.baseNetwork requestPostWithBody:param withUrlString:@"api/poetry/loadHomeTopImage" withCompletion:block];
}

//获取全部的诗词配置
- (void)requestPoetryConfigureWithCompletion:(RequestResultBlock)block{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSDictionary *param = [self operationForParam:dic];
    [self.baseNetwork requestPostWithBody:param withUrlString:@"api/poetry/loadPoetryConfigure" withCompletion:block];
}


//根据mainClass来获取对应的全部诗词
- (void)requestPoetryWithMainClass:(NSString*)mainClass withCompletion:(RequestResultBlock)block
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:mainClass forKey:@"main_class"];
    NSDictionary *param = [self operationForParam:dic];
    
    [self.baseNetwork requestPostWithBody:param withUrlString:@"api/poetry/loadPoetryWithMainClass" withCompletion:block];
}


//根据关键词来获取对应的全部诗词
- (void)requestPoetryWithKeyword:(NSString*)keyword withPage:(NSInteger)page withCompletion:(RequestResultBlock)block
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:keyword forKey:@"keyword"];
    [dic setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    NSDictionary *param = [self operationForParam:dic];
    
    [self.baseNetwork requestPostWithBody:param withUrlString:@"api/poetry/loadPoetryWithKeyword" withCompletion:block];
}
//新增一条挑战记录
- (void)addUserChallengeRecord:(NSString*)userId storage:(NSInteger)storage withCompletion:(RequestResultBlock)block
{
    NSInteger userIdValue = [userId integerValue];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInteger:userIdValue] forKey:@"user_id"];
    [dic setObject:[NSNumber numberWithInteger:storage] forKey:@"storage"];
    NSDictionary *param = [self operationForParam:dic];
    
    [self.baseNetwork requestPostWithBody:param withUrlString:@"api/user/insertChallengeRecord" withCompletion:block];
}

//获取近期的挑战记录，仅展示10条
- (void)requestUserChallengeInfo:(NSString*)userId withCompletion:(RequestResultBlock)block{
    NSInteger userIdValue = [userId integerValue];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInteger:userIdValue] forKey:@"user_id"];
    NSDictionary *param = [self operationForParam:dic];
    
    [self.baseNetwork requestPostWithBody:param withUrlString:@"api/user/loadUserChallenges" withCompletion:block];
}

//获取评测的诗词
- (void)requestEvaluatePoetryWithCompletion:(RequestResultBlock)block{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSDictionary *param = [self operationForParam:dic];
    [self.baseNetwork requestPostWithBody:param withUrlString:@"api/poetry/loadEvaluatePoetry" withCompletion:block];
}

//获取诗词的鉴赏信息
- (void)loadAnalysesWithPoetryId:(NSString*)poetryIDString withCompletion:(RequestResultBlock)block{
    NSInteger poetryID = [poetryIDString integerValue];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInteger:poetryID] forKey:@"poetry_id"];
    NSDictionary *param = [self operationForParam:dic];
    [self.baseNetwork requestPostWithBody:param withUrlString:@"api/poetry/loadPoetryAnalysesInfo" withCompletion:block];

}

//新增一条反馈信息
- (void)addOneFeedbackWithUserID:(NSString*)userId content:(NSString*)content contact:(NSString*)contact withCompletion:(RequestResultBlock)block
{
    NSInteger userIdValue = [userId integerValue];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInteger:userIdValue] forKey:@"user_id"];
    [dic setObject:content forKey:@"content"];
    if (!contact || contact.length == 0) {
        [dic setObject:@"" forKey:@"contact"];
    }else{
        [dic setObject:contact forKey:@"contact"];
    }
    NSDictionary *param = [self operationForParam:dic];
    
    [self.baseNetwork requestPostWithBody:param withUrlString:@"api/service/addFeedback" withCompletion:block];
}


- (NSDictionary*)operationForParam:(NSDictionary*)originDic
{
    //获取当前时间戳
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *dateNow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:dateNow];
    
    //原始参数加上一个timestamp键值对，这样就可以避免每次加密结果一样了
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:originDic];
    [dataDic setObject:currentTimeString forKey:@"timestamp"];
    
    //将原始参数以及timestamp参数转为字符串
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = @"";
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
   
    
    //使用AES加密参数
    NSString *cipherText = [AESCipher aesEncryptString:jsonString];
    NSLog(@"加密后：%@",cipherText);
    NSString *decryptText = [AESCipher aesDecryptString:cipherText];
    NSLog(@"解密后：%@",decryptText);
    
    
    
    
    
    //签名时 私钥需要是pkcs1格式，转换一下才可以使用
    NSString *privateKey = @"MIICXQIBAAKBgQCMio/FMUHRO2T1nPuJPAVrodz+CYEdkaSr4BO/KRiel95X1ekAYfb7mI2IZSq6nNETM2AOIU+4SbNuIBNYbesG+Juigf3l1hltPhIxOTkDpBia6mDS1sPMoQ7XL+6rYZWs9itLx4USVhmEyH8T9I3K/056G40fE5y6zTTL8IqH2QIDAQABAoGBAIUfovuIou2MMx+sKV9e6UuAsRI48oKNuMvNnybNyLJA7K2KxABGy2qaoEX4fjbx3+EuIuh/iUHpHftMisaSp7IswMIxEQYJDMhZIdtoOErdMEFZ0pbXiEnVcwb/ba5m6vWU6bSJglIWsPWs+MdqOysE6sA4K/8YlGtVZDb72zaZAkEA7B4P2LUpdOgHYsQ38E8Jil2QuCLdx5eDkNY23jEDuqBkfrcp7aj1bZSX09MPeBMi6Eq/h2eq9LNyEPVnV80OPwJBAJhgLrdshJ3iYzOFYSfocDv6iVvaEzQ930E97XuYVbV8Ja/HsRu9IuI40H5GRb78b+PKA9sIx4b5bvbTF0yME+cCQQCR1pOVF3hus+3z7Bxc+oR7CQWdJjPz1rq1mAo1vPJ/sBfCSKHGIEjPESuh80gnszIpZhncqYRnNfrrTJgzG/2DAkBRLIQWoQ/xECZqzvZYDUKlIS3FqeIrJX7mwbfe7ONUAGQPRaF7NoH74+pmKseDG/X7cqYlLIMmy4Cqqv+xfronAkAhdE4sG23+ViH/SsTYBgwButUnD2PU7e8wk4YIh4+Ys2ArchHgDIUM4XtwTNeFu0SCiEEkd2dzmvv9XO0KEp+I";
    //明文 用于验签的
    NSString *signOriString = [NSString stringWithFormat:@"com=wql&timestamp=%@",currentTimeString];

    //对数据进行加密
    NSString *signString = [RSAEncryptor sign:signOriString withPriKey:privateKey];
    
    
    //组装出来的最终参数，用于发送网络请求
    NSMutableDictionary *decryParam = [NSMutableDictionary dictionary];
    [decryParam setObject:signString forKey:@"signature"];
    [decryParam setObject:currentTimeString forKey:@"timestamp"];
    [decryParam setObject:cipherText forKey:@"encryptedData"];
    return decryParam;
    
    
}


@end

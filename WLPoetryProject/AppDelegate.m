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
#import <BmobSDK/Bmob.h>
#import "WLCoreDataHelper.h"
#import "PoetryModel.h"
#import "WLSaveLocalHelper.h"
#define FIRSTOPENAPP  @"FirstLoadShuangrenduobao"

@interface AppDelegate ()
/**
 *  tabbar
 **/
@property (nonatomic,strong) YLTabbarController *tabbarVC;
/**
 *  json是否读取的数组
 **/
@property (nonatomic,strong) NSMutableArray *jsonStateArr;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Bmob registerWithAppKey:@"40e18dd4c61c975bc10e42abc6293dd1"];
    
    
//    [self addNewUser];
    [self getCurrentUserState];
//    [self changePassword];
//    [self addPoetryData];
//    [self queryPoetryWithID];
//        [self queryPoetryData];
//    [self queryPoetryDataTwo];
//    [self updateNewDataToPoetry];
//    [self deleteDataInPoetry];
   

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    [self loadCustomTabbar];
    
    NSString *isFirstLoad = [[NSUserDefaults standardUserDefaults]objectForKey:FIRSTOPENAPP];
    
    if (![isFirstLoad isEqualToString:@"1"]) {
        [self loadFirstLoadView];
        
    }
    
    [self checkLocalData];//加载本地数据
    NSLog(@"在DevBranch添加");
    return YES;
}
- (void)loadFirstLoadView
{
    LeadViewController *vc = [[LeadViewController alloc]init];
    
    UIViewController *topVC = self.window.rootViewController;
    
    [topVC presentViewController:vc animated:NO completion:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:FIRSTOPENAPP];
    
}


- (void)loadCustomTabbar
{
    self.tabbarVC = [[YLTabbarController alloc]init];
    
    self.window.rootViewController = self.tabbarVC;
    
}

#pragma mark - 注册新用户
- (void)addNewUser
{
    NSLog(@"123");
    BmobUser *bUser = [[BmobUser alloc]init];
    [bUser setUsername:@"zhaozilong"];//区分大小写
    [bUser setPassword:@"zhaozilongPsd"];
    [bUser setObject:@"212" forKey:@"totalCount"];
    [bUser setObject:@"52" forKey:@"currentCount"];
    [bUser setObject:@"东方之纱" forKey:@"address"];
    [bUser setObject:@"32" forKey:@"accountValue"];
    [bUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            NSLog(@"用户成功注册");
        }else{
            NSLog(@"注册失败");
        }
    }];
}

- (void)getCurrentUserState
{
    BmobUser *bUser = [BmobUser currentUser];
    if (bUser) {
        NSLog(@"已登录");
    }else{
        NSLog(@"未登录");
        [self loginAction];
    }
    
}

- (void)loginAction
{
    NSLog(@"开始登录");
    [BmobUser loginInbackgroundWithAccount:@"wangqilong" andPassword:@"123456" block:^(BmobUser *user, NSError *error) {
        if (user) {
            NSLog(@"登录user:%@",user);
        }else{
            NSLog(@"登录error:%@",error);
        }
    }];
}
#pragma mark - 修改密码
- (void)changePassword
{
    BmobUser *user = [BmobUser currentUser];
    [user updateCurrentUserPasswordWithOldPassword:@"wangqilongPsd" newPassword:@"123456" block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //用新密码登录
            [BmobUser loginInbackgroundWithAccount:@"wangqilong" andPassword:@"123456" block:^(BmobUser *user, NSError *error) {
                if (error) {
                    NSLog(@"login error:%@",error);
                } else {
                    NSLog(@"user:%@",user);
                }
            }];
        } else {
            NSLog(@"change password error:%@",error);
        }
    }];
}

#pragma mark - 添加一条诗词数据
- (void)addPoetryData
{
    BmobObject *poetryList = [BmobObject objectWithClassName:@"PoetryList"];
    [poetryList setObject:@"长相思" forKey:@"name"];
    [poetryList setObject:@"纳兰性德" forKey:@"author"];
    [poetryList setObject:@"0420151948" forKey:@"poetryID"];
    [poetryList setObject:@"山一程，水一程，身向榆关那畔行。" forKey:@"content"];
    [poetryList saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"成功");
        }else{
            NSLog(@"失败");
        }
    }];
}

#pragma mark - 使用ID查询
- (void)queryPoetryWithID
{
    BmobQuery *query = [BmobQuery queryWithClassName:@"PoetryList"];
    
    [query getObjectInBackgroundWithId:@"d94e789c9e" block:^(BmobObject *object, NSError *error) {
        
        if (object) {
            NSString *author = [object objectForKey:@"author"];
            NSLog(@"author:%@",author);
            
        }
    }];
}
#pragma mark - 根据某个表中的字段值查询
- (void)queryPoetryData
{
    BmobQuery *query = [BmobQuery queryWithClassName:@"PoetryList"];
    [query whereKey:@"poetryID" equalTo:@"0420151229"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        NSLog(@"array:%@",array);
        
    }];
}

#pragma mark - 根据某个表中，符合若干个字段的值来查询
- (void)queryPoetryDataTwo
{
    BmobQuery *bmobQuery = [BmobQuery queryWithClassName:@"PoetryList"];
    NSArray *array =  @[@{@"name":@"长相思"},@{@"author":@"王啟龙"}];
    [bmobQuery addTheConstraintByOrOperationWithArray:array];
    
    [bmobQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            BmobObject *obc = [array firstObject];
            NSString *author = [obc objectForKey:@"author"];
            NSLog(@"author:%@",author);
        }
    }];
    
    
}

#pragma mark - 更新某条数据
- (void)updateNewDataToPoetry
{
    BmobQuery *query = [BmobQuery queryWithClassName:@"PoetryList"];
    [query whereKey:@"poetryID" equalTo:@"0420151229"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            BmobObject *obc = [array firstObject];
            NSString *author = [obc objectForKey:@"author"];
            NSLog(@"author:%@",author);
            
            BmobObject *objcNew = [BmobObject objectWithoutDataWithClassName:obc.className objectId:obc.objectId];
            [objcNew setObject:@"王啟龙" forKey:@"author"];
            [objcNew updateInBackground];
        }
    }];
}

#pragma mark - 删除某条数据
- (void)deleteDataInPoetry
{
    
    
    BmobQuery *queryTwo = [BmobQuery queryWithClassName:@"PoetryList"];
    [queryTwo whereKey:@"poetryID" equalTo:@"0420144558"];
    [queryTwo findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        NSLog(@"array:%@",array);
        if (array.count > 0) {
            BmobObject *obj = [array firstObject];
            [obj deleteInBackground];
        }
    }];
}


- (void)checkLocalData
{
    NSMutableArray *jsonList = [NSMutableArray array];
    [jsonList addObject:@"gradePoetry_1"];
    [jsonList addObject:@"gradePoetry_2"];
    [jsonList addObject:@"gradePoetry_3"];
    [jsonList addObject:@"gradePoetry_4"];
    [jsonList addObject:@"gradePoetry_5"];
    [jsonList addObject:@"gradePoetry_6"];
    [jsonList addObject:@"gradePoetry_7_one"];
    [jsonList addObject:@"gradePoetry_7_two"];
    [jsonList addObject:@"gradePoetry_8_one"];
    [jsonList addObject:@"gradePoetry_8_two"];
    [jsonList addObject:@"gradePoetry_9_one"];
    [jsonList addObject:@"gradePoetry_9_two"];
    [jsonList addObject:@"tangPoetry_one"];
    [jsonList addObject:@"tangPoetry_two"];
    [jsonList addObject:@"tangPoetry_three"];
    [jsonList addObject:@"tangPoetry_four"];
    [jsonList addObject:@"tangPoetry_five"];
    [jsonList addObject:@"tangPoetry_six"];
    [jsonList addObject:@"tangPoetry_seven"];
    [jsonList addObject:@"songPoetry_one"];
    [jsonList addObject:@"songPoetry_two"];
    [jsonList addObject:@"songPoetry_three"];
    [jsonList addObject:@"songPoetry_four"];
    [jsonList addObject:@"songPoetry_five"];
    [jsonList addObject:@"songPoetry_six"];
    [jsonList addObject:@"songPoetry_seven"];
    [jsonList addObject:@"songPoetry_eight"];
    [jsonList addObject:@"songPoetry_nine"];
    [jsonList addObject:@"songPoetry_ten"];

    NSArray *jsonStateArray = [WLSaveLocalHelper loadObjectForKey:@"PoetryJsonState"];
    self.jsonStateArr = [NSMutableArray array];
    
    if (jsonStateArray && [jsonStateArray isKindOfClass:[NSArray class]] && jsonStateArray.count == jsonList.count ) {
        
        self.jsonStateArr = [jsonStateArray mutableCopy];
        
        for (int i = 0; i < jsonStateArray.count ;i++) {
            NSString *state = jsonStateArray[i];
            int time = 4*i;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                if (![state isEqualToString:@"1"]) {
                    [self readLocalFileWithName:jsonList[i] withIndex:i];
                }
                
            });
            
        }
        
    }else{
        
        for (int i =0 ; i < jsonList.count; i++) {
            [self.jsonStateArr addObject:@"0"];
            
        }
        
        for (int i = 0; i < self.jsonStateArr.count ;i++) {
            NSString *state = self.jsonStateArr[i];
            int time = 4*i;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                if (![state isEqualToString:@"1"]) {
                    [self readLocalFileWithName:jsonList[i] withIndex:i];
                }
                
            });
            
        }

        
        
    }
}

- (void)readLocalFileWithName:(NSString*)fileName withIndex:(NSInteger)jsonIndex
{
    //从本地读取文件
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"]];
    //转为dic
    NSDictionary *poetryDic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];

    //获取到诗词列表
    NSArray *poetryArr = [poetryDic objectForKey:@"poetryList"];
    NSString *poetryMainClass = [poetryDic objectForKey:@"mainClass"];
    
    NSMutableArray *modelArray = [NSMutableArray array];
    //将诗词model化
    for (int i = 0; i<poetryArr.count; i++) {
        NSDictionary *itemDic = [poetryArr objectAtIndex:i];
        PoetryModel *model = [[PoetryModel alloc]initModelWithDictionary:itemDic];
        model.mainClass = poetryMainClass;
        [modelArray addObject:model];
    }
    
    //存储到本地数据库
    [[WLCoreDataHelper shareHelper]saveInBackgroundWithPeotryModelArray:modelArray withResult:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //存储成功后更新状态
            [self.jsonStateArr replaceObjectAtIndex:jsonIndex withObject:@"1"];
            [WLSaveLocalHelper saveObject:[self.jsonStateArr copy] forKey:@"PoetryJsonState"];
            
        }
    }];

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
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "YiXin.TestCoreDataRelation" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WLPoetryProject" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WLPoetryProject.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end


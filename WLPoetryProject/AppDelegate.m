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
#import "LaunchController.h"

#define FIRSTOPENAPP  @"FirstLoadShuangrenduobao"

@interface AppDelegate ()
/**
 *  tabbar
 **/
@property (nonatomic,strong) YLTabbarController *tabbarVC;


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
    
//    NSString *isFirstLoad = [[NSUserDefaults standardUserDefaults]objectForKey:FIRSTOPENAPP];
//
//    if (![isFirstLoad isEqualToString:@"1"]) {
//        [self loadFirstLoadView];
//
//    }
    
    [self loadLaunchImage];
    
    [self loadLikePoetryList];
    NSLog(@"在DevBranch添加");
    return YES;
}

- (void)loadLikePoetryList
{
//    id name = kUserName;
//    id password = kUserPassword;
//    if (!name) {
//        name = @"";
//    }
//    if (!password) {
//        password = @"";
//    }
//    NSString *lastUserName = [NSString stringWithFormat:@"%@",name];
//    NSString *lastUserPsd = [NSString stringWithFormat:@"%@",password];
    
    BmobUser *user = [BmobUser currentUser];
    if (user) {
        NSLog(@"user:%@",user);
        
        NSString *userBmobId = user.objectId;
        NSMutableArray *array = [NSMutableArray arrayWithArray:[user objectForKey:@"likePoetryIDList"]];
        
        
    }
    
}

- (void)loadLaunchImage
{
    LaunchController *vc = [[LaunchController alloc]init];
    
    UIViewController *topVC = self.window.rootViewController;
    
    [topVC presentViewController:vc animated:NO completion:nil];
    
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
    
    //更新number为30
    [bUser setObject:@30 forKey:@"number"];
    [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        NSLog(@"error %@",[error description]);
    }];
    
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


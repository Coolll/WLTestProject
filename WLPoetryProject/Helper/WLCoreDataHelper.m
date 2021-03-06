//
//  WLCoreDataHelper.m
//  WLPoetryProject
//
//  Created by 龙培 on 2018/4/17.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import "WLCoreDataHelper.h"
@interface WLCoreDataHelper()
//方法1中的子线程context
@property (nonatomic,strong) NSManagedObjectContext *privateContext;
//方法1中的主线程context
//@property (nonatomic,strong) NSManagedObjectContext *mainContext;
//方法1中的后台context
//@property (nonatomic,strong) NSManagedObjectContext *backgroundContext;
//数据库协调器
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//数据库模型
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

//方法2中的子线程context
//@property (nonatomic,strong) NSManagedObjectContext *privateSecondContext;
////方法2中的主线程context
//@property (nonatomic,strong) NSManagedObjectContext *mainSecondContext;
@end


@implementation WLCoreDataHelper

//单例初始化
+ (instancetype)shareHelper
{
    static WLCoreDataHelper *helper = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[WLCoreDataHelper alloc]init];
    });
    
    return helper;
}

- (AppDelegate*)appDelegate
{
    if (!_appDelegate) {
        _appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    }
    return _appDelegate;
}
#pragma mark - 增

- (void)saveInBackgroundWithPeotryModelArray:(NSArray*)array withResult:(CoreDataResultBlock)block
{
    dispatch_async(dispatch_get_main_queue(), ^{
    
        //子线程中的context，父context是mainContext
        //主线程中的context，父context是backgroundContext
        //后台context，该context做数据的增删改查
        
        
        for (int i =0 ; i < array.count; i++) {
        
//            CGFloat time = 0.05*i;
            PoetryModel *model = array[i];
            
            Poetry *poetry = [NSEntityDescription insertNewObjectForEntityForName:@"Poetry" inManagedObjectContext:self.privateContext]
            ;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                [self savePoetry:poetry withPoetryModel:model withResult:block];

//            });
        
        }
        
        
    });
    
}

//- (void)savePoetryWithTotal:(NSInteger)total withCurrent:(NSInteger)current withArray:(NSArray*)array withResult:(CoreDataResultBlock)block
//{
//    if (current < array.count) {
//         withInnerBlock:^(BOOL isSuccessful) {
//
//            if (isSuccessful) {
//                [self savePoetryWithTotal:total withCurrent:current+1 withArray:array withResult:block];
//            }
//        }];
//    }
//
//
//}

- (void)savePoetry:(Poetry*)poetry withPoetryModel:(PoetryModel*)model withResult:(CoreDataResultBlock)block
{
    poetry.name = model.name;
    poetry.author = model.author;
    poetry.content = model.content;
    poetry.backImageName = model.backImageName;
    poetry.isLike = model.isLike;
    poetry.isRecited = model.isRecited;
    poetry.isShowed = model.isShowed;
    poetry.source = model.source;
    poetry.poetryID = model.poetryID;
    poetry.addtionInfo = model.addtionInfo;
    poetry.classInfo = model.classInfo;
    poetry.transferInfo = model.transferInfo;
    poetry.analysesInfo = model.analysesInfo;
    poetry.backgroundInfo = model.backgroundInfo;
    poetry.firstLineString = model.firstLineString;
    poetry.mainClass = model.mainClass;
    
    __block  NSError *error = nil;
    
    //子线程context执行并等待
    [self.privateContext performBlockAndWait:^{
        if (![self.privateContext save:&error]) {
            NSLog(@"privateContext 错误:%@",error);
            if (block) {
                block(NO,error);
            }
            
            
        }else{
            NSLog(@"成功");
            if (block) {
                block(YES,nil);
            }
            
        }
        
        //主线程context执行
//        [self.mainContext performBlock:^{
//            if (![self.mainContext save:&error]) {
//                NSLog(@"mainContext 错误:%@",error);
//                if (block) {
//                    block(NO,error);
//                }
//
//            }
//
//            //后台context执行
//            [self.backgroundContext performBlock:^{
//                if (![self.backgroundContext save:&error]) {
//                    NSLog(@"backgroundContext 错误:%@",error);
//                    if (block) {
//                        block(NO,error);
//                    }
//
//                }else{
//                    NSLog(@"成功");
//                    if (block) {
//                        block(YES,nil);
//                    }
//
//                }
//            }];
//
//
//
//        }];
//
        
    }];
}
#pragma mark - 改

//根据ID 更改诗词的信息
//- (void)updatePoetryWithID:(NSString*)poetryID withNewPoetry:(PoetryModel*)newPoetry withResult:(CoreDataResultBlock)block
//{
//    PoetryModel *poetry = [self fetchPoetryWithID:poetryID];
//
//    [self savePoetry:poetry withPoetryModel:newPoetry withResult:block];
//
//}
#pragma mark - 删
//删除全部诗词
- (void)deleteAllPoetry
{
    NSArray *poetryList = [self fetchAllPoetry];
    
    for (Poetry *poetry in poetryList) {
        [self deletePoetryWithID:poetry.poetryID withResult:nil];
    }
}

//根据ID 删除诗词的信息
- (void)deletePoetryWithID:(NSString*)poetryID withResult:(CoreDataResultBlock)block
{
    Poetry *poetry = [self fetchPoetryEntityWithID:poetryID];

    [self.appDelegate.managedObjectContext deleteObject:poetry];
    
    NSError *deleteError;
    
    BOOL isDeleteSuccess = [self.appDelegate.managedObjectContext save:&deleteError];
    if (isDeleteSuccess) {
        NSLog(@"Delete Success");
        if (block) {
            block(YES,nil);
        }
    }else{
        if (block) {
            block(NO,deleteError);
        }
        NSLog(@"Delete failed!%@",deleteError);
    }
    
}

#pragma mark - 查

//查询全部的诗词信息
-(NSArray*)fetchAllPoetry
{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSArray *fetchArray = [self fetchDataWithTableName:@"Poetry" withRequest:request withPredicate:nil];
    
    return fetchArray;
}
//查询某个大类的诗词，比如小学一年级的诗词，传1即可
-(NSArray*)fetchPoetryWithMainClass:(NSString*)mainClass
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mainClass == %@",mainClass];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];

    NSArray *fetchArray = [self fetchDataWithTableName:@"Poetry" withRequest:request withPredicate:predicate];
    
    return fetchArray;
}
//根据来源查询诗词的信息
- (Poetry*)fetchPoetryWithSource:(NSString*)source
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"source == %@",source];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];

    NSArray *fetchArray = [self fetchDataWithTableName:@"Poetry" withRequest:request withPredicate:predicate];
    
    Poetry *poetryEntity = nil;
    
    if (fetchArray.count > 0) {
        poetryEntity = [fetchArray firstObject];
    }
    
    return poetryEntity;
    
}
//根据ID查询诗词的信息
- (PoetryModel*)fetchPoetryModelWithID:(NSString*)idString
{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"poetryID == %@",idString];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];

    NSArray *fetchArray = [self fetchDataWithTableName:@"Poetry" withRequest:request withPredicate:predicate];
    
    Poetry *poetryEntity = nil;
    
    if (fetchArray.count > 0) {
        poetryEntity = [fetchArray firstObject];
    }
    
    PoetryModel *model = [[PoetryModel alloc]init];
    model.name = poetryEntity.name;
    model.author = poetryEntity.author;
    model.content = poetryEntity.content;
    model.backImageName = poetryEntity.backImageName;
    model.isLike = poetryEntity.isLike;
    model.isRecited = poetryEntity.isRecited;
    model.isShowed = poetryEntity.isShowed;
    model.source = poetryEntity.source;
    model.poetryID = poetryEntity.poetryID;
    model.addtionInfo = poetryEntity.addtionInfo;
    model.classInfo = poetryEntity.classInfo;
    model.transferInfo = poetryEntity.transferInfo;
    model.analysesInfo = poetryEntity.analysesInfo;
    model.backgroundInfo = poetryEntity.backgroundInfo;
    model.firstLineString = poetryEntity.firstLineString;
    model.mainClass = poetryEntity.mainClass;
    return model;
}

//根据ID查询诗词的信息
- (Poetry*)fetchPoetryEntityWithID:(NSString*)idString
{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"poetryID == %@",idString];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSArray *fetchArray = [self fetchDataWithTableName:@"Poetry" withRequest:request withPredicate:predicate];
    
    Poetry *poetryEntity = nil;
    
    if (fetchArray.count > 0) {
        poetryEntity = [fetchArray firstObject];
    }
    
    return poetryEntity;
}

#pragma mark - 查询表中的数据
- (NSArray *)fetchDataWithTableName:(NSString*)tableName withRequest:(NSFetchRequest*)request withPredicate:(NSPredicate*)predicate
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:self.appDelegate.managedObjectContext];

    [request setEntity:entity];
    
    if (predicate) {
        [request setPredicate:predicate];
    }
    
    NSError *error;
    
    NSArray *fetchArray = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    
    return fetchArray;
}
#pragma mark - 查询表中的数据
- (NSArray*)searchPoetryListWithKeyWord:(NSString*)keyWord
{
    NSString *word = [NSString stringWithFormat:@"*%@*",keyWord];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"author like %@ || content like %@ || name like %@",word,word,word];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setFetchLimit:10];
    NSArray *fetchArray = [self fetchDataWithTableName:@"Poetry" withRequest:request withPredicate:predicate];
    
    return fetchArray;
}




#pragma mark - property
//子线程的context的父context是主线程context
- (NSManagedObjectContext*)privateContext
{
    if (!_privateContext) {
        _privateContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _privateContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
        
    }
    return _privateContext;
}

////主线程的context的父context是后台context
//- (NSManagedObjectContext*)mainContext
//{
//    if (!_mainContext) {
//        _mainContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
//        _mainContext.parentContext = self.backgroundContext;
//    }
//
//    return _mainContext;
//}
//
////设置后台context的数据库存储协调器
//- (NSManagedObjectContext*)backgroundContext
//{
//    if (!_backgroundContext) {
//        _backgroundContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
//        _backgroundContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
//    }
//
//    return _backgroundContext;
//}

//初始化数据存储协调器
- (NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSString *sqliteName = @"WLPoetryProject.sqlite";
    
    NSURL *documentDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSURL *storeFileURL = [documentDirectory URLByAppendingPathComponent:sqliteName];
    
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.managedObjectModel];
    
    
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeFileURL options:nil error:&error]) {
        NSLog(@"persistentStoreCoordinator addPersistent failed!Error:%@",error);
    }
    
    return _persistentStoreCoordinator;
    
}

//存储对象模型
- (NSManagedObjectModel*)managedObjectModel
{
    if (!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WLPoetryProject" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}




@end

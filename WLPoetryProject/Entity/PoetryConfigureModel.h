//
//  PoetryConfigureModel.h
//  WLPoetryProject
//
//  Created by 变啦 on 2019/11/15.
//  Copyright © 2019 龙培. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PoetryConfigureModel : NSObject

@property (nonatomic, assign) NSInteger configureTag;
@property (nonatomic, assign) NSInteger tableSection;
@property (nonatomic, assign) NSInteger tableIndex;

@property (nullable, nonatomic, copy) NSString *mainClass;
@property (nullable, nonatomic, copy) NSString *mainTitle;
@property (nullable, nonatomic, copy) NSString *subTitle;
@property (nullable, nonatomic, copy) NSString *sectionTitle;

- (instancetype)initModelWithDictionary:(NSDictionary*)dic;

@end

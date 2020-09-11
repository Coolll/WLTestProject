//
//  WLPoetryProjectTests.m
//  WLPoetryProjectTests
//
//  Created by 龙培 on 2018/4/2.
//  Copyright © 2018年 龙培. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NetworkHelper.h"
@interface WLPoetryProjectTests : XCTestCase

@end

@implementation WLPoetryProjectTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testLogin{
    NSString *userName = @"刘备";
    NSString *password = @"12345678";
    XCTestExpectation *expectation = [self expectationWithDescription:@"登录接口测试"];
    [[NetworkHelper shareHelper] loginWithUserName:userName password:password withCompletion:^(BOOL success, NSDictionary *dic, NSError *error) {
        [expectation fulfill];
        XCTAssertTrue(success,"未能 成功请求");
        XCTAssertNotNil(dic,"请求内容为空");
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        NSLog(@"请求失败了");
    }];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

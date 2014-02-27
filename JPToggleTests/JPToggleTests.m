//
//  JPToggleTests.m
//  JPToggleTests
//
//  Created by John McGlone on 1/28/14.
//  Copyright (c) 2014 JP McGlone. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JPToggleManager.h"

@interface JPToggleTests : XCTestCase

@end

@implementation JPToggleTests {
    BOOL _notificationResult;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test:(NSNotification *)notification {
    _notificationResult = [notification.object boolValue];
}

- (void)testToggles {
    JPToggleManager *toggleManager = [JPToggleManager sharedManager];

    [toggleManager addContexts:@[@"DEBUG", @"ADHOC", @"DEMO", @"SPECIAL"]];

    // Test Notification Center
    [toggleManager.notificationCenter addObserver:self selector:@selector(test:) name:@"Feature1" object:nil];
    XCTAssertFalse(_notificationResult, @"Should have been false since we didn't set DEBUG context");
    [toggleManager setToggle:YES forFeature:@"Feature1" inContext:@"DEBUG"];
    XCTAssertTrue(_notificationResult, @"Should have been true since we set Feature1 on in DEBUG");

    [toggleManager setToggle:YES forFeature:@"Feature2" inContext:@"NANCONTEXT"];
    [toggleManager setToggle:YES forFeature:@"Feature3" inContext:@"ADHOC"];
    [toggleManager setToggle:NO forFeature:@"Feature4" inContext:@"ADHOC"];
    
    XCTAssertTrue([toggleManager toggleForFeature:@"Feature1"]);
    XCTAssertFalse([toggleManager toggleForFeature:@"Feature2"]);
    XCTAssertTrue([toggleManager toggleForFeature:@"Feature3"]);
    XCTAssertFalse([toggleManager toggleForFeature:@"Feature4"]);
    XCTAssertFalse([toggleManager toggleForFeature:@"FEATURENOEXIST"]);

    [toggleManager removeContexts:@[@"DEBUG", @"ADHOC"]];
    // These should now be false because I am no longer in the DEBUG or ADHOC context
    XCTAssertFalse([toggleManager toggleForFeature:@"Feature1"]);
    XCTAssertFalse([toggleManager toggleForFeature:@"Feature3"]);
    XCTAssertFalse(_notificationResult);

    _notificationResult = NO;
    [toggleManager addContext:@"DEBUG"];
    XCTAssertTrue(_notificationResult);

    [toggleManager addContext:@"FEATURENOEXIST"];
    
    XCTAssertTrue([toggleManager.contexts containsObject:@"FEATURENOEXIST"]);
    XCTAssertFalse([toggleManager toggleForFeature:@"FEATURENOEXIST"]);
    
    [toggleManager setToggle:YES forFeature:@"Feature5" inContext:@"FEATURENOEXIST"];
    
    XCTAssertFalse([toggleManager toggleForFeature:@"FEATURENOEXIST"]);
}

@end
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

@implementation JPToggleTests

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

- (void)testToggles {
    JPToggleManager *toggleManager = [JPToggleManager sharedManager];

    [toggleManager addContexts:@[@"DEBUG", @"ADHOC", @"DEMO", @"SPECIAL"]];

    [toggleManager setToggle:YES forFeature:@"Feature1" inContext:@"DEBUG"];
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

    [toggleManager addContext:@"FEATURENOEXIST"];
    
    XCTAssertTrue([toggleManager.contexts containsObject:@"FEATURENOEXIST"]);
    XCTAssertFalse([toggleManager toggleForFeature:@"FEATURENOEXIST"]);
    
    [toggleManager setToggle:YES forFeature:@"Feature5" inContext:@"FEATURENOEXIST"];
    
    XCTAssertFalse([toggleManager toggleForFeature:@"FEATURENOEXIST"]);
}

@end
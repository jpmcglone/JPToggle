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
    [JPToggleManager sharedManager].contexts = [@[@"DEBUG", @"ADHOC", @"DEMO", @"SPECIAL"] mutableCopy];
    
    [[JPToggleManager sharedManager] setToggle:YES forFeature:@"Feature1" inContext:@"DEBUG"];
    [[JPToggleManager sharedManager] setToggle:YES forFeature:@"Feature2" inContext:@"NANCONTEXT"];
    [[JPToggleManager sharedManager] setToggle:YES forFeature:@"Feature3" inContext:@"ADHOC"];
    [[JPToggleManager sharedManager] setToggle:NO forFeature:@"Feature4" inContext:@"ADHOC"];
    
    XCTAssertTrue([[JPToggleManager sharedManager] toggleForFeature:@"Feature1"]);
    XCTAssertFalse([[JPToggleManager sharedManager] toggleForFeature:@"Feature2"]);
    XCTAssertTrue([[JPToggleManager sharedManager] toggleForFeature:@"Feature3"]);
    XCTAssertFalse([[JPToggleManager sharedManager] toggleForFeature:@"Feature4"]);
    XCTAssertFalse([[JPToggleManager sharedManager] toggleForFeature:@"FEATURENOEXIST"]);
    
    [[JPToggleManager sharedManager] addContext:@"FEATURENOEXIST"];
    
    XCTAssertTrue([[JPToggleManager sharedManager].contexts containsObject:@"FEATURENOEXIST"]);
    XCTAssertFalse([[JPToggleManager sharedManager] toggleForFeature:@"FEATURENOEXIST"]);
    
    [[JPToggleManager sharedManager] setToggle:YES forFeature:@"Feature5" inContext:@"FEATURENOEXIST"];
    
    XCTAssertFalse([[JPToggleManager sharedManager] toggleForFeature:@"FEATURENOEXIST"]);
}

@end
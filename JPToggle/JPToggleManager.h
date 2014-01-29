//
// Created by JP McGlone on 1/18/14.
// Copyright (c) 2014 JP McGlone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPToggleManager : NSObject
@property (nonatomic, strong) NSMutableArray *contexts;

+ (JPToggleManager *)sharedManager;

- (void)addContext:(NSString *)context;
- (void)removeContext:(NSString *)context;
- (BOOL)toggleForFeature:(NSString *)feature;
- (void)setToggle:(BOOL)toggle forFeature:(NSString *)feature inContext:(NSString *)context;
- (void)setToggle:(BOOL)toggle forFeature:(NSString *)feature inContexts:(NSArray *)contexts;

@end
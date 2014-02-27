//
// Created by JP McGlone on 1/18/14.
// Copyright (c) 2014 JP McGlone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPToggleManager : NSObject
@property (nonatomic, readonly) NSMutableArray *contexts;

+ (JPToggleManager *)sharedManager;

- (void)addContext:(NSString *)context;
- (void)addContexts:(NSArray *)contexts;

- (void)removeContext:(NSString *)context;
- (void)removeContexts:(NSArray *)contexts;

- (BOOL)toggleForFeature:(NSString *)feature;
- (void)setToggle:(BOOL)toggle forFeature:(NSString *)feature inContext:(NSString *)context;
- (void)setToggle:(BOOL)toggle forFeature:(NSString *)feature inContexts:(NSArray *)contexts;

@end
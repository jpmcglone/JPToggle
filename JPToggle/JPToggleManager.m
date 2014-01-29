//
// Created by JP McGlone on 1/18/14.
// Copyright (c) 2014 JP McGlone. All rights reserved.
//

#import "JPToggleManager.h"

@implementation JPToggleManager {
    NSMutableDictionary *_info;
}

+ (JPToggleManager *)sharedManager {
    static dispatch_once_t once;
    static JPToggleManager *sharedManager;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)setContexts:(NSMutableArray *)contexts {
    _info = [NSMutableDictionary new];
    _contexts = contexts;
    [_contexts enumerateObjectsUsingBlock:^(NSString *context, NSUInteger idx, BOOL *stop) {
        [_info setObject:[NSMutableDictionary new] forKey:context];
    }];
}

- (void)addContext:(NSString *)context {
    [_contexts addObject:context];
    if (_info == nil) _info = [NSMutableDictionary new];
    if (!_info[context]) [_info setValue:[NSMutableDictionary new] forKey:context];
    else NSLog(@"Context %@ already exists, ignoring add.", context);
}

- (void)removeContext:(NSString *)context {
    if (_info[context]) [_info removeObjectForKey:context];
    else NSLog(@"Context %@ doesn't exist, ignoring remove.", context);
}

- (BOOL)toggleForFeature:(NSString *)feature {
    __block BOOL toggle = NO;
    __block BOOL found = NO;
    [_contexts enumerateObjectsUsingBlock:^(NSString *context, NSUInteger idx, BOOL *stop) {
        if (_info[context][feature]) {
            toggle = [_info[context][feature] boolValue];
            found = YES;
            *stop = YES;
        }
    }];
    if (!found) {
        NSLog(@"Didn't find feature %@ in any context.", feature);
    }
    return toggle;
}

- (void)setToggle:(BOOL)toggle forFeature:(NSString *)feature inContext:(NSString *)context {
    [[_info objectForKey:context] setObject:@(toggle) forKey:feature];
}

- (void)setToggle:(BOOL)toggle forFeature:(NSString *)feature inContexts:(NSArray *)contexts {
    [contexts enumerateObjectsUsingBlock:^(NSString *context, NSUInteger idx, BOOL *stop) {
        [self setToggle:toggle forFeature:feature inContext:context];
    }];
}

@end
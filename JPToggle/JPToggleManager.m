//
// Created by JP McGlone on 1/18/14.
// Copyright (c) 2014 JP McGlone. All rights reserved.
//

#import "JPToggleManager.h"

@implementation JPToggleManager {
    NSMutableArray *_contexts;
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

- (id)init {
    self = [super init];
    if (self) {
        _contexts = [NSMutableArray new];
        _info = [NSMutableDictionary new];
        _notificationCenter = [NSNotificationCenter new];
    }
    return self;
}

- (void)addContext:(NSString *)context {
    if (![_contexts containsObject:context]) {
        [_contexts addObject:context];
        if (!_info[context]) {
            _info[context] = [NSMutableDictionary new];
        }
        [[_info[context] allKeys] enumerateObjectsUsingBlock:^(NSString *feature, NSUInteger idx, BOOL *stop) {
            [self postNotificationForFeature:feature inContext:context];
        }];
    } else {
        NSLog(@"Context %@ already exists, ignoring add.", context);
    }
}

- (void)addContexts:(NSArray *)contexts {
    [contexts enumerateObjectsUsingBlock:^(NSString *context, NSUInteger idx, BOOL *stop) {
        [self addContext:context];
    }];
}

- (void)removeContext:(NSString *)context {
    if ([_contexts containsObject:context]) {
        [_contexts removeObject:context];
        [[_info[context] allKeys] enumerateObjectsUsingBlock:^(NSString *feature, NSUInteger idx, BOOL *stop) {
            [self postNotificationForFeature:feature inContext:context];
        }];
    } else {
       NSLog(@"Context %@ doesn't exist, ignoring remove.", context);
    }
}

- (void)removeContexts:(NSArray *)contexts {
    [contexts enumerateObjectsUsingBlock:^(NSString *context, NSUInteger idx, BOOL *stop) {
        [self removeContext:context];
    }];
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
    return toggle;
}

- (void)setToggle:(BOOL)toggle forFeature:(NSString *)feature inContext:(NSString *)context {
    // Wrap the primitive for use with notification center and dictionary
    NSNumber *toggleObject = @(toggle);
    if (!_info[context]) {
        _info[context] = [NSMutableDictionary new];
    }
    _info[context][feature] = toggleObject;
    [self postNotificationForFeature:feature inContext:context];
}

- (void)setToggle:(BOOL)toggle forFeature:(NSString *)feature inContexts:(NSArray *)contexts {
    [contexts enumerateObjectsUsingBlock:^(NSString *context, NSUInteger idx, BOOL *stop) {
        [self setToggle:toggle forFeature:feature inContext:context];
    }];
}

- (void)postNotificationForFeature:(NSString *)feature inContext:(NSString *)context{
    BOOL toggle = [_info[context][feature] boolValue] && [_contexts containsObject:context];
    [_notificationCenter postNotificationName:feature object:@(toggle)];
}

@end
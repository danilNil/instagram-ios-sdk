//
// Created by Danil on 24.04.14.
// Copyright (c) 2014 Danil. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperationManager;
@class UserFeed;


@interface UserFeedAPI : NSObject
@property (nonatomic, strong) Injected NSString* token;
@property (nonatomic, strong) Injected AFHTTPRequestOperationManager* client;

- (void)getMyFeedWithBlock:(void (^)(UserFeed *userFeed, NSError *error))block;

@end
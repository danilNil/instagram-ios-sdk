//
// Created by Danil on 24.04.14.
// Copyright (c) 2014 Danil. All rights reserved.
//

#import "UserFeedAPI.h"
#import "AFHTTPRequestOperationManager.h"
#import "UserFeed.h"


@implementation UserFeedAPI

- (void)getMyFeedWithBlock:(void (^)(UserFeed *userFeed, NSError *error))block {
    [self.client GET:[self path] parameters:[self parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        UserFeed* user = [self objectFromJson:responseObject];
        block(user, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}


- (UserFeed *)objectFromJson:(id)object {
    NSDictionary* dict = object;
    NSDictionary* userDict = [dict objectForKey:@"data"];
    UserFeed* user = [UserFeed new];
    return user;
}

- (id)parameters {
    return @{@"access_token" : self.token};
}

- (NSString *)path{
    return @"users/self/feed";
}
@end
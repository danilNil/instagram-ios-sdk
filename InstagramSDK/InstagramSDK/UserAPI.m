//
//  UserAPI.m
//  InstagramSDK
//
//  Created by Danil on 23/04/14.
//  Copyright (c) 2014 Danil. All rights reserved.
//

#import "UserAPI.h"
#import "User.h"
#import "AFHTTPRequestOperationManager.h"
#import "UserFeedAPI.h"

@implementation UserAPI

- (void)getById:(NSString *)userId withBlock:(void (^)(User * user, NSError *error))block {
    [self.client GET:[self pathWithId:userId] parameters:[self parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        User* user = [self objectFromJson:responseObject];
        block(user, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

- (User *)objectFromJson:(id)object {
    NSDictionary* dict = object;
    NSDictionary* userDict = [dict objectForKey:@"data"];
    User* user = [User new];
    user.name = [userDict objectForKey:@"username"];
    user.uid = [userDict objectForKey:@"id"];
    return user;
}

- (id)parameters {
    return @{@"access_token" : self.token};
}

- (NSString *)pathWithId:(NSString*)userId {
    return [NSString stringWithFormat:@"users/%@", userId];
}

@end

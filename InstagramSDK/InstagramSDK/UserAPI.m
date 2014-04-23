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

@implementation UserAPI

- (void)getById:(NSString *)string withBlock:(void (^)(User * user, NSError *error))block {
    [self.client GET:[self path] parameters:[self parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        User* user = [self objectFromJson:responseObject];
        block(user, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

- (User *)objectFromJson:(id)object {
    return nil;
}

- (id)parameters {
    return nil;
}

- (NSString *)path {
    return nil;
}
@end

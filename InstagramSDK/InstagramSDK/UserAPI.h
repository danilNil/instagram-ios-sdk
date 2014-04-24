//
//  UserAPI.h
//  InstagramSDK
//
//  Created by Danil on 23/04/14.
//  Copyright (c) 2014 Danil. All rights reserved.
//

@class User;
@class AFHTTPRequestOperationManager;

@interface UserAPI : NSObject
@property (nonatomic, strong) Injected NSString* token;
@property (nonatomic, strong) Injected AFHTTPRequestOperationManager* client;
- (void)getById:(NSString *)string withBlock:(void (^)(User * user, NSError *error))block;

@end

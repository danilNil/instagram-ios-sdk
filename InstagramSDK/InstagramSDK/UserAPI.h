//
//  UserAPI.h
//  InstagramSDK
//
//  Created by Danil on 23/04/14.
//  Copyright (c) 2014 Danil. All rights reserved.
//

@class User;

@interface UserAPI : NSObject

- (void)getById:(NSString *)string withBlock:(void (^)(User *))block;

@end

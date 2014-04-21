//
//  InstagramSDK.m
//  InstagramSDK
//
//  Created by Danil on 20.04.14.
//  Copyright (c) 2014 Danil. All rights reserved.
//

#import "InstagramSDK.h"

@implementation InstagramSDK

- (void)receiveUrlWithToken:(NSString *)url {
    _token = [self tokenFromUrl: url];
}

- (NSString *)tokenFromUrl:(NSString *)url {
    return @"token123";
}

- (void)login {
    NSString *fakeURL  = @"fake url with token";
    [self performSelector:@selector(receiveUrlWithToken:) withObject:fakeURL afterDelay:1.0];
}

@end

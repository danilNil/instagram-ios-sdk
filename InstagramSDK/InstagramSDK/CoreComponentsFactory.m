//
//  CoreComponentsFactory.m
//  InstagramSDK
//
//  Created by Danil on 24.04.14.
//  Copyright (c) 2014 Danil. All rights reserved.
//

#import "CoreComponentsFactory.h"
#import "AFHTTPRequestOperationManager.h"

@implementation CoreComponentsFactory
- (id)apiService
{
    return [TyphoonDefinition withClass:[AFHTTPRequestOperationManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(baseURL) with:[NSURL URLWithString:@"https://api.instagram.com/v1/"]];
        definition.scope = TyphoonScopeSingleton;
    }];
}

@end

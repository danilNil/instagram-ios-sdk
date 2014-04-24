//
//  APIFactory.m
//  InstagramSDK
//
//  Created by Danil on 24.04.14.
//  Copyright (c) 2014 Danil. All rights reserved.
//

#import "APIFactory.h"
#import "UserAPI.h"
#import "CoreComponentsFactory.h"

@interface APIFactory ()

@property (nonatomic, strong) CoreComponentsFactory *components;

@end

@implementation APIFactory

- (id)userAPI{
    return [TyphoonDefinition withClass:[UserAPI class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(client) with:self.components.apiService];
        [definition injectProperty:@selector(token) with:self.components.token];
    }];
}

@end

//
//  UsersAPISpec.m
//  InstagramSDK
//
//  Created by Danil on 23/04/14.
//  Copyright 2014 Danil. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "UserAPI.h"
#import "LSNocilla.h"
#import "User.h"
#import "APIFactory.h"
#import "Typhoon.h"
#import "CoreComponentsFactory.h"

SPEC_BEGIN(UsersAPISpec)

describe(@"UsersAPI", ^{
    __block UserAPI *sut; //‘system under test’
    __block APIFactory* factory;

    beforeAll(^{
        [[LSNocilla sharedInstance] start];
    });

    afterAll(^{
        [[LSNocilla sharedInstance] stop];
    });

    beforeEach(^{
        
        factory = [TyphoonBlockComponentFactory factoryWithAssemblies:@[[CoreComponentsFactory assembly], [APIFactory assembly]]];
        sut = [factory userAPI];
    });
    
    afterEach(^{
        
        sut = nil;
        factory = nil;
        [[LSNocilla sharedInstance] clearStubs];

    });
    
    it(@"Get user by id", ^{
        stubRequest(@"GET", @"https://api.instagram.com/v1/users/+/?access_token=+")
                .andReturnRawResponse([NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"user_info" ofType:@"json"] ]);
        __block User* u;
        [[sut.client shouldNot] beNil];
        [[sut.token shouldNot] beNil];
        [sut getById:@"userId" withBlock:^ (User* user, NSError * error){
            u = user;
        }];

        [[expectFutureValue(u) shouldEventually] beNonNil];

    });


});


SPEC_END

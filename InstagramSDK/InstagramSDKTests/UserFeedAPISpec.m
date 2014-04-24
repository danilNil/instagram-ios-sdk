//
//  UsersAPISpec.m
//  InstagramSDK
//
//  Created by Danil on 23/04/14.
//  Copyright 2014 Danil. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "LSNocilla.h"
#import "APIFactory.h"
#import "Typhoon.h"
#import "CoreComponentsFactory.h"
#import "UserFeedAPI.h"

SPEC_BEGIN(UserFeedAPISpec)

describe(@"UserFeedAPI", ^{
    __block UserFeedAPI *sut; //‘system under test’
    __block APIFactory* factory;

    beforeAll(^{
        [[LSNocilla sharedInstance] start];
    });

    afterAll(^{
        [[LSNocilla sharedInstance] stop];
    });

    beforeEach(^{
        
        factory = [TyphoonBlockComponentFactory factoryWithAssemblies:@[[CoreComponentsFactory assembly], [APIFactory assembly]]];
        sut = [factory userFeedAPI];
        NSLog(@"!!! we created sut: %@", sut);
    });
    
    afterEach(^{
        
        sut = nil;
        factory = nil;
        [[LSNocilla sharedInstance] clearStubs];

    });
    

    it(@"Get user feed", ^{
        NSData* data = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"user_feed" ofType:@"json"] ];

        stubRequest(@"GET", @"^https://api\.instagram\.com/v1/users/self/feed(.*)".regex)
                .andReturnRawResponse(data).withHeaders(@{@"Content-Type": @"application/json"});
        __block UserFeed * uf;

        [[sut shouldNot] beNil];
        [sut getMyFeedWithBlock:^ (UserFeed * userFeed, NSError * error){
            uf = userFeed;
        }];

        [[expectFutureValue(uf) shouldEventually] beNonNil];
    });

});


SPEC_END

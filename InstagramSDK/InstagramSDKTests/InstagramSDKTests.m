//
//  InstagramSDKTests.m
//  InstagramSDKTests
//
//  Created by Danil on 20.04.14.
//  Copyright (c) 2014 Danil. All rights reserved.
//

#import "InstagramSDK.h"
#import "Kiwi.h"

SPEC_BEGIN(InstagramSDKSpec)

        describe(@"InstagramSDK", ^{

            __block InstagramSDK *sut; //‘system under test’

            beforeEach(^{

                sut = [[InstagramSDK alloc] init];

            });

            afterEach(^{

                sut = nil;

            });

            it(@"should exist", ^{

                [sut shouldNotBeNil];

            });

            it(@"should authorize user", ^{
                [sut login];
                [[sut.token shouldEventually] beNonNil];
            });

        });

SPEC_END
//
//  UsersAPISpec.m
//  InstagramSDK
//
//  Created by Danil on 23/04/14.
//  Copyright 2014 Danil. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "UsersAPI.h"


SPEC_BEGIN(UsersAPISpec)

describe(@"UsersAPI", ^{
    __block UsersAPI *sut; //‘system under test’
    
    beforeEach(^{
        
        sut = [[UsersAPI alloc] init];
        
    });
    
    afterEach(^{
        
        sut = nil;
        
    });
    
    it(@"Get user by id", ^{
        [sut getById:@"userId"];
    });
});

SPEC_END

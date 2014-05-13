//
// Created by Danil on 12/05/14.
// Copyright (c) 2014 Mabogo. All rights reserved.
//

#import "UIViewController+Factory.h"
#import "Typhoon.h"
#import "ViewControllersFactory.h"

@implementation UIViewController (Factory)

NSString const *key = @"factory.key";

- (ViewControllersFactory *)factory {
    return objc_getAssociatedObject(self, &key);
}

- (void)typhoonSetFactory:(TyphoonAssembly *)theFactory {
    objc_setAssociatedObject(self, &key, theFactory, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
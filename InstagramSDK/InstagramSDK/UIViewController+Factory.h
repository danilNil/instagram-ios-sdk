//
// Created by Danil on 12/05/14.
// Copyright (c) 2014 Mabogo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ViewControllersFactory;

@interface UIViewController (Factory)
@property (nonatomic, weak, readonly) ViewControllersFactory* factory;
@end
////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonFactoryPropertyInjectionPostProcessor.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonDefinition.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonInjectionByComponentFactory.h"
#import "TyphoonInjectionByType.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonAssembly.h"

@implementation TyphoonFactoryPropertyInjectionPostProcessor

/* ====================================================================================================================================== */
#pragma mark - Protocol Methods

- (void)postProcessComponentFactory:(TyphoonComponentFactory *)factory
{
    for (TyphoonDefinition *definition in [factory registry]) {

        [definition enumerateInjectionsOfKind:[TyphoonInjectionByType class] options:TyphoonInjectionsEnumerationOptionProperties
                                   usingBlock:^(TyphoonInjectionByType *typeInjection, id <TyphoonInjection> *injectionToReplace, BOOL *stop) {
            if ([self shouldReplaceInjectionByType:typeInjection withFactoryInjectionInDefinition:definition]) {
                *injectionToReplace = [self factoryInjectionToReplacePropertyInjection:typeInjection];
            }
        }];
    }
}

/* ====================================================================================================================================== */
#pragma mark - Instance Methods

- (BOOL)shouldReplaceInjectionByType:(TyphoonInjectionByType *)propertyInjection
    withFactoryInjectionInDefinition:(TyphoonDefinition *)definition
{
    BOOL isFactoryClass = NO;

    TyphoonTypeDescriptor
        *type = [TyphoonIntrospectionUtils typeForPropertyWithName:propertyInjection.propertyName inClass:definition.type];

    if (type.typeBeingDescribed) {
        isFactoryClass = [type.typeBeingDescribed isSubclassOfClass:[TyphoonComponentFactory class]];
    }

    return isFactoryClass;
}

- (TyphoonInjectionByComponentFactory *)factoryInjectionToReplacePropertyInjection:(id<TyphoonPropertyInjection>)propertyInjection
{
    TyphoonInjectionByComponentFactory *newInjection = [[TyphoonInjectionByComponentFactory alloc] init];
    [newInjection setPropertyName:[propertyInjection propertyName]];
    return newInjection;
}

@end

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


#import <Foundation/Foundation.h>

#import "TyphoonMethod.h"

@class TyphoonDefinition;
@class TyphoonRuntimeArguments;

/**
* @ingroup Definition
* Describes the lifecycle of a Typhoon component.

* <strong>TyphoonScopeObjectGraph</strong>
* (default) means that a new non-retained component is created when resolved from the factory, and any dependencies declared during
* resolution of the object graph will be shared. For example, let's both a view controller and a view reference a component called
* 'validator' - using the object-graph scope, this validator will be shared between the view and controller. However, unlike a singleton,
* it is not retained by Typhoon, so will be released when there are no more strong references holding it.
*
* <strong>TyphoonScopePrototype</strong>
* (default for definitions with runtime argument injections)
* means that a new component is created for each time it is referenced in a collaborator, or retrieved from the factory.
*
* <strong>TyphoonScopeSingleton</strong>
* creates a shared instance. When the DI pattern is applied in a server-side environment, this tends to be the default scope, as the backend
* could service any use-case at a given time. However in the case of mobile and desktop applications, we typically service one use-case at a
* time, and furthermore we have more limited system-resources. Therefore singleton should be used more sparingly in these environments.
*
* <strong>TyphoonScopeWeakSingleton</strong>
* creates an instance that will be shared across all components. However as soon as the instance is not being used it will be deallocated.
*
*/
typedef enum
{
    TyphoonScopeObjectGraph = 1 << 0,
    TyphoonScopePrototype = 1 << 1,
    TyphoonScopeSingleton = 1 << 2,
    TyphoonScopeWeakSingleton = 1 << 3
} TyphoonScope;


typedef void(^TyphoonInitializerBlock)(TyphoonMethod *initializer);

typedef void(^TyphoonDefinitionBlock)(TyphoonDefinition *definition);

/**
* @ingroup Definition
*/
@interface TyphoonDefinition : NSObject <NSCopying>
{
    Class _type;
    NSString *_key;
    TyphoonMethod *_initializer;
    NSMutableSet *_injectedProperties;
    NSMutableSet *_injectedMethods;
    TyphoonScope _scope;
    TyphoonDefinition *_factory;
    TyphoonRuntimeArguments *_currentRuntimeArguments;
}

@property(nonatomic, readonly) Class type;

/**
* The key of the component. A key is useful when multiple configuration of the same class or protocol are desired - for example
* MasterCardPaymentClient and VisaPaymentClient.
*
* If using the TyphoonBlockComponentFactory style of assembly, the key is automatically generated based on the selector name of the
* component, thus avoiding "magic strings" and providing better integration with IDE refactoring tools.
*/
@property(nonatomic, strong) NSString *key;

/**
* Describes the initializer, ie the selector and arguments that will be used to instantiate this component.
*
* An initializer can be an instance method, a class method, or even a reference to another component's method (see factory property).
*
* If no explicit initializer has been set, returns a default initializer representing the init method.
*
* @see factory
*/
@property(nonatomic, strong) TyphoonMethod *initializer;

/**
 * Returns true if this is a default initializer generated by Typhoon. A manually specified initializer will return false, even if the
 * selector is @selector(init)
 */
@property(nonatomic, getter = isInitializerGenerated) BOOL initializerGenerated;
/**
* A custom callback method that is invoked before property injection occurs. Use this method as an alternative to
* TyphoonPropertyInjectionDelegate if the component being instantiated is a 3rd party library, or if a direct dependency on Typhoon is not
* desired.
*
* @see TyphoonPropertyInjectionDelegate
*/
@property(nonatomic) SEL beforeInjections;

/**
* A custom callback method that is invoked after property injection occurs. Use this method as an alternative to
* TyphoonPropertyInjectionDelegate if the component being instantiated is a 3rd party library, or if a direct dependency on Typhoon is not
* desired.
*
* @see TyphoonPropertyInjectionDelegate
*/
@property(nonatomic) SEL afterInjections;

/**
* The scope of the component, default being TyphoonScopeObjectGraph.
*/
@property(nonatomic) TyphoonScope scope;


/**
* A component that will produce an instance (with or without parameters) of this component. For example:
*
@code

- (id)sqliteManager
{
    return [TyphoonDefinition withClass:[VBSqliteManager class] initialization:^(TyphoonInitializer* initializer)
    {
        initializer.selector = @selector(initWithDatabaseName:);
        [initializer injectWithObject:@"app_database_v2.sqlite"];
    } properties:^(TyphoonDefinition* definition)
    {
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (id)databaseQueue
{
    return [TyphoonDefinition withClass:[FMDatabaseQueue class] initialization:^(TyphoonInitializer* initializer)
    {
        initializer.selector = @selector(queue);
    } properties:^(TyphoonDefinition* definition)
    {
        definition.factory = [self sqliteManager];
    }];
}
@endcode
*
* @note If the factory method takes arguments, these are provided in the initializer block, just like a regular initializer method.
*
* @see injectProperty:withDefinition:selector: An alternative short-hand approach for no-args instances.
* @see injectProperty:withDefinition:keyPath: An alternative short-hand approach for no-args instances.
* @see TyphoonFactoryProvider - For creating factories where the configuration arguments are not known until runtime.
*
*
*/
@property(nonatomic, strong) TyphoonDefinition *factory;

/**
* A parent component. When parent is defined the initializer and/or properties from a definition are inherited, unless overridden. Example:
*
@code

- (id)signUpClient
{
    return [TyphoonDefinition withClass:[SignUpClientDefaultImpl class] properties:^(TyphoonDefinition* definition)
    {
        definition.parent = [self abstractClient];
    }];
}

- (id)storeClient
{
    return [TyphoonDefinition withClass:[StoreClientDefaultImpl class] properties:^(TyphoonDefinition* definition)
    {
        definition.parent = [self abstractClient];
        [definition injectProperty:@selector(storeDao) withDefinition:[_persistenceComponents storeDao]];
        [definition injectProperty:@selector(couponDao) withDefinition:[_persistenceComponents couponDao]];
    }];
}

- (id)abstractClient
{
    return [TyphoonDefinition withClass:[ClientBase class] properties:^(TyphoonDefinition* definition)
    {
        [definition injectProperty:@selector(serviceUrl) withValueAsText:@"${client.serviceUrl}"];
        [definition injectProperty:@selector(networkMonitor) withDefinition:[self internetMonitor]];
        [definition injectProperty:@selector(allowInvalidSSLCertificates) withValueAsText:@"${client.allowInvalidSSLCertificates}"];
        [definition injectProperty:@selector(logRequests) withValueAsText:@"${client.logRequests}"];
        [definition injectProperty:@selector(logResponses) withValueAsText:@"${client.logResponses}"];
    }];
}

@endcode
*
* @see abstract
*
*/
@property(nonatomic, strong) TyphoonDefinition *parent;

/**
* If set, designates that a component can not be instantiated directly.
*
* @see parent
*/
@property(nonatomic) BOOL abstract;


/**
 * Say if the component (scoped as a singleton) should be lazily instantiated.
 */
@property(nonatomic, assign, getter = isLazy) BOOL lazy;


/* ====================================================================================================================================== */
#pragma mark Factory methods

+ (TyphoonDefinition *)withClass:(Class)clazz;

+ (TyphoonDefinition *)withClass:(Class)clazz configuration:(TyphoonDefinitionBlock)injections;

+ (TyphoonDefinition *)withClass:(Class)clazz factory:(TyphoonDefinition *)definition selector:(SEL)selector;

/* ====================================================================================================================================== */
#pragma mark Injection

/**
* Injects property with a component from the container that matches the type (class or protocol) of the property.
*/
- (void)injectProperty:(SEL)withSelector;

/**
 * Injects property for gives selector with injection, where injection can be
 * - obtained from Injection* functions
 * - another definition
 * - assembly or collaboration assembly reference (TyphoonComponentFactory will be injected)
 * - object instance
 */
- (void)injectProperty:(SEL)selector with:(id)injection;

/** 
 * Injects method with specified by selector with parameters. 
 * @see TyphoonMethod documentation for information about parameters
 */
- (void)injectMethod:(SEL)selector parameters:(void(^)(TyphoonMethod *method))parametersBlock;

/**
 * Injects initializer specified by selector and parameters. 
 * Initializer allow you to create object with special selector and params. Without this injection,
 * object will be created by 'alloc-init' calls
 */
- (void)useInitializer:(SEL)selector parameters:(void(^)(TyphoonMethod *initializer))parametersBlock;

/**
* Convenience method to use a no-args initializer.
*
*/
- (void)useInitializer:(SEL)selector;

#pragma mark Making injections from definition

/**
 * Returns injection which can be used for example in injectProperty:with: method
 * This method will injects result of selector invocation
 * @param selector selector to invoke on resolved definition
 */
- (id)property:(SEL)selector;

/**
 * Returns injection which can be used for example in injectProperty:with: method
 * This method will injects valueForKeyPath: with given keyPath
 * @param keyPath path used as argument while calling valueForKeyPath: on resolved definition
 */
- (id)keyPath:(NSString *)keyPath;

@end

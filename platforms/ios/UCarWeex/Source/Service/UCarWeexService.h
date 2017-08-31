//
//  UCarWeexEngine.h
//  Pods
//
//  Created by huyujin on 2017/8/11.
//
//

#import <Foundation/Foundation.h>
//#import <UCarWeex/UCarWeex.h>
#import <WeexSDK/WXLog.h>

@interface UCarWeexService : NSObject

+ (void)initUCarWeexService;

#pragma mark - 
/**
 *  @abstract Register a module for a given name
 *
 *  @param name The module name to register
 *
 *  @param clazz  The module class to register
 *
 **/
+ (void)registerModule:(NSString *)name withClass:(Class)clazz;

/**
 * @abstract Registers a component for a given name
 *
 * @param name The component name to register
 *
 * @param clazz The WXComponent subclass to register
 *
 **/
+ (void)registerComponent:(NSString *)name withClass:(Class)clazz;

/**
 * @abstract Registers a handler for a given handler instance and specific protocol
 *
 * @param handler The handler instance to register
 *
 * @param protocol The protocol to confirm
 *
 */
+ (void)registerHandler:(id)handler withProtocol:(Protocol *)protocol;

#pragma mark -
/**
 * @abstract Group or organization of your app, default value is nil.
 */
+ (NSString *)appGroup;
+ (void)setAppGroup:(NSString *) appGroup;

/**
 * @abstract Name of your app, default is value for CFBundleDisplayName in main bundle.
 */
+ (NSString *)appName;
+ (void)setAppName:(NSString *)appName;

/**
 * @abstract Version of your app, default is value for CFBundleShortVersionString in main bundle.
 */
+ (NSString *)appVersion;
+ (void)setAppVersion:(NSString *)appVersion;

#pragma mark -
/**
 *  log level
 */
+ (void)setLogLevel:(WXLogLevel)level;

@end

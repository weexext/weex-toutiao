//
//  UCarWeexEngine.m
//  Pods
//
//  Created by huyujin on 2017/8/11.
//  Copyright © 2017年 ucarinc. All rights reserved.
//

#import "UCarWeexService.h"
#import <WeexSDK/WeexSDK.h>
#import "UCXNavigatorModule.h"
#import "UCXGlobalEventModule.h"

@interface UCarWeexService ()

@property (nonatomic, assign) NSUInteger logLevel; ///< logLevel

@end

@implementation UCarWeexService

+ (instancetype)shared {
    static dispatch_once_t once = 0;
    static UCarWeexService *instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (void)initUCarWeexService {
    //init sdk enviroment
    [WXSDKEngine initSDKEnvironment];
    //register custom module and component
    //...
    [WXSDKEngine registerModule:@"UNavigator" withClass:[UCXNavigatorModule class]];
    [WXSDKEngine registerModule:@"UGlobalEvent" withClass:[UCXGlobalEventModule class]];
    
    //register the implementation of protocol
    
    //set the log level
    [WXLog setLogLevel:[UCarWeexService shared].logLevel];
}

#pragma mark - 
+ (void)registerModule:(NSString *)name withClass:(Class)clazz {
    [WXSDKEngine registerModule:name withClass:clazz];
}

+ (void)registerComponent:(NSString *)name withClass:(Class)clazz {
    [WXSDKEngine registerComponent:name withClass:clazz];
}

+ (void)registerHandler:(id)handler withProtocol:(Protocol *)protocol {
    [WXSDKEngine registerHandler:handler withProtocol:protocol];
}

#pragma mark - business configuration
+ (NSString *)appGroup {
    return [WXAppConfiguration appGroup];
}
+ (void)setAppGroup:(NSString *)appGroup {
    [WXAppConfiguration setAppGroup:appGroup];
}

+ (NSString *)appName {
    return [WXAppConfiguration appName];
}
+ (void)setAppName:(NSString *)appName {
    [WXAppConfiguration setAppName:appName];
}

+ (NSString *)appVersion {
    return [WXAppConfiguration appVersion];
}
+ (void)setAppVersion:(NSString *)appVersion {
    [WXAppConfiguration setAppVersion:appVersion];
}

#pragma mark - log
+ (void)setLogLevel:(WXLogLevel)level {
    [[UCarWeexService shared] setLogLevel:level];
}

@end

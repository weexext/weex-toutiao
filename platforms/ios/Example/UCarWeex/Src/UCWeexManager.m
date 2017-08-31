//
//  UCWeexManager.m
//  UCarWeex
//
//  Created by huyujin on 2017/8/11.
//  Copyright © 2017年 hyj223. All rights reserved.
//

#import "UCWeexManager.h"

//#import <WeexSDK/WeexSDK.h>
#import <UCarWeex/UCarWeex.h>

#ifdef DEBUG
#import <TBWXDevTool/WXDevTool.h>
#endif

#import "UCImgLoaderDefaultImpl.h"

@interface UCWeexManager ()

@end

@implementation UCWeexManager

+ (void)setup {
    // 初始化UCARWEEX的可设置项
    [UCarWeexService setAppGroup:@"ucarinc"];
    [UCarWeexService setAppName:APP_NAME];
    [UCarWeexService setAppVersion:APP_VERSION];
#ifdef DEBUG
    [UCarWeexService setLogLevel:WXLogLevelLog];
    [WXDevTool setDebug:YES];
    [WXDevTool launchDevToolDebugWithUrl:[NSString stringWithFormat:@"ws://%@:8088/debugProxy/native",LOCAL_IP]];
#else
    [UCarWeexService setLogLevel:WXLogLevelError];
#endif
    [UCarWeexService initUCarWeexService];
    //
    [UCarWeexService registerHandler:[UCImgLoaderDefaultImpl new] withProtocol:@protocol(WXImgLoaderProtocol)];
}

@end

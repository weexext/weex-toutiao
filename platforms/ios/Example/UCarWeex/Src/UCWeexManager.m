//
//  UCWeexManager.m
//  UCarWeex
//
//  Created by huyujin on 2017/8/11.
//  Copyright © 2017年 hyj223. All rights reserved.
//

#import "UCWeexManager.h"

#import <UCarWeex/UCarWeex.h>

#ifdef DEBUG
#import <TBWXDevTool/TBWXDevTool.h>
#endif

#import "UCImgLoaderDefaultImpl.h"

@interface UCWeexManager ()

@end

@implementation UCWeexManager

+ (void)setup {
    //自定义全局环境变量
//    NSDictionary *customEnvironmentDict = @{@"url":@"http://xxx.com",@"debugState":@"false"};
//    [WXSDKEngine setCustomEnvironment:customEnvironmentDict];
    // 初始化UCARWEEX的可设置项
    [UCXAppConfiguration setAppGroup:@"ucarinc"];
    [UCXAppConfiguration setAppName:APP_NAME];
    [UCXAppConfiguration setAppVersion:APP_VERSION];
#ifdef DEBUG
    [UCarWeexService setLogLevel:WXLogLevelLog];
    [WXDevTool setDebug:UC_WEEX_DEBUG_MODE];
    [WXDevTool launchDevToolDebugWithUrl:[NSString stringWithFormat:@"ws://%@:%@/debugProxy/native",UC_LOCAL_IP,UC_LOCAL_WEEX_PORT]];
#else
    [UCarWeexService setLogLevel:WXLogLevelError];
#endif
    [UCarWeexService initUCarWeexService];
    //
    [UCarWeexService registerHandler:[UCImgLoaderDefaultImpl new] withProtocol:@protocol(WXImgLoaderProtocol)];
    
    //启动时默认从以下指定位置解压 本地JS & 图片资源
    // url:::assets/weex/，若未赋值，则使用默认地址：assets/weex/
    NSDictionary *dict = @{@"url":@"assets/weex/"};
    [UCXHotUpdate unpack:dict callback:^(NSError *error) {}];
//    //若使用热更新，则使用如下代码：：url为拉取指定更新信息的远程地址
//    NSDictionary *options = @{@"url":@"http://10.99.21.32:3000/ucarweex"};
//    [UCXHotUpdate hotUpdate:options callback:^(NSError *error) {
//        //...
//    }];
    
}

@end

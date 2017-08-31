//
//  UCGlobalEventModule.m
//  Portal
//
//  Created by huyujin on 2017/6/29.
//  Copyright © 2017年 ucarinc. All rights reserved.
//
//  NOTE:: 发送全局通知
//


#import "UCXGlobalEventModule.h"


@implementation UCXGlobalEventModule
@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(postGlobalEvent:params:))

/**
 发送全局事件
 @param eventName 事件名称
 @param params 事件参数
 */
- (void)postGlobalEvent:(NSString *)eventName params:(NSDictionary *)params {
    if (!params){
        params = [NSDictionary dictionary];
    }
    NSDictionary * userInfo = @{@"param":params};
    [[NSNotificationCenter defaultCenter] postNotificationName:eventName object:self userInfo:userInfo];
}


@end

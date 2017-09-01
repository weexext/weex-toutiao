//
//  UCXHotUpdate.h
//  Pods
//
//  Created by huyujin on 2017/8/23.
//  Copyright © 2017年 ucarinc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCXDefine.h"

@interface UCXHotUpdate : NSObject

+ (instancetype)shared;

/** 更新包下载解压校验
 *  options:
        url:更新包信息url
 */
+ (void)hotUpdate:(NSDictionary *)options
         callback:(void (^)(NSError *error))callback;

/** 解析本地包
 *   options:预留字段，可传 nil or @{}
 */
+ (void)unpack:(NSDictionary *)options callback:(void (^)(NSError *error))callback;

@end

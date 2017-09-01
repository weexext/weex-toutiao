//
//  UCXUtil.h
//  WeexDemo
//
//  Created by huyujin on 2017/8/4.
//  Copyright © 2017年 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCXDefine.h"

@interface UCXUtil : NSObject

// 下载保存路径
+ (NSString *)downloadDir;
#define UCXDownloadDir    [UCXUtil downloadDir]

// 获取当前时间字符串: pattern:'YYYYMMddhhmmss'
+ (NSString *)currentDateStr;

//异常信息封装
+ (NSError *)errorWithMessage:(NSString *)errorMessage;

//==========
+ (NSString*)dictionaryToJson:(NSDictionary *)dict;
+ (NSDictionary *)dictionaryWithJson:(NSString *)jsonStr;

//==========
+ (NSString *)urlEncode:(NSString *)url;

// get the md5 string for a file
+ (NSString *)fileMD5:(NSString *)filePath;

//==========
+ (UIColor *)colorWithHexString:(NSString *)hexString;


@end

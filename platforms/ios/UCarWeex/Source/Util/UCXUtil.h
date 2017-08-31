//
//  UCXUtil.h
//  WeexDemo
//
//  Created by huyujin on 2017/8/4.
//  Copyright © 2017年 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCXUtil : NSObject

//==========
+ (NSString*)dictionaryToJson:(NSDictionary *)dict;
+ (NSDictionary *)dictionaryWithJson:(NSString *)jsonStr;

//==========
+ (NSString *)urlEncode:(NSString *)url;

//==========
+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end

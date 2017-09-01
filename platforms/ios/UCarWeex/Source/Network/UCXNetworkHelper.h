//
//  UCXNetworkHelper.h
//  Pods
//
//  Created by huyujin on 2017/8/29.
//
//

#import <Foundation/Foundation.h>
#import "UCXDefine.h"

/** 请求成功的Block */
typedef void(^UCXRequestSuccess)(NSDictionary *responseObj);
/** 请求失败的Block */
typedef void(^UCXRequestFailure)(NSError *error);

@interface UCXNetworkHelper : NSObject

+ (instancetype)shared;

/**
 *  POST请求
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return NSURLSessionTask
 */
- (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(id)parameters
                            success:(UCXRequestSuccess)success
                            failure:(UCXRequestFailure)failure;

@end

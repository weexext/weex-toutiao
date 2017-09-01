//
//  UCXHotUpdateDownloader.h
//  Pods
//
//  Created by huyujin on 2017/8/23.
//  Copyright © 2017年 ucarinc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCXHotUpdateDownloader : NSObject

+ (void)download:(NSString *)downloadPath savePath:(NSString *)savePath
 progressHandler:(void (^)(long long, long long))progressHandler
completionHandler:(void (^)(NSString *path, NSError *error))completionHandler;

@end

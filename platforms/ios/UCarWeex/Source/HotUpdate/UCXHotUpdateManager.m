//
//  UCXHotUpdateManager.m
//  Pods
//
//  Created by huyujin on 2017/8/23.
//  Copyright © 2017年 ucarinc. All rights reserved.
//

#import "UCXHotUpdateManager.h"
#import "ZipArchive.h"

@implementation UCXHotUpdateManager {
    dispatch_queue_t _opQueue;
}

- (void)dealloc {
    NSLog(@"UCXHotUpdateManager dealloc");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _opQueue = dispatch_queue_create("weex.ucar.hotupdate", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (BOOL)deleteDir:(NSString *)dir {
    __block BOOL success = false;
    
    dispatch_sync(_opQueue, ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSError *error;
        [fileManager removeItemAtPath:dir error:&error];
        if (!error) {
            success = true;
            return;
        }
    });
    
    return success;
}

- (BOOL)createDir:(NSString *)dir
{
    BOOL success = false;
    
    BOOL isDir;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:dir isDirectory:&isDir]) {
        if (isDir) {
            success = true;
        }
    }else {
        NSError *error;
        [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error];
        if (!error) {
            success = true;
        }
    }
    return success;
}

- (void)unzipFileAtPath:(NSString *)path
          toDestination:(NSString *)destination
        progressHandler:(void (^)(NSString *entry, long entryNumber, long total))progressHandler
      completionHandler:(void (^)(NSString *path, BOOL succeeded, NSError *error))completionHandler
{
    dispatch_async(_opQueue, ^{
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:destination]) {
            [[NSFileManager defaultManager] removeItemAtPath:destination error:nil];
        }
        
        [SSZipArchive unzipFileAtPath:path toDestination:destination progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
            progressHandler(entry, entryNumber, total);
        } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
            // 解压完，移除zip文件
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            if (completionHandler) {
                completionHandler(path, succeeded, error);
            }
        }];
    });
}


@end

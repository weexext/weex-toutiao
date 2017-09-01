//
//  UCXHotUpdate.m
//  Pods
//
//  Created by huyujin on 2017/8/23.
//  Copyright © 2017年 ucarinc. All rights reserved.
//

/**
    存储于userdefaults,KEY:UCX_US_UCAR_WEEX_KEY:,以数组形式存储，每个元素的结构如下
    {
     "appName": "ucarweex",
     "versionCode": 2,
     "versionName": "1.0",
     "versionDes": "新版说明",
     "androidMinVersion": 1,
     "iosMinVersion": 1,
     "groupId": "vid_001",
     "md5": "b8751466a1994c61a00d77d5307a481d",
     "length": 577705,
     "time": "20170825101245",
     "path": "ucarweex_2_20170825101245"
     
     "url": "http://10.99.44.46:3000/file/ucarweex_2_20170825101245.so",
     "unzipFilePath":""
    }

 */

#import "UCXHotUpdate.h"
#import <WeexSDK/WeexSDK.h>

#import "UCXHotUpdateManager.h"
#import "UCXHotUpdateDownloader.h"
#import "UCXUtil.h"
#import "UCXAppConfiguration.h"
#import "UCXNetworkHelper.h"


@interface UCXHotUpdate ()

@property (nonatomic, strong) UCXHotUpdateManager *fileManager;
/**
 * options 内部结构如下：
 {
    url:
    packageInfo:
    {
         "appName": "ucarweex",
         "versionCode": 2,
         "versionName": "1.0",
         "versionDes": "新版说明",
         "androidMinVersion": 1,
         "iosMinVersion": 1,
         "groupId": "vid_001",
         "md5": "b8751466a1994c61a00d77d5307a481d",
         "length": 577705,
         "time": "20170825101245",
         "path": "ucarweex_2_20170825101245"
    }
 }
 */
@property (nonatomic, strong) NSMutableDictionary *currentOptions;  //当前获取的配置信息：
@property (nonatomic, strong) NSMutableDictionary *lastOptions;     //应用中最后的配置信息

@end

@implementation UCXHotUpdate

+ (instancetype)shared {
    static dispatch_once_t once = 0;
    static UCXHotUpdate *instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

/**初始化信息*/
- (void)initData {
    //
    _currentOptions = [NSMutableDictionary dictionary];
    _lastOptions = [NSMutableDictionary dictionary];
    _fileManager = [[UCXHotUpdateManager alloc] init];
    //若目录不存在，则创建指定目录:::
    BOOL success = [self.fileManager createDir:UCXDownloadDir];
    if (!success) {
        UCXLog(@"[UCAR WEEX]:::目录创建未成功:::%@",UCXDownloadDir);
    }
    //读取应用最后使用的配置信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *optionsArr = [userDefaults objectForKey:UCX_US_UCAR_WEEX_KEY];
    if (optionsArr && optionsArr.count>0) {
        self.lastOptions = [optionsArr lastObject];
    }
}

#pragma mark -
+ (void)unpack:(NSDictionary *)options callback:(void (^)(NSError *error))callback {
    UCXHotUpdate *instance = [UCXHotUpdate shared];
    [instance unpack:options callback:^(NSError *error) {
        if (error) {
            UCXLog(@"[UCAR WEEX]:::ERROR:::%@",[error localizedDescription]);
        }
        callback(error);
    }];
}

- (void)unpack:(NSDictionary *)options callback:(void (^)(NSError *error))callback {
    //同步方式解压文件 & 解析配置
    //找到压缩文件 & 配置文件
    NSString *assetsPath = [NSString stringWithFormat:@"%@/%@/%@",[[NSBundle mainBundle] resourcePath],@"assets",@"weex"];
    NSString *url = [options objectForKey:@"url"];
    if (url.length>0) {
        assetsPath = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath],url];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *myDirEnumerator = [fileManager enumeratorAtPath:assetsPath];  //assetsPath
    
    NSString *fileName;
    NSString *jsonFilePath;
    NSString *zipFilePath;
    NSString *tmpName;
    while((tmpName= [myDirEnumerator nextObject])) {    //遍历当前目录
        if([[tmpName pathExtension] isEqualToString:@"json"]) { //取得后缀名为.json的文件名
            jsonFilePath = [assetsPath stringByAppendingPathComponent:tmpName];
        }else if ([[tmpName pathExtension] isEqualToString:@"so"]) {//取得后缀名为.zip的文件名
            zipFilePath = [assetsPath stringByAppendingPathComponent:tmpName];
            //
            NSRange range = [tmpName rangeOfString:@"." options:NSBackwardsSearch];
            fileName = [tmpName substringToIndex:range.location];
        }
    }
    //解析配置文件
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonFilePath];
    NSError *jsonError;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&jsonError];
    if (jsonError) {
        callback([UCXUtil errorWithMessage:UCX_ERROR_JSON_PARSE]);
        return;
    }
    //校验文件信息，判断是否需要更新
    self.currentOptions = [jsonDict mutableCopy];
    BOOL isNeedUpdate = [self validateOptions:self.currentOptions];
    if (!isNeedUpdate) {
        callback(nil);
        return;
    }

    NSString *unzipFilePath = [UCXDownloadDir stringByAppendingPathComponent:fileName];
    //本地文件解压,需同步
    __block NSError *zipError;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [self.fileManager unzipFileAtPath:zipFilePath toDestination:unzipFilePath progressHandler:^(NSString *entry,long entryNumber, long total) {
        //压缩进度设置...
    } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
        zipError = error;
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    if (zipError) { //解压文件失败
        callback(zipError);
        return;
    }
    //解压完成，保存本次更新的必要信息到本地存储
    [self savePackageInfo:unzipFilePath];
}

#pragma mark - 下载更新包
+ (void)hotUpdate:(NSDictionary *)options
         callback:(void (^)(NSError *error))callback
{
    UCXHotUpdate *instance = [UCXHotUpdate shared];
    [instance hotUpdate:options callback:^(NSError *error) {
        if (error) {
            UCXLog(@"[UCAR WEEX]:::ERROR:::%@",[error localizedDescription]);
        }
        callback(error);
    }];
}

- (void)hotUpdate:(NSDictionary *)options callback:(void (^)(NSError *error))callback {
    // 网络请求配置信息
    NSString *url = [options objectForKey:@"url"];
    if (url.length<=0) {
        callback([UCXUtil errorWithMessage:UCX_ERROR_INVALIDATE_PARAM]);
        return;
    }
    //
    NSDictionary *parameters = @{
        @"appName":@"ucarweex",
        @"versionCode":@1,
        @"groupId":@"vid_001",
        @"nativeVer":@1,
        @"platform":@"ios"
        };
    [[UCXNetworkHelper shared] POST:url parameters:parameters success:^(NSDictionary *responseObj) {
        //
        NSDictionary *dictData = [responseObj objectForKey:@"data"];
        if ([dictData count]>0) {
            //
            self.currentOptions = [dictData mutableCopy];
            NSString *updateUrl = [WXConvert NSString:dictData[@"url"]];
            if (updateUrl.length<=0) {
                callback([UCXUtil errorWithMessage:UCX_ERROR_OPTIONS]);
                return;
            }
            // 根据更新包地址下载更新包
            // 解析相关参数
            NSString *lastPathComponent = [updateUrl lastPathComponent];
            NSString *fileName = lastPathComponent;
            NSRange range = [lastPathComponent rangeOfString:@"." options:NSBackwardsSearch];
            if(range.location !=NSNotFound) {
                fileName = [lastPathComponent substringToIndex:range.location];
            }
            
            NSString *unzipFilePath = [UCXDownloadDir stringByAppendingPathComponent:fileName];
            NSString *zipFilePath = [UCXDownloadDir stringByAppendingPathComponent:lastPathComponent];
            //
            UCXLog(@"HotUpdate -- download file %@", updateUrl);
            [UCXHotUpdateDownloader download:updateUrl savePath:zipFilePath progressHandler:^(long long receivedBytes, long long totalBytes) {
                //下载进度设置...
            } completionHandler:^(NSString *path, NSError *error) {
                if (error) {
                    callback(error);
                } else {
                    UCXLog(@"HotUpdate -- unzip file %@", path);
                    //校验文件md5
                    BOOL flag = [self validateFile:path];
                    if (flag) { //文件合法
                        //解压缩
                        [self.fileManager unzipFileAtPath:path toDestination:unzipFilePath progressHandler:^(NSString *entry,long entryNumber, long total) {
                            //压缩进度设置...
                        } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                if (error) {
                                    callback(error);
                                } else {
                                    //解压完成，保存本次更新的必要信息到本地存储
                                    [self savePackageInfo:path];
                                    callback(nil);
                                }
                            });
                        }];
                    }else {
                        //文件校验不通过
                        callback([UCXUtil errorWithMessage:UCX_ERROR_FILE_VALIDATE]);
                    }
                }
            }];
            
        }
    } failure:^(NSError *error) {
        callback(error);
        return;
    }];
}


/**
 * 保存本次更新的必要信息到本地存储
 ucar_weex:
 [
     "appName": "ucarweex",
     "versionCode": 2,
     "versionName": "1.0",
     "versionDes": "新版说明",
     "androidMinVersion": 1,
     "iosMinVersion": 1,
     "groupId": "vid_001",
     "md5": "b8751466a1994c61a00d77d5307a481d",
     "length": 577705,
     "time": "20170825101245",
     "path": "ucarweex_2_20170825101245"
     
     "url": "http://10.99.44.46:3000/file/ucarweex_2_20170825101245.so",
     "unzipFilePath":""
 ]
 
 */
- (void)savePackageInfo:(NSString *)unzipFilePath {
    if ([self.currentOptions count]>0 && unzipFilePath) {
        //
        NSString *url = [self.currentOptions objectForKey:@"url"];
        //重组新的数据结构:结构如上注释
        NSMutableDictionary *newPackageInfo = [NSMutableDictionary dictionary];
        if (url) {//若是存在url，则是在远程加载
            NSDictionary *originPackageInfo = [self.currentOptions objectForKey:@"packageInfo"];
            [newPackageInfo addEntriesFromDictionary:originPackageInfo];
            [newPackageInfo setObject:url forKey:@"url"];
        }else { //若是加载本地json，则结构不存在url
            [newPackageInfo addEntriesFromDictionary:self.currentOptions];
        }
        if (unzipFilePath) {
            [newPackageInfo setObject:unzipFilePath forKey:@"unzipFilePath"];
        }
        //
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *weexDataArr = [userDefaults objectForKey:UCX_US_UCAR_WEEX_KEY];
        NSMutableArray *newDataArr = [NSMutableArray array];
        //
        if (weexDataArr && weexDataArr.count>0) {
            [newDataArr addObjectsFromArray:weexDataArr];
        }
        [newDataArr addObject:newPackageInfo];
        [userDefaults setObject:newDataArr forKey:UCX_US_UCAR_WEEX_KEY];
        [userDefaults synchronize];
        //set cache path into memory
        [UCXAppConfiguration cachePath];
        //校验当前存储版本历史是否超出限制，若超出限制，则只保留最近的版本
        [self handleVersionHistory];
    }
}


#pragma mark - validate

- (void)handleVersionHistory {
    //获取当前存储版本历史：
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *weexDataArr = [userDefaults objectForKey:UCX_US_UCAR_WEEX_KEY];
    NSInteger maxCacheVersionNumber = [UCXAppConfiguration maxCacheVersionNumber];
    if (weexDataArr && weexDataArr.count>maxCacheVersionNumber) {
        //倒序遍历，超出maxCacheVersionNumber的item，则删除
        __block NSInteger count = 0;
        [weexDataArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            count++;
            if (count>maxCacheVersionNumber) {
                NSString *unzipPath = [dict objectForKey:UCX_UNZIP_FILE_PATH];
                if (unzipPath) {
                    [self.fileManager deleteDir:unzipPath];
                }
            }
        }];
    }
}

/**
 * 比较应用中的配置文件信息与当前从本地或者远程获取的配置信息
 */
- (BOOL)validateOptions:(NSDictionary *)options {
    //若本地尚没有配置信息
    if ([self.lastOptions count]<=0) {
        return YES;
    }
    // 获取的版本时间高于应用中版本的时间
    NSString *lastTime = [self.lastOptions objectForKey:@"time"];
    NSString *currentTime = [options objectForKey:@"time"];
    if(lastTime && currentTime && [currentTime compare:lastTime]==NSOrderedDescending) {
        return YES;
    }
    
    return NO;
}

/**
 * 校验文件是否合法
 */
- (BOOL)validateFile:(NSString *)path {
    BOOL flag = NO;
    NSString *computedFileMD5 = [UCXUtil fileMD5:path];
    if ([self.currentOptions count]>0) {
        NSDictionary *packageInfo = [self.currentOptions objectForKey:@"packageInfo"];
        if ([packageInfo count]>0) {
            NSString *originMD5 = [packageInfo objectForKey:@"md5"];
            if (computedFileMD5 && originMD5 && [computedFileMD5 isEqualToString:originMD5]) {
                flag = YES;
            }
        }
    }
    return flag;
}

@end

//
//  UCXAppConfiguration.h
//  Pods
//
//  Created by huyujin on 2017/8/25.
//
//

#import <Foundation/Foundation.h>

@interface UCXAppConfiguration : NSObject

/**
 * @abstract 本地存储版本历史最大数,默认值为2
 */
+ (NSInteger)maxCacheVersionNumber;
+(void)setMaxCacheVersionNumber:(NSInteger)number;

#pragma mark - 业务配置相关
/**
 * @abstract Group or organization of your app, default value is nil.
 */
+ (NSString *)appGroup;
+ (void)setAppGroup:(NSString *) appGroup;

/**
 * @abstract Name of your app, default is value for CFBundleDisplayName in main bundle.
 */
+ (NSString *)appName;
+ (void)setAppName:(NSString *)appName;

/**
 * @abstract Version of your app, default is value for CFBundleShortVersionString in main bundle.
 */
+ (NSString *)appVersion;
+ (void)setAppVersion:(NSString *)appVersion;

#pragma mark - 路径相关
/**
 * cache path
    "../../"
 */
+ (NSString *)cachePath;

/**
 * @abstract  bundlejs path
    "../../jsBundle"
 */
+ (NSString *)jsBundlePath;

/** 
 * image path
    "../../res/image"
 */
+ (NSString *)imagePath;


@end

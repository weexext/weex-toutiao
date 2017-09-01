//
//  UCXUtil.m
//  WeexDemo
//
//  Created by huyujin on 2017/8/4.
//  Copyright © 2017年 ucarinc. All rights reserved.
//

#import "UCXUtil.h"
#import <CommonCrypto/CommonDigest.h>

@interface UCXUtil ()

@end

@implementation UCXUtil

#pragma mark -
// 下载保存路径
+ (NSString *)downloadDir
{
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *downloadDir = [directory stringByAppendingPathComponent:@"ucarweex"];
    
    return downloadDir;
}

#pragma mark -
// 获取当前时间
+ (NSString *)currentDateStr{
    NSDate *currentDate = [NSDate date]; //获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYYMMddhhmmss"]; //设定时间格式,这里可以设置成自己需要的格式
    NSString *dateStr = [dateFormatter stringFromDate:currentDate];//将时间转化成字符串
    return dateStr;
}

// 异常信息封装
+ (NSError *)errorWithMessage:(NSString *)errorMessage {
    return [NSError errorWithDomain:@"weex.ucar.error"
                               code:-1
                           userInfo:@{ NSLocalizedDescriptionKey: errorMessage}];
}

#pragma mark -
//字典转json格式字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dict {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//json格式字符串转字典
+ (NSDictionary *)dictionaryWithJson:(NSString *)jsonStr {
    if (!jsonStr) {
        return nil;
    }
    //
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if(error) {
        NSLog(@"json解析失败：%@", error);
        return nil;
    }
    return dict;
}

#pragma mark -
//urlEncode
+ (NSString *)urlEncode:(NSString *)url {
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                     (__bridge CFStringRef)url,
                                                                     NULL,
                                                                     CFSTR("!*'\"();:@&=+$,/?%#[]"),
                                                                     kCFStringEncodingUTF8));
}

#pragma mark - 

// get the md5 string for a file
+ (NSString *)fileMD5:(NSString *)filePath {
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if(!handle)
    {
        return nil;
    }
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while (!done)
    {
        NSData *fileData = [handle readDataOfLength:256];
        CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
        if([fileData length] == 0)
        done = YES;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    
    NSString *result = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                        digest[0], digest[1],
                        digest[2], digest[3],
                        digest[4], digest[5],
                        digest[6], digest[7],
                        digest[8], digest[9],
                        digest[10], digest[11],
                        digest[12], digest[13],
                        digest[14], digest[15]];
    return result;
}

#pragma mark -
// uicolor
+ (UIColor *)colorWithHexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [[self class] colorComponentFrom: colorString start: 0 length: 1];
            green = [[self class] colorComponentFrom: colorString start: 1 length: 1];
            blue  = [[self class] colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [[self class] colorComponentFrom: colorString start: 0 length: 1];
            red   = [[self class] colorComponentFrom: colorString start: 1 length: 1];
            green = [[self class] colorComponentFrom: colorString start: 2 length: 1];
            blue  = [[self class] colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [[self class] colorComponentFrom: colorString start: 0 length: 2];
            green = [[self class] colorComponentFrom: colorString start: 2 length: 2];
            blue  = [[self class] colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [[self class] colorComponentFrom: colorString start: 0 length: 2];
            red   = [[self class] colorComponentFrom: colorString start: 2 length: 2];
            green = [[self class] colorComponentFrom: colorString start: 4 length: 2];
            blue  = [[self class] colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            return nil;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat)colorComponentFrom: (NSString *)string start: (NSUInteger)start length: (NSUInteger)length {
    
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    
    return hexComponent / 255.0;
}

@end

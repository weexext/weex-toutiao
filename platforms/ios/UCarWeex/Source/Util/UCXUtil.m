//
//  UCXUtil.m
//  WeexDemo
//
//  Created by huyujin on 2017/8/4.
//  Copyright © 2017年 ucarinc. All rights reserved.
//

#import "UCXUtil.h"

@interface UCXUtil ()

@end

@implementation UCXUtil

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

//urlEncode
+ (NSString *)urlEncode:(NSString *)url {
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                     (__bridge CFStringRef)url,
                                                                     NULL,
                                                                     CFSTR("!*'\"();:@&=+$,/?%#[]"),
                                                                     kCFStringEncodingUTF8));
}


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

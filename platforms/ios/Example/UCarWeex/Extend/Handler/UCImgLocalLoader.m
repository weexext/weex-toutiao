//
//  UCImgLocalLoader.m
//  Portal
//
//  Created by huyujin on 2017/5/17.
//  Copyright © 2017年 ucarinc. All rights reserved.
//

#import "UCImgLocalLoader.h"

@implementation UCImgLocalLoader

- (void)cancel {
    
}

+ (id<WXImageOperationProtocol>)loadLocalImge:(NSString *)imgURL completed:(void(^)(UIImage *image,  NSError *error, BOOL finished))completedBlock {
    UCImgLocalLoader *imgLocalLoader = [UCImgLocalLoader new];
    //
    UIImage *img = nil;
    NSString *URLPrefix = @"file:///";
    NSString *UCURLPrefix = @"assets:///image/";
    if ([imgURL hasPrefix:UCURLPrefix]) {
        NSString *imgName = [imgURL substringFromIndex:UCURLPrefix.length];
        img = [[self class] uc_imageFromName:imgName];
    } else { //其他非固定路径存放的图片
        NSString *imgName = [imgURL substringFromIndex:URLPrefix.length];
        img = [UIImage imageWithContentsOfFile:imgName];
    }
    
    if (img) {
        completedBlock(img,nil,YES);
    } else {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{}];
        completedBlock(nil,error,YES);
    }
    return imgLocalLoader;
}

#pragma mark -
+ (UIImage*)uc_imageFromName:(NSString*)name
{
    //xcode group
    UIImage *img = [UIImage imageNamed:name];
    if (!img) { //兼容不在 mainBundle 里的图片
        //folder reference,查找相对位置
        NSString *relativePath = [NSString stringWithFormat:@"assets/image/%@",name];
        img = [UIImage imageNamed:relativePath];
        if (!img) {
            //TODO::其他方式引入...
            /* get media folder:图片默认存放路径 */
            NSString *mediaDir = UC_DOCUMENT_PATH;
            NSString *path = [mediaDir stringByAppendingPathComponent:relativePath];
            path = [self relativePathToMainBundle:path];
            img = [UIImage imageNamed:path];
        }
    }
    
    return img;
}

+ (NSString*)relativePathToMainBundle:(NSString*)path
{
    NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *appDirectory = [mainBundlePath stringByDeletingLastPathComponent];
    NSString *relativePath = [path stringByReplacingOccurrencesOfString:appDirectory withString:@".."];
    return relativePath;
}

@end

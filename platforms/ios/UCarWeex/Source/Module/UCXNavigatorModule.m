//
//  UCXNavigatorModule.m
//  WeexDemo
//
//  Created by huyujin on 2017/8/4.
//  Copyright © 2017年 ucarinc. All rights reserved.
//

#import "UCXNavigatorModule.h"
#import "UCXUtil.h"
#import "UCXBaseViewController.h"
#import <WeexSDK/WeexSDK.h>

typedef void (^UCXNavigationResultBlock)(NSString *code, NSDictionary * responseData);

@interface UCXNavigatorModule ()

@end

@implementation UCXNavigatorModule
@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(push:callback:))
WX_EXPORT_METHOD(@selector(pop:callback:))
WX_EXPORT_METHOD(@selector(home:callback:))


- (void)push:(NSDictionary *)options callback:(WXModuleCallback)callback
{
    // url
    NSString *url = [options objectForKey:@"url"];
    if ([options count]==0 || !url) {
        callback(MSG_PARAM_ERR);
        return;
    }
    // param
    NSDictionary *param = [options objectForKey:@"param"];
    if ([param count]>0) {
        //追加到url后面 & 编码
        NSString *paramStr = [UCXUtil dictionaryToJson:param];
        paramStr = [UCXUtil urlEncode:paramStr];
        url = [NSString stringWithFormat:@"%@?param=%@",url,paramStr];
    }
    // navBar
    NSDictionary *navBarDict = [options objectForKey:@"navBar"];
    
    // animated
    BOOL animated = YES;
    NSString *obj = [[options objectForKey:@"animated"] lowercaseString];
    if (obj && [obj isEqualToString:@"false"]) {
        animated = NO;
    }
    // push
    UIViewController *container = self.weexInstance.viewController;
    UCXBaseViewController *vc = [[UCXBaseViewController alloc] initWithSourceURL:[NSURL URLWithString:url]];
    vc.options = options;
    vc.hidesBottomBarWhenPushed = YES;
    [container.navigationController pushViewController:vc animated:animated];
    callback(MSG_SUCCESS);
}

- (void)pop:(NSDictionary *)options callback:(WXModuleCallback)callback {
    //index
    NSNumber *index = [options objectForKey:@"index"];
    NSInteger indexValue = index ? [index integerValue]:-1;
    indexValue = labs(indexValue);
    //tagCode
    NSString *tagCode = [options objectForKey:@"tagCode"];
    //param
    NSDictionary *param = [options objectForKey:@"param"];
    if (param && [param count]>0) {
        if (tagCode) {
            [self postGlobalEvent:tagCode params:param];
        }else {
            WXLogError(@"tagcode 缺失，无法回传参数.");
        }
    }
    //animated
    BOOL animated = YES;
    id obj = [options objectForKey:@"animated"];
    if (obj) {
        animated = [WXConvert BOOL:obj];
    }
    //pop
    UINavigationController *nav = self.weexInstance.viewController.navigationController;
    NSArray *arr = nav.viewControllers;
    //若索引值超出范围，则不作处理
    if (indexValue>arr.count-1) {
        WXLogError(@"navigator 堆栈参数有误.");
        callback(MSG_FAILED);
        return;
    }
    UCXBaseViewController *vc = arr[arr.count-(indexValue+1)];
    if (param && [param count]>0) { // 回调函数
        NSDictionary *tmp = @{@"tagCode":tagCode,@"param":param};
        vc.callback(tmp);
    }
    [nav popToViewController:vc animated:animated];
    
    callback(MSG_SUCCESS);
}

- (void)home:(NSDictionary *)options callback:(WXModuleCallback)callback {
    //TODO::options
    
    UIViewController *container = self.weexInstance.viewController;
    [container.navigationController popToRootViewControllerAnimated:YES];
    callback(MSG_SUCCESS);
}

#pragma mark - private method
- (void)callback:(UCXNavigationResultBlock)block code:(NSString *)code data:(NSDictionary *)reposonData
{
    if (block) {
        block(code, reposonData);
    }
}

- (void)postGlobalEvent:(NSString *)eventName params:(NSDictionary *)params {
    if (!params){
        params = [NSDictionary dictionary];
    }
    NSDictionary * userInfo = @{@"param":params};
    [[NSNotificationCenter defaultCenter] postNotificationName:eventName object:self userInfo:userInfo];
}

@end

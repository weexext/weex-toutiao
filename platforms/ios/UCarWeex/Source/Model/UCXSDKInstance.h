//
//  UCXSDKInstance.h
//  Pods
//
//  Created by huyujin on 2017/8/17.
//  Copyright © 2017年 ucarinc. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * The state of current instance.
 **/
typedef NS_ENUM(NSInteger, UCXState) {//state.code
    UCXWeexInstanceReady = 1000,
    UCXWeexInstanceActived,
    UCXWeexInstanceDeactived,
};

@interface UCXSDKInstance : NSObject

@end

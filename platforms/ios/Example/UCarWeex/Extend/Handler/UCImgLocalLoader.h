//
//  UCImgLocalLoader.h
//  Portal
//
//  Created by huyujin on 2017/5/17.
//  Copyright © 2017年 ucarinc. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <UCarWeex/WXImgLoaderProtocol.h>
#import <WeexSDK/WXImgLoaderProtocol.h>

@interface UCImgLocalLoader : NSObject<WXImageOperationProtocol>

+ (id<WXImageOperationProtocol>)loadLocalImge:(NSString *)url completed:(void(^)(UIImage *image,  NSError *error, BOOL finished))completedBlock;

@end

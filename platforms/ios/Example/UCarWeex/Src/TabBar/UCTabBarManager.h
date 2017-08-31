//
//  UCXTabBarManager.h
//  UCarWeex
//
//  Created by huyujin on 2017/8/11.
//  Copyright © 2017年 hyj223. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CYLTabBarController/CYLTabBarController.h>

@interface UCTabBarManager : NSObject

+ (instancetype)shared;

- (CYLTabBarController *)setupTabBarController;

@end

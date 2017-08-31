//
//  UCXTabBarManager.m
//  UCarWeex
//
//  Created by huyujin on 2017/8/11.
//  Copyright © 2017年 hyj223. All rights reserved.
//

#import "UCTabBarManager.h"
#import "UCHomeViewController.h"
#import "UCMineViewController.h"
#import "UCBaseNavigationController.h"

@interface UCTabBarManager ()

@property (nonatomic, strong) CYLTabBarController *tabBarController;

@end

@implementation UCTabBarManager

+ (instancetype)shared {
    
    static dispatch_once_t once = 0;
    static UCTabBarManager *instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (CYLTabBarController *)setupTabBarController {
    
    UCHomeViewController *homeVC = [[UCHomeViewController alloc] init];
    UIViewController *homeNavigationController = [[UCBaseNavigationController alloc] initWithRootViewController:homeVC];
    
    UCMineViewController *mineVC = [[UCMineViewController alloc] init];
    UIViewController *mineNavigationController = [[UCBaseNavigationController alloc] initWithRootViewController:mineVC];
    
    NSArray *viewControllers = @[homeNavigationController,mineNavigationController];
    NSArray *tabBarItemsAttributes = [self customizeTabBarItemsAttributes];
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
    UIOffset titlePositionAdjustment = UIOffsetMake(0, -2);
    
    CYLTabBarController *tabBarController = [[CYLTabBarController alloc] initWithViewControllers:viewControllers tabBarItemsAttributes:tabBarItemsAttributes imageInsets:imageInsets titlePositionAdjustment:titlePositionAdjustment];
//    tabBarController.tabBarHeight = 49.f;
    //
    
    self.tabBarController = tabBarController;
//    self.tabBarController.selectedIndex = 1;
    
    return self.tabBarController;
    
}


/**
 * 在`-setViewControllers:`之前设置TabBar的属性，
 **/
- (NSArray *)customizeTabBarItemsAttributes {
    
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : @"首页",
//                            CYLTabBarItemImage : @"tabbar_notice_unselected",
//                            CYLTabBarItemSelectedImage : @"tabbar_notice_selected",
                            };
    NSDictionary *dict2 = @{
                            CYLTabBarItemTitle : @"我的",
//                            CYLTabBarItemImage : @"tabbar_mine_unselected",
//                            CYLTabBarItemSelectedImage : @"tabbar_mine_selected",
                            };
    
    NSArray *tabBarItemsAttributes = @[dict1,dict2];
    return tabBarItemsAttributes;
}


@end

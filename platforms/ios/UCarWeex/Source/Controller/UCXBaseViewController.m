//
//  UCXBaseViewController.m
//  WeexDemo
//
//  Created by huyujin on 2017/8/4.
//  Copyright © 2017年 ucarinc. All rights reserved.
//

#import "UCXBaseViewController.h"
#import "UCXUtil.h"

@interface UCXBaseViewController ()

@end

@implementation UCXBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 模拟导航栏
    [self addFakeNavBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addFakeNavBar {
    if ([self.dict count]>0) {
        CGFloat height = [[self.dict objectForKey:@"height"] floatValue];
        NSString *backgroundColor = [self.dict objectForKey:@"backgroundColor"];
        //
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        height = height>0.f ? height: 64.f;
        UIView *fakeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        if (backgroundColor) {
            [fakeView setBackgroundColor:[UCXUtil colorWithHexString:backgroundColor]];
        }
        [self.view addSubview:fakeView];
    }
}


@end

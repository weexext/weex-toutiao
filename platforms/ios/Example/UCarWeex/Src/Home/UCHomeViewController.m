//
//  UCXHomeViewController.m
//  UCarWeex
//
//  Created by huyujin on 2017/8/11.
//  Copyright © 2017年 hyj223. All rights reserved.
//

#import "UCHomeViewController.h"
#import <UCarWeex/UCarWeex.h>

@interface UCHomeViewController ()

@property (nonatomic, strong) UIButton *linkBtn;

@end

@implementation UCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"首页";
    
    [self createSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void)createSubviews {
    self.linkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.linkBtn];
    [self.linkBtn setTitle:@"进入WEEX页面" forState:UIControlStateNormal];
    [self.linkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.linkBtn setBackgroundColor:[UIColor colorWithHexString:@"#66B3FF"]];
    self.linkBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.linkBtn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self createAutoLayouts];
}

- (void)createAutoLayouts {
    [self.linkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(0.f);
        make.centerY.equalTo(self.view.mas_centerY).offset(0.f);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.5);
        make.height.equalTo(@(50.f));
    }];
}

- (void)btnClicked {
    NSLog(@"btn clicked");
    //
    NSString *relativePath = @"index.js";
    NSURL *url = [NSURL URLWithString:[self routerWithRelativePath:relativePath]];
    
    UCXBaseViewController *vc = [[UCXBaseViewController alloc] initWithSourceURL:url];
    NSDictionary *dict = @{@"height":@"64",@"backgroundColor":@"#3e50b5"};
    vc.dict = dict;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
- (NSString *)routerWithRelativePath:(NSString *)relativePath {
    // 1:远程 0：本地
    NSString *urlStr = relativePath;
    if (UC_JS_LOAD_TYPE) {
        urlStr = [NSString stringWithFormat:@"http://%@:12588/dist/native/views/%@",LOCAL_IP, relativePath];
    }else {
        urlStr = [NSString stringWithFormat:@"file://%@/bundlejs/views/%@",[NSBundle mainBundle].bundlePath, relativePath];
    }
    return urlStr;
}


@end

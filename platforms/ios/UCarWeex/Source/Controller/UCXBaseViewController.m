/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

#import <WeexSDK/WeexSDK.h>

#import "UCXBaseViewController.h"
#import "UCXUtil.h"
#import "UCXSDKInstance.h"

@interface UCXBaseViewController ()

@property (nonatomic, strong) WXSDKInstance *instance;
@property (nonatomic, strong) UIView *weexView;
@property (nonatomic, strong) NSURL *sourceURL;

/***/
@property (nonatomic, strong) NSString *tagCode;
@property (nonatomic, strong) NSMutableDictionary *param; //页面传参
@property (nonatomic, strong) NSMutableDictionary *paramWrapper; // 页面传参封装

@end

@implementation UCXBaseViewController

- (void)dealloc
{
    [_instance destroyInstance];
    [self _removeObservers];
}

- (instancetype)initWithSourceURL:(NSURL *)sourceURL
{
    if ((self = [super init])) {
        self.sourceURL = sourceURL;
        self.hidesBottomBarWhenPushed = YES;
        
        [self _addObservers];
    }
    return self;
}

/**
 *  After setting the navbar hidden status , this function will be called automatically. In this function, we
 *  set the height of mainView equal to screen height, because there is something wrong with the layout of
 *  page content.
 */

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if ([self.navigationController isKindOfClass:[WXRootViewController class]]) {
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }
}

/**
 *  We assume that the initial state of viewController's navigtionBar is hidden.  By setting the attribute of
 *  'dataRole' equal to 'navbar', the navigationBar hidden will be NO.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self _renderWithURL:_sourceURL];
    if ([self.navigationController isKindOfClass:[WXRootViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
    // 处理数据
    [self configCustomData];
    // 模拟导航栏
    [self addFakeNavBar];
    //
    [self receiveNoti:self.tagCode];
    //
//    [self ucx_updateInstanceState:UCXWeexInstanceReady];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self _updateInstanceState:WeexInstanceAppear];
    
    //接收参数
    __weak typeof(self) weakSelf = self;
    _callback = ^(NSDictionary *dict) {
        if ([dict count]>0) {
            weakSelf.param = [dict objectForKey:@"param"];
            weakSelf.paramWrapper = [dict mutableCopy];
        }
    };
    //
    [self ucx_updateInstanceState:UCXWeexInstanceActived];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self _updateInstanceState:WeexInstanceDisappear];
    
    //
    [self ucx_updateInstanceState:UCXWeexInstanceDeactived];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self _updateInstanceState:WeexInstanceMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshWeex
{
    [self _renderWithURL:_sourceURL];
}

- (void)_renderWithURL:(NSURL *)sourceURL
{
    if (!sourceURL) {
        return;
    }
    
    [_instance destroyInstance];
    if([WXPrerenderManager isTaskExist:[self.sourceURL absoluteString]]){
        _instance = [WXPrerenderManager instanceFromUrl:self.sourceURL.absoluteString];
    }
    
    _instance = [[WXSDKInstance alloc] init];
    _instance.frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height);
    _instance.pageObject = self;
    _instance.pageName = sourceURL.absoluteString;
    _instance.viewController = self;
    
    NSString *newURL = nil;
    
    if ([sourceURL.absoluteString rangeOfString:@"?"].location != NSNotFound) {
        newURL = [NSString stringWithFormat:@"%@&random=%d", sourceURL.absoluteString, arc4random()];
    } else {
        newURL = [NSString stringWithFormat:@"%@?random=%d", sourceURL.absoluteString, arc4random()];
    }
    [_instance renderWithURL:[NSURL URLWithString:newURL] options:@{@"bundleUrl":sourceURL.absoluteString} data:nil];
    
    __weak typeof(self) weakSelf = self;
    _instance.onCreate = ^(UIView *view) {
        [weakSelf.weexView removeFromSuperview];
        weakSelf.weexView = view;
        [weakSelf.view addSubview:weakSelf.weexView];
    };
    
    _instance.onFailed = ^(NSError *error) {
        
    };
    
    _instance.renderFinish = ^(UIView *view) {
        [weakSelf _updateInstanceState:WeexInstanceAppear];
        //
        [weakSelf ucx_updateInstanceState:UCXWeexInstanceReady];
    };
    
    if([WXPrerenderManager isTaskExist:[self.sourceURL absoluteString]]){
        WX_MONITOR_INSTANCE_PERF_START(WXPTJSDownload, _instance);
        WX_MONITOR_INSTANCE_PERF_END(WXPTJSDownload, _instance);
        WX_MONITOR_INSTANCE_PERF_START(WXPTFirstScreenRender, _instance);
        WX_MONITOR_INSTANCE_PERF_START(WXPTAllRender, _instance);
        [WXPrerenderManager renderFromCache:[self.sourceURL absoluteString]];
        return;
    }
}

- (void)_updateInstanceState:(WXState)state
{
    if (_instance && _instance.state != state) {
        _instance.state = state;
        
        if (state == WeexInstanceAppear) {
            [[WXSDKManager bridgeMgr] fireEvent:_instance.instanceId ref:WX_SDK_ROOT_REF type:@"viewappear" params:nil domChanges:nil];
        } else if (state == WeexInstanceDisappear) {
            [[WXSDKManager bridgeMgr] fireEvent:_instance.instanceId ref:WX_SDK_ROOT_REF type:@"viewdisappear" params:nil domChanges:nil];
        }
    }
}

- (void)_appStateDidChange:(NSNotification *)notify
{
    if ([notify.name isEqualToString:@"UIApplicationDidBecomeActiveNotification"]) {
        [self _updateInstanceState:WeexInstanceForeground];
    } else if([notify.name isEqualToString:@"UIApplicationDidEnterBackgroundNotification"]) {
        [self _updateInstanceState:WeexInstanceBackground]; ;
    }
}

- (void)_addObservers
{
    for (NSString *name in @[UIApplicationDidBecomeActiveNotification,
                             UIApplicationDidEnterBackgroundNotification]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_appStateDidChange:)
                                                     name:name
                                                   object:nil];
    }
}

- (void)_removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -

- (void)configCustomData {
    // param
    NSDictionary *param = [self.options objectForKey:@"param"];
    if ([param count]>0) {
        self.param = [param mutableCopy];
        self.paramWrapper = @{@"param":self.param};
    }
}

- (void)addFakeNavBar {
    // navBar
    NSDictionary *navBarDict = [self.options objectForKey:@"navBar"];
    if ([navBarDict count]>0) {
        CGFloat height = [[navBarDict objectForKey:@"height"] floatValue];
        NSString *backgroundColor = [navBarDict objectForKey:@"backgroundColor"];
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

- (void)ucx_updateInstanceState:(WXState)state
{
    if (_instance && _instance.state != state) {
        _instance.state = state;
        
        if (state == UCXWeexInstanceReady) {
            [[WXSDKManager bridgeMgr] fireEvent:_instance.instanceId ref:WX_SDK_ROOT_REF type:@"ready" params:self.paramWrapper domChanges:nil];
        } else if (state == UCXWeexInstanceActived) {
            //用来区分是否是POP返回的数据,根据tagCode值来做区分
            NSDictionary *params = nil;
            if ([self.paramWrapper count]>0) {
                NSString *tagCode = [self.paramWrapper objectForKey:@"tagCode"];
                if (tagCode) {
                    params = [self.paramWrapper copy];
                }
            }
            [[WXSDKManager bridgeMgr] fireEvent:_instance.instanceId ref:WX_SDK_ROOT_REF type:@"actived" params:params domChanges:nil];
        }else if (state==UCXWeexInstanceDeactived) {
            [[WXSDKManager bridgeMgr] fireEvent:_instance.instanceId ref:WX_SDK_ROOT_REF type:@"deactived" params:nil domChanges:nil];
        }
    }
}

#pragma mark -
- (void)receiveNoti:(NSString *)notificationName {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNoti:) name:notificationName object:nil];
}

- (void)handleNoti:(NSNotification *)noti {
    
}

@end

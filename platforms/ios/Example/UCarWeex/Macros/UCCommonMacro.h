//
//  UCCommonMacro.h
//  Portal
//
//  Created by huyujin on 2017/8/11.
//  Copyright © 2017年 ucarinc. All rights reserved.
//

#ifndef UCCommonMacro_h
#define UCCommonMacro_h

#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_NAME    [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]

//获取沙盒 Document
#define UC_DOCUMENT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

#endif /* UCCommonMacro_h */

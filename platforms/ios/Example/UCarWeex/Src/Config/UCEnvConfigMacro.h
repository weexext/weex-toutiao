//
//  UCEnvConfigMacro.h
//  UCarWeex
//
//  Created by huyujin on 2017/7/21.
//  Copyright © 2017年 ucarinc. All rights reserved.
//
//  NOTE::可配置项放到专门的文件进行管理

#ifndef UCEnvConfigMacro_h
#define UCEnvConfigMacro_h

//=========================  ======================================
// 本地IP
#define UC_LOCAL_IP @"10.99.21.32"
// 本地web服务对应端口
#define UC_LOCAL_WEB_PORT @"12570"
// 本地 weexdebug服务对应端口
#define UC_LOCAL_WEEX_PORT @"8088"

//========================== DEBUG模式:  默认加载远程js ===========================
//========================== RELEASE模式:默认加载本地js ===========================
#ifdef DEBUG
//#define UC_JS_LOAD_TYPE 0  // 本地
#define UC_JS_LOAD_TYPE 1  // 远程
#else
#define UC_JS_LOAD_TYPE 0  // 本地
#endif

//==========================WEEX DEBUG模式：是否开启 ==============================================
#define UC_WEEX_DEBUG_MODE 1 //开启weex debug调试
//#define UC_WEEX_DEBUG_MODE 0 //关闭weex debug调试



#endif /* UCEnvConfigMacro_h */

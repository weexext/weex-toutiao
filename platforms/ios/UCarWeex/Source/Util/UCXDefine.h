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

#ifndef __UCX_DEFINE_H__
#define __UCX_DEFINE_H__

//////////////////////////////////////////////////////////////
#ifdef DEBUG
#define UCXLog(...) printf("[%s] %s [第%d行]: %s\n", __TIME__ ,__PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#define UCXLog(...)
#endif

//////////////////////////////////////////////////////////////
// userdefauts 存储 ucarweex 每次更新包信息 key
#define UCX_US_UCAR_WEEX_KEY @"UCX_US_UCAR_WEEX_KEY"
#define UCX_UNZIP_FILE_PATH  @"unzipFilePath"


//////////////////////////////////////////////////////////////
// error def
static NSString * const UCX_ERROR_OPTIONS = @"options error";
static NSString * const UCX_ERROR_FILE_OPERATION = @"file operation error";
static NSString * const UCX_ERROR_FILE_VALIDATE = @"file validate error";
static NSString * const UCX_ERROR_JSON_PARSE = @"json parse error";
static NSString * const UCX_ERROR_INVALIDATE_PARAM = @"options error";

#endif

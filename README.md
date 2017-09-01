# toutiao -weex 

> 基于WEEX +Vue2.0仿照今日头条的app项目(android/ios)

源码地址：[toutiao_weex](https://github.com/weexext/weex-toutiao)

Apk地址：[android-demo](https://github.com/weexext/weex-toutiao/blob/master/app-debug.apk?raw=true)

## 前言



之前打算做个东西熟悉vue的使用，由于自己蛮喜欢刷手机看看新闻的，借鉴了其他同学的项目（链接在下面），自己也做了一个。项目中还有许多可以完善的地方，不足之处希望小伙伴们可以issue，我会在这里更新。目前还没有全面地测试该项目，有问题提问，大家一起学习。

## 技术栈

1. 主要用到：vue、weex android ios

## 功能

- 各类新闻的查看
- 本地收藏新闻
- 新闻的搜索
- 待...

## 效果

![entry](https://github.com/weexext/weex-toutiao/blob/master/capture/v_02.gif?raw=true)

![collect](https://github.com/weexext/weex-toutiao/blob/master/capture/home.png)

![detail](https://github.com/weexext/weex-toutiao/blob/master/capture/detail.png)


## 目录
```
|- src
   |- assets
      |- image                   // 项目图片
      |- font                    // iconfont字体库
   |- include                    // 组件
      |- navbar.vue              // 导航
      |- tabbar.vue              // 底部导航
   |- views                      // 主体页面
      |- index.vue               // 主体页面
      |- Detail.vue              // 详情页
      |- Care.vue                // 关注页
      |- Home.vue                // 主页
      |- My.vue                  // 段子页
   |- manifast.json              // 清单文件
|- tools
   |- android                    // android copy
   |- iso                        // ios copy
   |- packzip.js                 // 打包
```
更多细节在源码中会有一些注释
## API
1. 获取新闻：`https://m.toutiao.com/list/?tag=新闻类型&ac=wap&count=20&format=json_raw&as=A125A8CEDCF8987&cp=58EC18F948F79E1&min_behot_time=时间`

2. 获取文章：`https://m.toutiao.com/i新闻ID/info/'`

3. 获取段子：`https://www.toutiao.com/api/article/feed/?category=essay_joke&utm_source=toutiao&widen=1&max_behot_time=1500114422&max_behot_time_tmp=1500114422&tadrequire=true&as=A1F52966E9EEF00&cp=59692E6FD0E09E1`

4. 搜索： `https://www.toutiao.com/search_content/?offset=相对位置&format=json&keyword=关键词&autoload=true&count=20&cur_tab=1`

还可以参考[今日头条Api分析](https://github.com/iMeiji/Toutiao/wiki/%E4%BB%8A%E6%97%A5%E5%A4%B4%E6%9D%A1Api%E5%88%86%E6%9E%90)


Ps：多star多动力[捂脸]

## 参考

[u-weex开源地址](https://github.com/weexext)
[u-weex开源地址wiki](https://github.com/weexext/weex-ext-wiki/wiki)
[toutiao_Vue2.0的项目](https://github.com/Huahua-Chen/toutiao_Vue2.0)


## Build Setup

#### android
``` bash

npm install

npm run build

npm run packzip

npm run copy:android

cd platforms/android

gradle iD

```

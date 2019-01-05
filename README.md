#ios
CCios
一、项目目录结构
Classes（项目主目录）
     ——AppDelegate   （appdelegate文件夹） 存放appdelegate、及其分类。
     ——Vendorse     （第三方文件夹） 存放第三方文件。
     ——Sceenes      （场景文件夹）  每个功能模块都创建在这个目录下。
     ——Resources   （资源文件夹）  存放图片、音频、视频等本地资源。
     ——Models          (共用model文件夹)   存放共用、全局model。
     ——Common     （通用文件夹）    存放分类、公用类等文件。
                -->Categories  (分类)                存放各种分类。
      ——Macro            (宏定义文件夹)   存放各种宏定义文件、头文件。
      ——Helpers        （帮助类文件夹）存放Manager、Helpers类。
      ——NET        网络请求。
      
SupportingFiles    存放pch文件、 及其他项目配置文件。

二、项目注意事项


七牛SDK编辑网络URL视频 时间减去0.1秒
NSNumber *num = [NSNumber numberWithFloat:CMTimeGetSeconds(asset.duration) -0.1];
plsMovieSettings[PLSDurationKey] = num;



滤镜顺序
{
"filters": [
{
"name": "原色",
"dir": "normal",
"category": "default"
},
{
"name": "黑白",
"dir": "1960s",
"category": "default"
},
{
"name": "甘菊",
"dir": "camomile",
"category": "default"
},
{
"name": "糖果",
"dir": "candy",
"category": "default"
},
{
"name": "冷色",
"dir": "cold",
"category": "default"
},
{
"name": "暗色",
"dir": "dark",
"category": "default"
},
{
"name": "梦幻",
"dir": "dreamy",
"category": "default"
},
{
"name": "优雅",
"dir": "elegance",
"category": "default"
},
{
"name": "青涩",
"dir": "frog",
"category": "default"
},
{
"name": "时髦",
"dir": "funky",
"category": "default"
},
{
"name": "漂亮",
"dir": "good",
"category": "default"
},
{
"name": "灰色",
"dir": "gray",
"category": "default"
},
{
"name": "哈瓦那",
"dir": "habana",
"category": "default"
},
{
"name": "快乐",
"dir": "happy",
"category": "default"
},
{
"name": "收获",
"dir": "harvest",
"category": "default"
},
{
"name": "旅行",
"dir": "kc",
"category": "default"
},
{
"name": "蓝紫色",
"dir": "lyon",
"category": "default"
},
{
"name": "零点",
"dir": "lzp",
"category": "default"
},
{
"name": "心念",
"dir": "miss",
"category": "default"
},
{
"name": "模糊",
"dir": "misty",
"category": "default"
},
{
"name": "拍立得",
"dir": "pailide",
"category": "default"
},
{
"name": "粉红",
"dir": "pink",
"category": "default"
},
{
"name": "拍立",
"dir": "pld",
"category": "default"
},
{
"name": "胶片",
"dir": "print",
"category": "default"
},
{
"name": "紫色",
"dir": "purple",
"category": "default"
},
{
"name": "旅行",
"dir": "railway",
"category": "default"
},
{
"name": "红色",
"dir": "red",
"category": "default"
},
{
"name": "怀旧",
"dir": "retro",
"category": "default"
},
{
"name": "和煦",
"dir": "sunny",
"category": "default"
},
{
"name": "高雅",
"dir": "tasty",
"category": "default"
},
{
"name": "青花瓷",
"dir": "turkish",
"category": "default"
},
{
"name": "华尔兹",
"dir": "waltz",
"category": "default"
},
{
"name": "西方",
"dir": "west",
"category": "default"
},
]
}

<template>
    <div class="container">
        <div class="home-header-bar">
            <div class="center-title">
                <text class="center-text">今日头条</text>
            </div>
        </div>
        <scroller scroll-direction="horizontal" class="scroller">
            <div class="row" v-for="(item , index) in navbar" @click="navClick(item)">
                <text v-if="item.clicked" class="navBarLiClicked">{{item.text}}
                </text>
                <text v-if="!item.clicked" class="navBarLi">{{item.text}}
                </text>
            </div>
        </scroller>
        <list class="list">
            <refresh class="loading-view" @refresh="onrefresh" :display="refresh_display">
                <loading-indicator style="height: 60px; width: 60px;"></loading-indicator>
            </refresh>
            <cell v-for="item in resData" @click="onItemClick(item)">
                <div class="cell_body">
                    <text class="title">{{item.title}}</text>
                    <div class="bottomInfo">
                        <Icon type="fireball" size="10" color="#d43d3d" v-show="item.hot===1"></Icon>
                        <text class="avIcon" v-show="item.label==='广告'">广告</text>
                        <text v-if="item.media_name" class="writer" style="margin-right: 50px">{{item.media_name}}
                        </text>
                        <text class="comment_count" style="flex: 1">评论&nbsp;{{item.comment_count}}</text>
                        <text class="datetime">{{item.datetime|date}}</text>
                    </div>
                    <div style="background-color: #999 ;height: 1px; flex: 1 ;margin-top: 20px"/>
                </div>
            </cell>
            <loading class="loading-view" :display="loading_display" @loading="onloading">
                <loading-indicator style="height: 60px; width: 60px;"></loading-indicator>
            </loading>
        </list>
    </div>
</template>
<style scoped>
    .list {
        flex-direction: column;
        background-color: #fbfbfb;
    }

    .title {
        font-size: 28px;
        color: #000;
        font-weight: bold;
    }

    .cell_body {
        margin: 25px;
        flex-direction: column;
    }

    .bottomInfo {
        flex-direction: row;
        margin-top: 30px;
    }

    .writer {
        color: #000;
    }

    .comment_count {
        color: #000;
    }

    .datetime {
        float: right;
        color: #000;
    }

    .avIcon {
        display: inline-block;
        height: 0.4rem;
        width: 0.9rem;
        text-align: center;
        line-height: 0.4rem;
        border-radius: 4px;
        border: 1px solid #39f;
        font-size: 10px;
        margin-right: 0.1rem;
    }

    .loading-view {
        height: 80px;
        width: 750px;
        justify-content: center;
        align-items: center;
        background-color: #c0c0c0;
    }

    .scroller {
        width: 750px;
        height: 80px;
        flex-direction: row;
    }

    .row {
        padding-left: 25px;
        height: 80px;
        border-bottom-width: 2px;
        border-bottom-style: solid;
        border-bottom-color: #DDDDDD;
    }

    .navBarLiClicked {
        color: #d43d3d;
        margin-top: 20px;
        font-size: 34px;
    }

    .navBarLi {
        margin-top: 20px;
        font-size: 34px;
    }

    .container {
        background-color: #fbfbfb;
        flex-direction: column;
    }

    .home-header-bar {
        height: 100px;
        width: 750px;
        flex-direction: row;
        align-items: center;
        background-color: #d43d3d;

    }

    .center-title {
        position: absolute;
        left: 172px;
        right: 172px;
        flex-direction: row;
        align-items: center;
        justify-content: center;
        top: 25px
    }

    .center-text {
        text-align: center;
        font-size: 36px;
        color: white;
        font-weight: bold;
    }
</style>
<script>
    import  config from '../config/index'
    var modal = weex.requireModule('modal')
    var stream = weex.requireModule('stream')
    var storage = weex.requireModule('storage')
    import uweex from 'ucar-weex'
    export default{
        data () {
            return {
                refresh_display: 'hide',
                loading_display: 'hide',
                tagType: '__all__',
                resData: [],
                navbar: [{
                    text: '推荐',
                    url: 'My.js',
                    type: '__all__',
                    clicked: true
                },
                    {
                        text: '热点',
                        url: 'My.js',
                        type: 'news_hot',
                        clicked: false
                    },
                    {
                        text: '社会',
                        url: '/home/society',
                        type: 'news_society',
                        clicked: false
                    },
                    {
                        text: '娱乐',
                        url: '/home/entertainment',
                        type: 'news_entertainment',
                        clicked: false
                    },
                    {
                        text: '科技',
                        url: '/home/tech',
                        type: 'news_tech',
                        clicked: false
                    },
                    {
                        text: '汽车',
                        url: '/home/car',
                        type: 'news_car',
                        clicked: false
                    },
                    {
                        text: '体育',
                        url: '/home/sports',
                        type: 'news_sports'
                    },
                    {
                        text: '财经',
                        url: '/home/finance',
                        type: 'news_finance',
                        clicked: false
                    },
                    {
                        text: '军事',
                        url: '/home/military',
                        type: 'news_military',
                        clicked: false
                    },
                    {
                        text: '国际',
                        url: '/home/world',
                        type: 'news_world',
                        clicked: false
                    },
                    {
                        text: '时尚',
                        url: '/home/fashion',
                        type: 'news_fashion',
                        clicked: false
                    },
                ],
            };
        },
        created: function () {
            for (var i = 0; i < this.navbar.length; i++) {
                var navbar = this.navbar[i];
                navbar.url = config.js(navbar.url);
            }
            this.refresh_display = 'show';
            this.getNewData(this.tagType);

        },
        methods: {
            getNewData(tagType){
                var self = this;
//                var url = 'http://m.toutiao.com/list/?tag=news_society&ac=wap&count=20&format=json_raw&as=A125A8CEDCF8987&cp=58EC18F948F79E1&min_behot_time=' + parseInt((new Date().getTime()) / 1000);
                var url = 'http://m.toutiao.com/list/?tag=' + tagType + '&ac=wap&count=20&format=json_raw&as=A125A8CEDCF8987&cp=58EC18F948F79E1&min_behot_time=' + parseInt((new Date().getTime()) / 1000);
                stream.fetch({
                    method: 'get',
                    url: url,
                    type: 'json'
                }, (res) => {
                    self.refresh_display = 'hide';
                    modal.toast({
                        message: res.statusText,
                        duration: 0.3
                    })
                    console.log('ret2=' + JSON.stringify(res.status))
                    console.log('ret=' + JSON.stringify(res.data.data));
                    this.resData = res.data.data;
                });
            },
            onItemClick(val){
                uweex.router.push({
                    url: 'Detail.js',
                    param: {
                        id: val.tag_id,
                        title: val.title,
                        media_info: val.media_info,
                        media_name: val.media_name,
                        datetime: val.datetime,
                        abstract: val.abstract,
                        image_list: val.image_list,
                        repin_count: val.repin_count,
                        comment_count: val.comment_count,
                        keywords: val.keywords

                    },
                    navBar: {
                        backColor: "#ffffff",
                        navBarColor: "#d43d3d",
                    }
                }, () => {
                })
            },
            onrefresh: function (e) {
                var self = this;
                self.refresh_display = 'show';
                this.getNewData(self.tagType);
            },
            onloading: function (e) {
                var self = this;
                self.loading_display = 'show';
                setTimeout(function () {
                    self.loading_display = 'hide';
                }, 3000)
            },
            pullingdown: function (e) {
                var dy = e.dy;
                var pullingDistance = e.pullingDistance;
                var viewHeight = e.viewHeight;
            }
            ,
            navClick(item){
                var self = this;
                for (var i = 0; i < this.navbar.length; i++) {
                    var nb = this.navbar[i];
                    if (item.text === nb.text) {
//                        modal.alert({
//                            message: nb.text,
//                            duration: 0.3
//                        }, function (value) {
//                            console.log('alert callback', value)
//                        })
                        nb.clicked = true;
                        self.tagType = item.type;
                    } else {
                        nb.clicked = false;
                    }
                }
                self.refresh_display = 'show';
                this.getNewData(self.tagType);
            }
        },

    }
</script>


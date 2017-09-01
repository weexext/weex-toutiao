<template>

    <scroller @onAndroidBack="onAndroidBack" @ready="ready" @actived="actived" @deactived="deactived" class="container">
        <navpage backgroundColor="#d43d3d" title="头条详情" :leftItemSiblingSrc="imgClose"
                 @naviBarLeftItemClick="naviBarLeftItemClick">
        </navpage>
        <div class="container">

            <text class="detail-title">{{param.title}}</text>
            <div class="media_name">
                <image src="assets:///image/head.jpg" class="avatar_url"/>
                <text class="name">{{param.media_name}}</text>
                <text class="date">{{param.datetime}}</text>
            </div>
            <div class="contentNews">
                <text class="abstract">{{param.abstract}}</text>
            </div>
            <div v-for="img in param.image_list">
                <image class="image" :style="{height: img.height,width: img.width }" :src="img.url"/>
            </div>
            <div class="keywords-row">
                <div v-for="item in keywords" class="keywords-item">
                    <text class="keywords-text">{{item}}</text>
                </div>
            </div>
            <!--<hr>-->
            <!--<div class="zan">-->
            <!--<Button type="ghost" size="large" icon="thumbsup" shape="circle">{{repin_count}}</Button>-->
            <!--<Button type="ghost" size="large" icon="trash-a" shape="circle">不喜欢</Button>-->
            <!--</div>-->
            <!--<hr>-->
        </div>

    </scroller>

</template>

<style scoped>
    .keywords-row {
        flex-direction: row;
        margin-top: 30px;
        flex-wrap: wrap;
    }

    .keywords-item {
        align-items: center;
        justify-content: center;
        padding: 10px;
        margin-right: 30px;
        border-radius: 30px;
        border-style: solid;
        border-width: 2px;
        border-color: #999999;
    }

    .keywords-text {
        height: 20px;
        font-size: 20px;
        color: #999999;
    }

    .image {
        margin-top: 50px
    }

    .abstract {
        text-indent: 100px;
        line-height: 50px;
        font-size: 32px;
        color: #666
    }

    .contentNews {
        flex-direction: column;
        margin-top: 20px;
    }

    .media_name {
        position: relative;
        margin-top: 50px;
    }

    .avatar_url {
        height: 100px;
        width: 100px;
        border-radius: 50%;
    }

    .name {
        position: absolute;
        font-size: 14px;
        font-weight: bold;
        left: 120px;
        top: 20px;
        font-size: 28px;
    }

    .date {
        position: absolute;
        left: 120px;
        top: 60px;
        font-size: 20px;
    }

    .container {
        background-color: #f2f2f2;
        flex-direction: column;
        padding: 15px;
    }

    .detail-title {
        font-size: 36px;
        font-weight: bold;
        color: #333;
    }

</style>

<script>
    const modal = weex.requireModule('modal')
    import uweex from 'ucar-weex'
    export default {
        components: {
            navpage: require('../include/navpage.vue'),
        },
        data() {
            return {
                pageName: 'pageB',
                param: {},
                keywords: []
            }
        },
        created: function () {
//            this.param.abstract ="xxxxxxx";
            console.log('created' + this.param.abstract);
        },
        mounted: function () {
            var domModule = weex.requireModule('dom');
            domModule.addRule('fontFace', {
                'fontFamily': "iconfont4",
                'src': "url('http://localhost:12570/src/assets/font/font_zn5b3jswpofuhaor.ttf')"
            });
        },
        methods: {
            //
            ready(e){
                this.param = e.param
                this.keywords = this.param.keywords.split(',')
//                let p = JSON.stringify(e.param)
                console.log('上个页面传参数=' + this.param.abstract);
//                modal.toast({
//                    message: this.keywords[0],
//                    duration: 0.3
//                })
            },
            trimStr(str){
                return str.replace(/(^\s*)|(\s*$)/g, "");
            },

            naviBarLeftItemClick(){
                uweex.router.pop();
            },
            onAndroidBack(){
                uweex.router.pop();
            },
            onClick(){
                console.log('created' + this.pageName);
            }
        },

    };
</script>

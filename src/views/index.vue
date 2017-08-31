<template>
    <div style="flex-direction: column;">
        <tabhost :tabItems="tabItems" @tabBarOnClick="tabBarOnClick"></tabhost>
    </div>
</template>

<script>
    import  config from '../config/index'
    module.exports = {
        data: function () {
            return {
                tabItems: [
                    {
                        index: 0,
                        title: '首页',
                        titleColor: '#000000',
                        icon: '',
                        selectedImage: 'assets:///image/bottom_nav/home_icon.png',
                        image: 'assets:///image/bottom_nav/home_dark_icon.png',
                        src: 'Home.js',
                        visibility: 'visible',
                    },
                    {
                        index: 1,
                        title: '收藏',
                        titleColor: '#000000',
                        icon: '',
                        selectedImage: 'assets:///image/bottom_nav/collect_icon.png',
                        image: 'assets:///image/bottom_nav/collect_dark_icon.png',
                        src: 'Care.js',
                        visibility: 'hidden',
                    },
                    {
                        index: 2,
                        title: '我的',
                        titleColor: '#000000',
                        icon: '',
                        selectedImage: 'assets:///image/bottom_nav/head_icon.png',
                        image: 'assets:///image/bottom_nav/head_dark_icon.png',
                        src: 'My.js',
                        visibility: 'hidden',
                    }
                ],
            }
        },
        components: {
            tabhost: require('../include/tabbar.vue')
        },

        created: function () {
            for (var i = 0; i < this.tabItems.length; i++) {
                var tabItem = this.tabItems[i];
                tabItem.src = config.js(tabItem.src);
            }
        },
        methods: {
            tabBarOnClick: function (e) {
                console.log('tabBarOnClick', e.index)
            }
        }
    }
</script>

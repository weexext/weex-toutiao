<template>
  <div
    :dataRole="dataRole"
    class="container"
    :style="{ height: height, backgroundColor: backgroundColor }">
    <div class="right-text-outer" v-if="rightItemTitle" v-on:click="onclickrightitem">
      <text naviItemPosition="right" :style="{ color: rightItemColor }" class="right-text">{{rightItemTitle}}</text>
    </div>

    <div class="right-image-outer" v-if="rightItemSrc" v-on:click="onclickrightitem">
      <image naviItemPosition="right" :src="rightItemSrc" class="right-image"></image>
    </div>
    <!-- 添加 navbar 右侧第二个图片按钮 在第一个偏左的位置-->
    <image
      v-if="rightItemSiblingSrc"
      naviItemPosition="right"
      :src="rightItemSiblingSrc"
      class="right-image-sibling"
      v-on:click="onclickrightsiblingitem"></image>

    <text
      v-if="leftItemTitle"
      naviItemPosition="left"
      :style="{ color: leftItemColor }"
      class="left-text"
      v-on:click="onclickleftitem">{{leftItemTitle}}</text>
    <image
      v-if="leftItemSrc"
      naviItemPosition="left"
      :src="leftItemSrc"
      class="left-image"
      v-on:click="onclickleftitem"></image>
    <!-- 添加 navbar 左侧第二个图片按钮 -->
    <image
      v-if="leftItemSiblingSrc"
      naviItemPosition="left"
      :src="leftItemSiblingSrc"
      class="left-image-sibling"
      v-on:click="onclickleftsiblingitem"></image>

    <!-- 中间title 支持右侧添加图片 -->
    <div class="center-title">
      <text
      naviItemPosition="center"
      :style="{ color: titleColor }"
      class="center-text">{{title}}</text>
      <image
      v-if="centerTitleImageSrc"
      naviItemPosition="center"
      :src="centerTitleImageSrc"
      class="center-title-image"
      v-on:click="onClickCenterTitleImage"></image>
    </div>
  </div>
</template>

<style scoped>
  .container {
    flex-direction: row;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    width: 750;
  }
  .right-text-outer {
    position: absolute;
    bottom: 0px;
    right: 0px;
    min-width: 88px;
    min-height: 88px;
    flex-direction: row;
    justify-content: flex-end;
    align-items: center;
  }
  .right-text {
    line-height: 88px;
    /*text-align: right;*/
    font-size: 32px;
    margin-right: 20px;
    /*font-family: 'Open Sans', sans-serif;*/
  }
  .left-text {
    position: absolute;
    bottom: 5px;
    left :10px;
    min-width: 80px;
    line-height: 80px;
    text-align :center;
    font-size: 32px;
    /*font-family: 'Open Sans', sans-serif;*/
    margin-left: 50px;
  }

  .center-title{
    position: absolute;
    bottom: 25;
    left: 172;
    right: 172;
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: center;
  }
  .center-text {
    text-align: center;
    font-size: 36;
    font-weight: bold;
  }
  .center-title-image{
    width: 50;
    height: 50;
    margin-left: 10;
  }
  .left-image {
    position: absolute;
    bottom: 20;
    left: 28;
    width: 50;
    height: 50;
  }
  .right-image-outer {
    position: absolute;
    bottom: 0px;
    right: 0px;
    height: 88px;
    min-width: 88px;
    flex-direction: row;
    align-items: center;
    justify-content: center;
  }
  .right-image {
    width: 50px;
    height: 50px;
  }

  .right-image-sibling{
    position: absolute;
    bottom: 20;
    right: 100;
    width: 50;
    height: 50;
  }
  .left-image-sibling{
    position: absolute;
    bottom: 20;
    left: 100;
    width: 50;
    height: 50;
  }

</style>

<script>
  module.exports = {
    props: {
      dataRole: { default: 'navbar' },
      //导航条背景色
      backgroundColor: { default: 'black' },
      //导航条高度
      height: { default: 88 },
      //导航条标题
      title: { default: '' },
      //导航条标题颜色
      titleColor: { default: 'black' },
      //title紧邻的图片
      centerTitleImageSrc: { default: ''},
      //右侧按钮图片
      rightItemSrc: { default: '' },
      //右侧第二个按钮图片
      rightItemSiblingSrc: { default: '' },
      //右侧按钮标题
      rightItemTitle: { default: '' },
      //右侧按钮标题颜色
      rightItemColor: { default: 'black' },
      //左侧按钮图片
      leftItemSrc: { default: '' },
      //左侧第二个按钮图片
      leftItemSiblingSrc: { default: '' },
      //左侧按钮标题
      leftItemTitle: { default: '' },
      //左侧按钮颜色
      leftItemColor: { default: 'black' }
    },
    methods: {
      onclickrightitem: function (e) {
        this.$emit('naviBarRightItemClick');
      },
      onclickleftitem: function (e) {
        this.$emit('naviBarLeftItemClick');
      },
      onclickrightsiblingitem:function(e){
        this.$emit('naviBarRightSiblingItemClick');
      },
      onclickleftsiblingitem:function(e){
        this.$emit('naviBarLeftSiblingItemClick');
      },
      onClickCenterTitleImage:function(e){
        this.$emit('onClickCenterTitleImage')
      }
    },
    events:{
      naviBarLeftItemClick(e){
          //navigator.pop(()=>{})
          console.log('pop')
      }
    }
  }
</script>

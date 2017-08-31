<template>
  <div class="wrapper">
    <navbar
      :dataRole="dataRole"
      :height="height"
      :backgroundColor="backgroundColor"
      :title="title"
      :titleColor="titleColor"
      :leftItemSrc="leftItemSrc"
      :leftItemTitle="leftItemTitle"
      :leftItemColor="leftItemColor"
      :leftItemSiblingSrc="leftItemSiblingSrc"
      :rightItemSrc="rightItemSrc"
      :rightItemTitle="rightItemTitle"
      :rightItemColor="rightItemColor"
      :rightItemSiblingSrc="rightItemSiblingSrc"
      :centerTitleImageSrc="centerTitleImageSrc"
      @naviBarRightItemClick="naviBarRightItemClick"
      @naviBarRightSiblingItemClick="naviBarRightSiblingItemClick"
      @naviBarLeftItemClick="naviBarLeftItemClick"
      @naviBarLeftSiblingItemClick="naviBarLeftSiblingItemClick"
      @onClickCenterTitleImage="onClickCenterTitleImage"
      ></navbar>
    <div class="wrapper" :style="{ marginTop: height }">
      <!--<slot></slot>-->
    </div>
  </div>
</template>

<style scoped>
  .wrapper {
    /*position: absolute;*/
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    width: 750;
  }
</style>

<script>
  const config = require("../config/index")

  module.exports = {
    components: {
      navbar: require('./navbar.vue'),
    },

    props: {
      dataRole: { default: 'none' },
      backgroundColor: { default: "#385198" },
      height: { default: weex.config.env.platform == 'android' ? 100 : 128 },
      title: { default: "" },
      titleColor: { default: "#ffffff" },
      rightItemSrc: { default: '' },
      rightItemTitle: { default: '' },
      rightItemColor: { default: "#ffffff" },
      rightItemSiblingSrc: { default: '' },
      leftItemSrc: { default: config.image('icon_arrow_back.png')},
      leftItemTitle: { default: '' },
      leftItemColor: { default: "#ffffff" },
      leftItemSiblingSrc: { default: '' },
      centerTitleImageSrc:{ default : ''}
    },
    methods: {
      naviBarRightItemClick: function (e) {
        this.$emit('naviBarRightItemClick', e)
      },
      naviBarRightSiblingItemClick:function(e){
        this.$emit('naviBarRightSiblingItemClick',e);
      },
      naviBarLeftItemClick: function (e) {
        this.$emit('naviBarLeftItemClick', e)
      },
      naviBarLeftSiblingItemClick:function(e){
        this.$emit('naviBarLeftSiblingItemClick',e);
      },
      onClickCenterTitleImage:function(e){
        this.$emit('onClickCenterTitleImage',e)
      }
    }
  }
</script>

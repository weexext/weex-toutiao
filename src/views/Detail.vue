<template>

    <div @onAndroidBack="onAndroidBack" @ready="ready" @actived="actived" @deactived="deactived" class="container">
        <div >
            <text>
                {{pageName}}
            </text>
        </div>
        <navpage backgroundColor="#d43d3d" title="头条详情" :leftItemSiblingSrc="imgClose"
                 @naviBarLeftItemClick="naviBarLeftItemClick">
        </navpage>
        <div class="button" @click="onClick">
            返回PageA
        </div>
    </div>

</template>

<style scoped>

    .button {
        width: 200px;
        height: 80px;
        background-color: #3e50b5;
        justify-content: center;
        align-items: center;
    }
    .container {
        background-color: #f3f3f3;
        flex-direction: column;
        flex: 1;
        justify-content: center;
        align-items: center;
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
                param:{

                }
            }
        },
        created: function () {
//            this.param.abstract ="xxxxxxx";
            console.log('created' +  this.param.abstract);
        },
        methods: {
            //
            ready(e){
                this.param = e.param
                let p = JSON.stringify(e.param)
                console.log('上个页面传参数=' +  this.param.abstract);
            },


            onAndroidBack(){
                  uweex.router.pop();
            },
            onClick(){
                this.param.abstract ="ssssssssss"
                this.pageName ="然而他"
                console.log('created'+this.pageName);

            }
        },

    };
</script>

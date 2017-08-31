package com.ucar.wxd;

import android.app.Application;
import android.support.annotation.NonNull;
import android.widget.Toast;

import com.ucar.weex.UWXInit;
import com.ucar.weex.init.utils.UWLog;
import com.ucar.weex.update.FileUtils;
import com.ucar.weex.update.UWXResManager;
import com.ucar.weex.update.WXPackageInfo;
import com.ucar.weex.utils.ArrayUtils;

import java.io.IOException;

/**
 * weex 初始化
 */
public class WXApplication extends Application {
    public static Application instance;

    @Override
    public void onCreate() {
        super.onCreate();
        instance = this;

        UWXInit.init(this);
        /**
         * assets/weex/ucar-weex_3_20170828123442
         */
        UWXResManager.getInstance().addWXResFromAssert(this, FileUtils.getWXPackageFileName(this, "weex"));
//        UWXResManager.getInstance().setServerUrl("");
        UWXResManager.getInstance().checkUpdate(new UWXResManager.CheckUpdateCallback() {
            @Override
            public void callback(int code, String msg, WXPackageInfo info) {
                Toast.makeText(WXApplication.this, msg, Toast.LENGTH_LONG).show();
                UWLog.d("WXApp", msg);
                //重启 提示
            }
        });
    }

}

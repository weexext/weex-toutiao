package com.ucar.wxd;

import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.FragmentActivity;

import com.ucar.weex.UWXPageManager;
import com.ucar.weex.init.model.UWXBundleInfo;

public class MainActivity extends FragmentActivity {


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main_activity);

        new Handler(getMainLooper()).postDelayed(new Runnable() {
            @Override
            public void run() {
              startWeexPage();
            }
        },1000);

    }

    private void startWeexPage() {
        UWXPageManager.openPage(this, "index.js", new UWXBundleInfo.NavBar("#ffffff", "#ffffff"));
//        Bundle bundle = new Bundle();
//        bundle.putString("key", "value");
//        bundle.putString("name", "zhangsan");
//        UWXPageHelper.createWXPage(this, R.id.container, "index.js", bundle );
        finish();
    }
}

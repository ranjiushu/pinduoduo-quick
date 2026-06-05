package com.example.pinduoduo.quick;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.widget.Toast;

public class MainActivity extends Activity {

    private static final String PDD_DEEP_LINK = "pinduoduo://com.xunmeng.pinduoduo/mdkd/package";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        try {
            Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(PDD_DEEP_LINK));
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);
        } catch (Exception e) {
            Toast.makeText(this, "请先安装拼多多", Toast.LENGTH_LONG).show();
        }

        finish();
    }
}

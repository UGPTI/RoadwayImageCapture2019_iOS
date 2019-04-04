package com.example.printimagestring;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Environment;
import android.os.IBinder;
import android.preference.PreferenceManager;
import android.support.v4.app.NotificationCompat;
import android.util.Base64;
import android.util.Log;
//
//import com.loopj.android.http.AsyncHttpResponseHandler;
//import com.loopj.android.http.RequestParams;
//import com.loopj.android.http.SyncHttpClient;
//
//import org.apache.http.Header;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.util.List;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        printString();
    }

    public void printString() {
//        String fullPath = "/storage/sdcard/Pictures/1554218557240_thumbnail.jpg";
        String fullPath = "/storage/sdcard/Pictures/1554218557240.jpg";
        Bitmap bitmap = BitmapFactory.decodeFile(fullPath);
        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream);
        byte[] byte_arr = stream.toByteArray();
        String encodedString = Base64.encodeToString(byte_arr, 0);
    }
}

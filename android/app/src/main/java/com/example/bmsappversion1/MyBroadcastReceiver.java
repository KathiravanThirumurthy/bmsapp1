package com.example.bmsappversion1;

import android.bluetooth.BluetoothAdapter;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import org.jetbrains.annotations.NotNull;

public class MyBroadcastReceiver  extends BroadcastReceiver  {
    public BluetoothAdapter bluetoothAdapter;
    private static final String TAG = MainActivity.class.getSimpleName();

   /* public MyBroadcastReceiver() {
        super();
    }*/


    @Override
   public void onReceive(Context context, @NotNull Intent intent)
    {
        String action=intent.getAction();
       if(action.equals(bluetoothAdapter.ACTION_CONNECTION_STATE_CHANGED))
        {
            final int state=intent.getIntExtra(BluetoothAdapter.EXTRA_STATE,bluetoothAdapter.ERROR);
            switch ( state)
            {
                case BluetoothAdapter.STATE_OFF:
                    Log.d(TAG,"onReceive :STATE OFF");
                    break;
                case BluetoothAdapter.STATE_ON:
                    Log.d(TAG,"onReceive :STATE ON");
                    break;
                case BluetoothAdapter.STATE_TURNING_ON:
                    Log.d(TAG,"onReceive :STATE TURNING ON");
                    break;
                case BluetoothAdapter.STATE_TURNING_OFF:
                    Log.d(TAG,"onReceive :STATE TURNING OFF");
                    break;
            }
        }
    }
}

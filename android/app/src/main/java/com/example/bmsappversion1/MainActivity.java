package com.example.bmsappversion1;


import android.app.AlertDialog;
import android.bluetooth.BluetoothDevice;
import android.content.DialogInterface;
import android.os.Build;

import io.flutter.embedding.android.FlutterActivity;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Map;
import java.util.Scanner;
import java.util.Set;
import java.util.UUID;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import android.Manifest;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothSocket;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import static android.content.ContentValues.TAG;



import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;


public class MainActivity extends FlutterActivity {
    public static final String BONCHANNEL="bonChannel";
    public static final String BONDEDCHANNEL="bondedchannel";
    public static final String CONNECTCHANNEL="connectchannel";
    public static final String SIMPLEMSGCHANNEL="simplemsgchannel";
    public static  final String SAMPLECHANNEL="samplechannel";

    private static final String PLATFORM_CHANNEL = "platform_channel";





    //private final static int CONNECTING_STATUS = 3; // used in bluetooth handler to identify message status
    InputStream inStream;
    OutputStream outputStream;

    /* public static final String SCANCHANNEL="scanchannel";


     */
    public static Handler handler;
    public static BluetoothSocket mmSocket;
    public static ConnectedThread connectedThread;
    public static CreateConnectThread createConnectThread;


    // The following variables used in bluetooth handler to identify message status
    private final static int CONNECTION_STATUS = 1;
    private final static int MESSAGE_READ = 2;



    //public String bluetoothStatus;
    public String readMessage;
    public Boolean bluetoothStatus;
    public String handShakeMsg;


    public BluetoothAdapter bluetoothAdapter;
    public Boolean bleStatus;

    public ArrayList<BluetoothDevice> mBTDevices=new ArrayList<>();
    public ArrayList<BluetoothDevice> bondedDevices=new ArrayList<BluetoothDevice>();
    public Set<BluetoothDevice> pairedDevices;
    public ArrayList<String> bondedlist ;


    // private Handler mHandler; // Our main handler that will receive callback notifications
    // private ConnectedThread mConnectedThread; // bluetooth background worker thread to send and receive data
    // private BluetoothSocket mBTSocket = null; // bi-directional client-to-client data path




    private static final String TAG = MainActivity.class.getSimpleName();

    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        bluetoothAdapter=BluetoothAdapter.getDefaultAdapter();

        // getting Bluetooth state
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), BONCHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Note: this method is invoked on the main thread.
                            // TODO
                            //  Map<String,Object> params=(Map<String,Object>) call.arguments;

                            if(call.method.equals("checkBluetoothState"))
                            {
                                Log.d(TAG, "Bluetooth state check");
                                checkBluetoothState();
                                result.success(bleStatus);

                            }else {
                                result.notImplemented();

                            }

                        }
                );

        // getting Bonded Device

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), BONDEDCHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Note: this method is invoked on the main thread.
                            // TODO
                            //  Map<String,Object> params=(Map<String,Object>) call.arguments;
                            if(call.method.equals("getBondeddevice"))
                            {
                                Log.d(TAG, "checking for Bonded Channel");
                                ArrayList<String> msgToFlutter=getBondeddevice();
                                // ArrayList<BluetoothDevice> msgToFlutter=getBondeddevice();
                                result.success(msgToFlutter);
                            }else {
                                result.notImplemented();

                            }

                        }
                );

        // getting connected with paired Device

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CONNECTCHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Note: this method is invoked on the main thread.
                            // TODO
                            //  Map<String,Object> params=(Map<String,Object>) call.arguments;
                            // int params=methodCallParams.arguments;


                            if(call.method.equals("connectDeviceFunction"))
                            {
                                int params=call.argument("indexparam");
                                connectDeviceFunction(result,params);
                                /*
                                if(bluetoothStatus !=null) {
                                    //updateBleConnectedStatus();
                                    result.success(bluetoothStatus);
                                }else
                                {
                                    result.error("unavailable","bluetoothStatus value not updated",null);
                                }*/
                                // Log.d(TAG, String.valueOf(params));

                            }else {
                                result.notImplemented();

                            }

                        }
                );
        // handshaking message

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), SIMPLEMSGCHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Note: this method is invoked on the main thread.
                            // TODO
                            //  Map<String,Object> params=(Map<String,Object>) call.arguments;
                            // int params=methodCallParams.arguments;


                            if(call.method.equals("handShakeMsgFunction"))
                            {
                                Log.e(TAG, "checking for msg Channel");
                                handShakeMsgFunction(result);
                                /*if(handShakeMsg!=null)
                                {
                                    result.success(handShakeMsg);
                                }*/


                            }else {
                                result.notImplemented();

                            }

                        }
                );

        //Sample from Native to flutter

        /*
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), PLATFORM_CHANNEL).setMethodCallHandler(
                new MethodCallHandler() {

                    @Override
                    public void onMethodCall(MethodCall call, Result result) {
                        if (call.method.equals("demoFunction")) { // INFO: method check
                           String argument = call.argument("data"); // INFO: get arguments
                           demoFunction(result, argument); // INFO: method call, every method call should pass result parameter
                        }
                        else {
                            result.notImplemented(); // INFO: not implemented
                        }
                    }
                }
        );

         */


     /*

      // Code to turn ON LED
        buttonOn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String androidCmd = "w";
                connectedThread.write(androidCmd);
            }
        });
      */






    } //configure flutter engine ends

   /* public void demoFunction(Result result, String data) {
        // INFO: function implementation
        if (true) { // INFO: check for some condition
            result.success("android call success with data " + data); // INFO: success response should return through this method
        } else {
            result.error("ERROR", "Error message description!", null); // INFO: error response should return through this method
        }
    }*/

    /*********************  Checking for Permission **********************************/

    // Checking permission
    @RequiresApi(api = Build.VERSION_CODES.M)
    private void checkBTPermission()
    {
        if(Build.VERSION.SDK_INT > Build.VERSION_CODES.LOLLIPOP){
            int permissionCheck = this.checkSelfPermission("Manifest.permission.ACCESS_FINE_LOCATION");
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                permissionCheck += this.checkSelfPermission("Manifest.permission.ACCESS_COARSE_LOCATION");
            }
            if (permissionCheck != 0) {

                this.requestPermissions(new String[]{Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION}, 1001); //Any number
            }
        }else{
            Log.d(TAG, "checkBTPermissions: No need to check permissions. SDK version < LOLLIPOP.");
        }
    }  // end of Permissison





    @RequiresApi(api = Build.VERSION_CODES.M)
    private ArrayList<BluetoothDevice> scanDeviceNativeFunction()
    {

        if(bluetoothAdapter != null && bluetoothAdapter.isEnabled())
        {
            // we check if coarse location must be asked
            checkBTPermission();
            bluetoothAdapter.startDiscovery();





        }else {
            checkBluetoothState();
        }

        return(mBTDevices);
    }

    // Checking for Bluetooth State
    private void checkBluetoothState()
    {

        if(bluetoothAdapter == null)
        {
            Log.d(TAG,"EnableDisabledBT:Does not have BT capabilities");
        }
        if(!bluetoothAdapter.isEnabled())
        {
            Log.d(TAG,"enableDisableBtn: enabling BT");
            Intent enabledBTIntent=new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            startActivity(enabledBTIntent);
            IntentFilter BTIntent=new IntentFilter(BluetoothAdapter.ACTION_CONNECTION_STATE_CHANGED);
            registerReceiver(mBroadcastReceiver1,BTIntent);
            bleStatus=true;


        }
        if(bluetoothAdapter.isEnabled())
        {
            Log.d(TAG,"enableDisableBtn: disabling BT");


            bluetoothAdapter.disable();
            IntentFilter BTIntent=new IntentFilter(BluetoothAdapter.ACTION_CONNECTION_STATE_CHANGED);
            registerReceiver(mBroadcastReceiver1,BTIntent);
            bleStatus=false;

        }




    } // End Checking for Bluetooth State

    // Boradcast Receiver
    private final BroadcastReceiver mBroadcastReceiver1=new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action=intent.getAction();
            if(action.equals(bluetoothAdapter.ACTION_STATE_CHANGED))
            {
                final int state=intent.getIntExtra(BluetoothAdapter.EXTRA_STATE,bluetoothAdapter.ERROR);
                switch ( state)
                {
                    case BluetoothAdapter.STATE_OFF:
                        Log.d(TAG,"onReceive :STATE OFF");
                        //bleStatus=false;
                        break;
                    case BluetoothAdapter.STATE_ON:
                        Log.d(TAG,"onReceive :STATE ON");
                        // bleStatus=true;
                        break;
                    case BluetoothAdapter.STATE_TURNING_ON:
                        Log.d(TAG,"onReceive :STATE TURNING ON");
                        // bleStatus=true;
                        break;
                    case BluetoothAdapter.STATE_TURNING_OFF:
                        Log.d(TAG,"onReceive :STATE TURNING OFF");
                        //  bleStatus=false;
                        break;
                }
            }

        }
    };

    /* Getting Bonded Device */
    ArrayList<String> getBondeddevice()
    {

        pairedDevices = bluetoothAdapter.getBondedDevices();
        bondedlist = new ArrayList<String>();
        // bondedDevices=new ArrayList<>();
        // ArrayList<BluetoothDevice> bondedDevices;=new ArrayList<>();
        //return(pairedDevices);
        if (pairedDevices.size() > 0)
        {
            // There are paired devices. Get the name and address of each paired device.
            for (BluetoothDevice device : pairedDevices)
            {
                bondedDevices.add(device);
                String deviceName = device.getName();
                String deviceHardwareAddress = device.getAddress();
                bondedlist.add(device.getName());


               // Toast.makeText(getApplicationContext(), deviceName, Toast.LENGTH_SHORT).show();

            }

        }else {
            Toast.makeText(getApplicationContext(), "NO bonded device", Toast.LENGTH_SHORT).show();
        }

        return(bondedlist);
        // return (bondedDevices);


    };
    // Sending hand shake msg function to bluetooth
    private void handShakeMsgFunction(Result result)
    {



         handShakeMsg = "0";
        connectedThread.write(handShakeMsg);
        Toast.makeText(getBaseContext(), "Sent data zero"+handShakeMsg, Toast.LENGTH_SHORT).show();
        result.success(handShakeMsg);


    }

    private boolean updateBleConnectedStatus(boolean bluetoothStatus)
    {
        bluetoothStatus=bluetoothStatus;

        return bluetoothStatus;
    }
    // Getting Connected Device

    private void connectDeviceFunction(Result result,int params)
    {
        int index=params;

        // BluetoothSocket mmSocket = null;
        BluetoothDevice device =bondedDevices.get(index);
        Log.d(TAG,"Connect Bonded device -devicename"+ bondedlist.get(index));
        Log.d(TAG,"Connect Bonded device -- device ID"+ bondedDevices.get(index));
        Log.d(TAG,"Connect Bonded device -- device get address"+ device);
      /*  if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            device.createBond();
        }
        startButtonConnection(device,MY_UUID );*/
       /* ConnectedThread cthread=new ConnectedThread(device);
        cthread.start();*/
        if(!bluetoothAdapter.isEnabled()) {
            Toast.makeText(getBaseContext(), "Bluetooth not on", Toast.LENGTH_SHORT).show();
            //return;
        }


        if (device != null){
            // bluetoothStatus="Connecting...";
            /*
            This is the most important piece of code.
            When "deviceAddress" is found, the code will call the create connection thread
            to create bluetooth connection to the selected device using the device Address
             */
            BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
            createConnectThread = new CreateConnectThread(bluetoothAdapter,device,result);
            createConnectThread.start();

        }

        handler=new Handler(Looper.getMainLooper())
        {
            @Override
            public void handleMessage(Message msg){
                //  Toast.makeText(getApplicationContext(), deviceName, Toast.LENGTH_LONG).show();
                Toast.makeText(getApplicationContext(), msg.toString(), Toast.LENGTH_LONG).show();
                switch (msg.what){
                    // If the updates come from the Thread to Create Connection
                    case CONNECTION_STATUS:
                        switch(msg.arg1){
                            case 1:
                                // bluetoothStatus="Bluetooth Connected";
                                bluetoothStatus=true;
                                result.success(bluetoothStatus);
                                Toast.makeText(getApplicationContext(), bluetoothStatus.toString(), Toast.LENGTH_LONG).show();
                                Log.e(TAG, "handler message "+ bluetoothStatus);
                                break;
                            case -1:
                                // bluetoothStatus="Connection Failed";
                                bluetoothStatus=false;
                                result.success(bluetoothStatus);
                              /*  AlertDialog.Builder builder=new AlertDialog.Builder(MainActivity.this);
                                builder.setMessage("Connection Failed you can't send and receive data").setPositiveButton("ok", new DialogInterface.OnClickListener() {
                                    @Override
                                    public void onClick(DialogInterface dialog, int which) {
                                        onResume();
                                    }
                                }).setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
                                    @Override
                                    public void onClick(DialogInterface dialog, int which) {


                                    }
                                });
                                AlertDialog alert = builder.create();
                                alert.show();*/
                                Toast.makeText(getApplicationContext(), bluetoothStatus.toString(), Toast.LENGTH_LONG).show();
                                Log.e(TAG, "handler message failed"+ bluetoothStatus);
                                break;
                        }

                        break;

                    // If the updates come from the Thread for Data Exchange
                    case MESSAGE_READ:
                        String statusText = msg.obj.toString().replace("/n","");
                        // ledStatus.setText(statusText);
                        readMessage=statusText;
                        Toast.makeText(getApplicationContext(),"REceived Message" +statusText,Toast.LENGTH_LONG).show();
                        break;
                }

            }

        };








    } // end of Getting Connected Device


















    /* ============================ Thread to Create Connection ================================= */


    public static class CreateConnectThread extends Thread {

        public CreateConnectThread(BluetoothAdapter bluetoothAdapter, BluetoothDevice device,Result result) {

            // Opening connection socket with the Arduino board
            BluetoothDevice bluetoothDevice = bluetoothAdapter.getRemoteDevice(device.getAddress());

            BluetoothSocket tmp = null;
            UUID uuid = bluetoothDevice.getUuids()[0].getUuid();
            try {
                // Get a BluetoothSocket to connect with the given BluetoothDevice.
                // MY_UUID is the app's UUID string, also used in the server code.
                tmp = bluetoothDevice.createInsecureRfcommSocketToServiceRecord(uuid);

            } catch (IOException e) {
                Log.e(TAG, "Socket's create() method failed", e);
            }
            mmSocket = tmp;
        }

        public void run() {
            // Cancel discovery because it otherwise slows down the connection.
            BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
            bluetoothAdapter.cancelDiscovery();

            try {
                // Connect to the Arduino board through the socket. This call blocks
                // until it succeeds or throws an exception.
                mmSocket.connect();
                handler.obtainMessage(CONNECTION_STATUS, 1, -1).sendToTarget();
            } catch (IOException connectException) {
                // Unable to connect; close the socket and return.
                try {
                    mmSocket.close();
                    handler.obtainMessage(CONNECTION_STATUS, -1, -1).sendToTarget();
                } catch (IOException closeException) { }
                return;
            }

            // The connection attempt succeeded. Perform work associated with
            // the connection in a separate thread.
            // Calling for the Thread for Data Exchange (see below)
            connectedThread = new ConnectedThread(mmSocket);
            connectedThread.run();
        }

        // Closes the client socket and causes the thread to finish.
        // Disconnect from Arduino board
        public void cancel() {
            try {
                mmSocket.close();
            } catch (IOException e) { }
        }
    }


    /* =============================== Thread for Data Exchange ================================= */
    /* Thread2 ConnectThread*/
    public static class ConnectedThread extends Thread {
        private final BluetoothSocket mmSocket;
        private final InputStream mmInStream;
        private final OutputStream mmOutStream;

        private static Context c;

        // Getting Input and Output Stream when connected to Arduino Board
        public ConnectedThread(BluetoothSocket socket) {
            mmSocket = socket;
            InputStream tmpIn = null;
            OutputStream tmpOut = null;
            try {
                tmpIn = socket.getInputStream();
                tmpOut = socket.getOutputStream();
            } catch (IOException e) { }
            mmInStream = tmpIn;
            mmOutStream = tmpOut;
        }

        // Read message from Arduino device and send it to handler in the Main Thread
        public void run() {
            byte[] buffer = new byte[1024];  // buffer store for the stream
            int bytes = 0; // bytes returned from read()
            // Keep listening to the InputStream until an exception occurs
            while (true) {
                try {
                    // Read from the InputStream
                    buffer[bytes] = (byte) mmInStream.read();
                    String arduinoMsg = null;

                    // Parsing the incoming data stream
                    if (buffer[bytes] == '\n'){
                        arduinoMsg = new String(buffer,0,bytes);
                        Log.e("Arduino Message",arduinoMsg);
                        Toast.makeText(c, "Arduino message"+ arduinoMsg, Toast.LENGTH_SHORT).show();

                        handler.obtainMessage(MESSAGE_READ,arduinoMsg).sendToTarget();
                        bytes = 0;
                    } else {
                        bytes++;
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                    break;
                }
            }
        }

        // Send command to Arduino Board
        // This method must be called from Main Thread
        public void write(String input) {
            byte[] bytes = input.getBytes(); //converts entered String into bytes
            try {
                mmOutStream.write(bytes);

            } catch (IOException e) { }
        }
    }



    @Override
    public void onResume(){
        super.onResume();
        //here...

    }



















} // end of Main Activity Classs

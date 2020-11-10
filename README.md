# GestOnHMD_DataCollection
 Data collection client and server for GestOnHMD

This repository contains a server which is an Android project, and a client as control centre written with [processing](http://processing.org) on java (in founder `client_finalset`). The client (java) sends message the server to trigger the recording process. The server (Android) will record a 1.5s-stereo-audio-clip from the top and bottom mic on the phone and storage locally on the phone at ... . 

## How to use

1. Make sure that your PC and the Android are connected to the same WiFi.
2. Build the android project and run on a Android phone.
3. Check the phone's local IP address and assign to variable `serverAddress` in the client code. Make sure that the port is 5204.
4. Run the processing program. If success, you will see a subtitle appear below the main title on the phone.
5. Select label on the client and start recording. 




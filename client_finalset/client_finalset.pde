// Created by Taizhou Chen
// City University of Hong Kong
// 2020.8.18

import processing.net.*; 
import java.awt.Rectangle;
import g4p_controls.*;

String serverAddress = "192.168.3.3";
int serverPort = 5204;
//record from which index
int record_from = 0;

Client myClient; 
String inString;

// Graphic frames used to group controls
ArrayList<Rectangle> rects ;

// Controls used for message dialog GUI 
GButton btnRecord, btnSave;
GOption[] optLabelTypeLeft, optLabelTypeRight, optLabelTypeFront, optFaceType;
GToggleGroup opgLabelTypeLeft, opgLabelTypeRight, opgLabelTypeFront, opgFaceType;
GTextField txfMdTitle;
GTextArea txfSMMessage;
GSpinner sampleIndexSpn, fftSensitivitySpn;
GGroup grpLabelLeft, grpLabelRight, grpLabelFront;

int record_dialog_x = 10, record_dialog_y = 10, 
    record_dialog_w = 780, record_dialog_h = 380;

int label_mtype, face_mtype;
int sample_index = 0;


String[] label_name = new String[] { 
    "0.Tap", "1.Double Tap", "2.Triple Tap", 
    "3.Slide Up", "4.Slide Down", "5.Slide Left", "6.Slide Right", 
    "7.Up-SemiCircle Left", "8.Up-SemiCircle Right", "9.Down-SemiCircle Left", "10.Down-SemiCircle Right", 
    "11.Left-SemiCircle Up", "12.Left-SemiCircle Down", "13.Right-SemiCircle Up", "14.Right-SemiCircle Down", 
    "15.Up Arrow", "16.Down Arrow", "17.Left Arrow", "18.Right Arrow", 
    "19.Clockwise", "20.Counterclockwise",
    "21.L", "22.Zoom in", "23.Zoom out", 
    "24.Curve Upper-left", "25.Curve Upper-right", "26.Curve Left-lower", "27.Curve Right-upper",
    "28.Slide Upper-left", "29.Slide Upper-right", "30.Slide Lower-left", "31.Slide Lower-right"
  };
  
String[] label_name_left = new String[]{
  "0.Tap(0)", "1.Double Tap(1)", "2.Triple Tap(2)", "3.Slide Up(3)", "4.Slide Down(4)", 
  "5.Up-SemiCircle Left(7)", "6.Up-SemiCircle Right(8)", "7.Down-SemiCircle Left(9)", "8.Down-SemiCircle Right(10)"
};

String[] label_name_right = new String[]{
  "0.Tap(0)", "1.Double Tap(1)", "2.Triple Tap(2)", "3.Slide Up(3)", "4.Slide Down(4)", 
  "5.Up-SemiCircle Left(7)", "6.Up-SemiCircle Right(8)", "7.Down-SemiCircle Left(9)", "8.Down-SemiCircle Right(10)"
};

String[] label_name_front = new String[]{
  "0.Tap(0)", "1.Double Tap(1)", "2.Triple Tap(2)", "3.Slide Left(5)", "4.Slide Right(6)", 
  "5.Up-SemiCircle Left(7)", "6.Up-SemiCircle Right(8)", "7.Down-SemiCircle Left(9)", "8.Down-SemiCircle Right(10)", 
  "9.Left-SemiCircle Down(12)", "10.Right-SemiCircle Down(14)", "11.Curve Left-lower(26)", "12.Curve Right-upper(27)",
  "13.Slide Lower-left(30)", "14.Slide Lower-right(31)"
};

String[] face_name = new String[] { 
  "Right", "Left", "Front"};

String[] audioDevicesNames = new String[]{"123", "456"};

void setup() { 
  size (800, 400);
  
  rects = new ArrayList<Rectangle> ();
  
  createMessageDialogGUI(record_dialog_x, record_dialog_y, record_dialog_w, record_dialog_h, 6);

  myClient = new Client(this, serverAddress, serverPort); 
  myClient.write("Connected to Cardboard.");
  
  sampleIndexSpn.setValue(record_from);
  
} 

void draw() { 
  background(200, 200, 255);
  
  for (Rectangle r : rects)
    showFrame(r);
}

void keyPressed(){
  // press enter
   if(keyCode == 10){
     sendCommand();
     sampleIndexSpn.setValue(sampleIndexSpn.getValue()+1);
   }
}

void clientEvent(Client someClient) {
  print("Server Says:  ");
  inString = someClient.readString();
  println(inString);
  redraw();
}

public void createMessageDialogGUI(int x, int y, int w, int h, int border) {
  // Store picture frame
  rects.add(new Rectangle(x, y, w, h));
  // Set inner frame position
  x += border; 
  y += border;
  w -= 2*border; 
  h -= 2*border;
  GLabel title = new GLabel(this, x, y, w, 20);
  title.setText("Data Collection Dialog", GAlign.LEFT, GAlign.MIDDLE);
  title.setOpaque(true);
  title.setTextBold();
  
  String[] t_face = new String[face_name.length];
  for (int i = 0; i < t_face.length; i++){
    t_face[i] = face_name[i];
  }
  
  GLabel selectLabelTitle = new GLabel(this, x, y+26, 190, 20);
  selectLabelTitle.setText("======== Labels ========", GAlign.LEFT, GAlign.MIDDLE);
  
  grpLabelLeft = new GGroup(this);
  grpLabelRight = new GGroup(this);
  grpLabelFront = new GGroup(this);
  int sec_row_fir_id = 0;
  label_mtype = 0;
  
  ////////////////// Right Label
  String[] t_label = new String[label_name_right.length];
  for (int i = 0; i < t_label.length; i++){
    t_label[i] = label_name_right[i];
  }
  sec_row_fir_id = 0;
  opgLabelTypeRight = new GToggleGroup();
  optLabelTypeRight = new GOption[t_label.length];
  for (int i = 0; i < optLabelTypeRight.length; i++) {
    if(y+48+i*18 > h){
      optLabelTypeRight[i] = new GOption(this, x+180+30, y+48+sec_row_fir_id*18, 200, 18);
      sec_row_fir_id += 1;
    }else{
      optLabelTypeRight[i] = new GOption(this, x, y+48+i*18, 200, 18);
    }
    optLabelTypeRight[i].setText(t_label[i]);
    optLabelTypeRight[i].tagNo = 1000 + i;
    opgLabelTypeRight.addControl(optLabelTypeRight[i]);
    grpLabelRight.addControl(optLabelTypeRight[i]);
  }
 
  optLabelTypeRight[label_mtype].setSelected(true);
  
  //////////////////  Left Label
  t_label = new String[label_name_left.length];
  for (int i = 0; i < t_label.length; i++){
    t_label[i] = label_name_left[i];
  }
  sec_row_fir_id = 0;
  opgLabelTypeLeft = new GToggleGroup();
  optLabelTypeLeft = new GOption[t_label.length];
  for (int i = 0; i < optLabelTypeLeft.length; i++) {
    if(y+48+i*18 > h){
      optLabelTypeLeft[i] = new GOption(this, x+180+30, y+48+sec_row_fir_id*18, 200, 18);
      sec_row_fir_id += 1;
    }else{
      optLabelTypeLeft[i] = new GOption(this, x, y+48+i*18, 200, 18);
    }
    optLabelTypeLeft[i].setText(t_label[i]);
    optLabelTypeLeft[i].tagNo = 1000 + i;
    opgLabelTypeLeft.addControl(optLabelTypeLeft[i]);
    grpLabelLeft.addControl(optLabelTypeLeft[i]);
  }
  
  optLabelTypeLeft[label_mtype].setSelected(true);
  grpLabelLeft.setVisible(0, false);
  
  ////////////////// Front Label
  t_label = new String[label_name_front.length];
  for (int i = 0; i < t_label.length; i++){
    t_label[i] = label_name_front[i];
  }
  sec_row_fir_id = 0;
  opgLabelTypeFront = new GToggleGroup();
  optLabelTypeFront = new GOption[t_label.length];
  for (int i = 0; i < optLabelTypeFront.length; i++) {
    if(y+48+i*18 > h){
      optLabelTypeFront[i] = new GOption(this, x+180+30, y+48+sec_row_fir_id*18, 200, 18);
      sec_row_fir_id += 1;
    }else{
      optLabelTypeFront[i] = new GOption(this, x, y+48+i*18, 200, 18);
    }
    optLabelTypeFront[i].setText(t_label[i]);
    optLabelTypeFront[i].tagNo = 1000 + i;
    opgLabelTypeFront.addControl(optLabelTypeFront[i]);
    grpLabelFront.addControl(optLabelTypeFront[i]);
  }
  
  optLabelTypeFront[label_mtype].setSelected(true);
  grpLabelFront.setVisible(0, false);
  
  
  GLabel selectFaceTitle = new GLabel(this, x + 400, y+26, 190, 20);
  selectFaceTitle.setText("======== Surface ========", GAlign.LEFT, GAlign.MIDDLE);
  
  opgFaceType = new GToggleGroup();
  optFaceType = new GOption[t_face.length];
  for (int i = 0; i < optFaceType.length; i++) {
    optFaceType[i] = new GOption(this, x + 400, y+48+i*18, 150, 18);
    optFaceType[i].setText(t_face[i]);
    optFaceType[i].tagNo = 2000 + i;
    opgFaceType.addControl(optFaceType[i]);
  }
  
  face_mtype = 0;
  optFaceType[face_mtype].setSelected(true);

  GLabel lbl1 = new GLabel(this, x+w-150, y+50, 100, 20);
  lbl1.setText("Sample Index");
  lbl1.setOpaque(true);
  lbl1.setTextAlign(GAlign.CENTER, GAlign.CENTER);
  sampleIndexSpn = new GSpinner(this, x+w-150, y+80, 100, 20);
  sampleIndexSpn.setLimits(0, 0, 1000, 1);
  
  btnRecord = new GButton(this, x+w-140, y+110, 80, 20, "Record");
}

// Simple graphical frame to group controls
public void showFrame(Rectangle r) {
  noFill();
  strokeWeight(1);
  stroke(color(240, 240, 255));
  rect(r.x, r.y, r.width, r.height);
  stroke(color(0));
  rect(r.x+1, r.y+1, r.width, r.height);
}

public void handleButtonEvents(GButton button, GEvent event) { 

  if (button == btnRecord)
    onStartRecordBtnClick();
    
}

void onStartRecordBtnClick(){
  sendCommand();
  sampleIndexSpn.setValue(sampleIndexSpn.getValue()+1);
}

void sendCommand(){
  if(myClient.active()){
    String command = "0fxx" + "_" + label_mtype + "_" + face_mtype + "_" + sampleIndexSpn.getValue();
    myClient.write(command);
    print("Command: " + command + "  sent");
  }
}

public void handleToggleControlEvents(GToggleControl checkbox, GEvent event) {
    sampleIndexSpn.setValue(record_from);
    switch(checkbox.tagNo / 1000) {
    case 1:
      label_mtype = checkbox.tagNo % 1000;
      break;
      
    case 2:
      face_mtype = checkbox.tagNo % 2000;
      resetAll();
      disableAll();
      if(face_mtype == 0){
        grpLabelRight.setVisible(0, true);
      }
      if(face_mtype == 1){
        grpLabelLeft.setVisible(0, true);
      }
      if(face_mtype == 2){
        grpLabelFront.setVisible(0, true);
      }
      break;
    }
}

void disableAll(){
  grpLabelLeft.setVisible(0, false);
  grpLabelRight.setVisible(0, false);
  grpLabelFront.setVisible(0, false);
}

void resetAll(){
  optLabelTypeLeft[0].setSelected(true);
  optLabelTypeRight[0].setSelected(true);
  optLabelTypeFront[0].setSelected(true);
  label_mtype = 0;
}

void handleTextEvents(GEditableTextControl source, GEvent event) {
  
}

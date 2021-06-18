import java.util.Arrays;

float scale;
boolean loading, mouseDragged;
short loadingCnt;
int depCity, arrCity, maxStationNum, maxTrainNum, index, depPlaceIndex, depStationIndex, arrPlaceIndex, arrStationIndex, trainIndex, dataNum, trainDataNum, renewColor;
final int lineSpacing=30, maxIndex=16;
String city, station, train, data;
final String serviceKey = "", url="http://openapi.tago.go.kr/openapi/service/TrainInfoService/";
PFont font;
int[] stationNum, trainColor = {#335B74, #865640, #4E3B30, #637052, #BD582C, #549E39, #632E62, #B65008, #3CB54C, #AE0933, #2D9FDE, #E51F6E};
int[][][] trainNum;
XML xml;
XML[] cityName, trainName, trainData;
XML[][] stationName;
Time curTime, pivotTime, dataTime, calTime;
CheckBox renew;
CheckBox[] trainList, depPlaceList, arrPlaceList;
Station[] depSelectedStation, arrSelectedStation;
Station[][] depStationList, arrStationList;
TrainInfo[][][][] trainInfo;
TrainInfo[] trainDataList, trainDrawList;

void setup() {
  curTime = new Time();
  pivotTime = new Time();
  dataTime = new Time();
  scale = 1.0;
  depSelectedStation = new Station[2];
  arrSelectedStation = new Station[2];
  renew = new CheckBox("조회", 1540, 600, 1630, 630);

  size(1640, 800);
  font = createFont("한초롬바탕", 15);
  textFont(font);
  rectMode(CORNERS);

  city = url+"getCtyCodeList?serviceKey="+serviceKey;
  xml = loadXML(city, "xml");
  cityName = xml.getChild("body").getChild("items").getChildren("item");

  depPlaceList = new CheckBox[cityName.length];
  for (int i=0; i<cityName.length; i++)
    depPlaceList[i] = new CheckBox(cityName[i].getChild("cityname").getContent(), cityName[i].getChild("citycode").getContent(), 10, 60+lineSpacing*i, 90, 90+lineSpacing*i);

  arrPlaceList = new CheckBox[cityName.length];
  for (int i=0; i<cityName.length; i++)
    arrPlaceList[i] = new CheckBox(cityName[i].getChild("cityname").getContent(), cityName[i].getChild("citycode").getContent(), 1380, 60+lineSpacing*i, 1460, 90+lineSpacing*i);

  stationNum = new int[cityName.length];
  for (int i=0; i<cityName.length; i++) {
    station = url+"getCtyAcctoTrainSttnList?serviceKey="+serviceKey+"&cityCode="+cityName[i].getChild("citycode").getContent();
    stationNum[i] = int(loadXML(station, "xml").getChild("body").getChild("totalCount").getContent());
    if (maxStationNum < stationNum[i]) maxStationNum = stationNum[i];
  }
  stationName = new XML[cityName.length][maxStationNum];
  depStationList = new Station[cityName.length][maxStationNum];
  arrStationList = new Station[cityName.length][maxStationNum];
  for (int i=0; i<cityName.length; i++) {
    station = url+"getCtyAcctoTrainSttnList?serviceKey="+serviceKey+"&cityCode="+cityName[i].getChild("citycode").getContent()+"&numOfRows="+stationNum[i];
    xml = loadXML(station, "xml");
    stationName[i] = xml.getChild("body").getChild("items").getChildren("item");
    for (int j=0; j<stationNum[i]; j++)
      depStationList[i][j] = new Station(stationName[i][j].getChild("nodename").getContent(), stationName[i][j].getChild("nodeid").getContent(), 100, 60+lineSpacing*j, 160, 90+lineSpacing*j);
    for (int j=0; j<stationNum[i]; j++)
      arrStationList[i][j] = new Station(stationName[i][j].getChild("nodename").getContent(), stationName[i][j].getChild("nodeid").getContent(), 1470, 60+lineSpacing*j, 1530, 90+lineSpacing*j);
  }

  train = url+"getVhcleKndList?serviceKey="+serviceKey;
  xml = loadXML(train, "xml");
  trainName = xml.getChild("body").getChild("items").getChildren("item");
  trainList = new CheckBox[trainName.length];
  for (int i=0; i<trainName.length; i++)
    trainList[i] = new CheckBox(trainName[i].getChild("vehiclekndnm").getContent(), trainName[i].getChild("vehiclekndid").getContent(), 1550, 60+lineSpacing*i, 1630, 90+lineSpacing*i);
}

void draw() {
  background(255);

  line(0, 555, 170, 555);
  line(1370, 555, 1640, 555);
  line(0, 650, 1640, 650);
  line(0, 40, 1640, 40);
  line(170, 40, 170, 625);
  line(1370, 40, 1370, 625);
  stroke(200);
  line(90, 60, 90, 530);
  line(1460, 60, 1460, 530);
  line(1540, 60, 1540, 530);
  stroke(0);

  fill(0);
  textAlign(LEFT, TOP);
  text(curTime.getYear()+" / "+curTime.getMonth()+" / "+curTime.getDay(), 10, 10);

  curTime.calDate();
  drawScale();
  depPlaceList();
  arrPlaceList();
  depStationList();
  arrStationList();
  trainList();
  depSelectedStationList();
  arrSelectedStationList();
  drawScrollBar();

  if (int(dataTime.getDateString()) != int(curTime.getDateString())) 
    thread("getData");

  fill(255);
  rect(renew.getPoint()[0], renew.getPoint()[1], renew.getPoint()[2], renew.getPoint()[3]);
  if (renewColor!=0) fill(renewColor);
  else if (!loading && mouseX>renew.getPoint()[0] && mouseX<renew.getPoint()[2] && mouseY>renew.getPoint()[1] && mouseY<renew.getPoint()[3]) fill(100);
  else fill(0);
  textAlign(CENTER, CENTER);
  text(renew.getName(), (renew.getPoint()[0]+renew.getPoint()[2])/2, (renew.getPoint()[1]+renew.getPoint()[3])/2);
  renewColor = 0;

  if (!loading && trainInfo != null) {
    try {
      drawData();
    } 
    catch (Exception e) {
      println("Exception");
    }
  }

  if (loading) drawLoading((loadingCnt++)/15);
}

void drawLoading(int cnt) {
  int[] loadingColor = {100, 200, 200, 200};
  noStroke();
  fill(loadingColor[(cnt+3)%4]);
  rect(730, 310, 810, 390);
  fill(loadingColor[(cnt+2)%4]);
  rect(830, 310, 910, 390);
  fill(loadingColor[(cnt+1)%4]);
  rect(830, 410, 910, 490);
  fill(loadingColor[(cnt+0)%4]);
  rect(730, 410, 810, 490);
  stroke(0);
}

void drawScrollBar() {
  strokeWeight(3);
  if (stationNum[depCity] > maxIndex)
    line(165, map(depStationIndex, 0, stationNum[depCity]-maxIndex, 70, 520)-10, 165, map(depStationIndex, 0, stationNum[depCity]-maxIndex, 70, 520)+10);
  if (stationNum[arrCity] > maxIndex)
    line(1535, map(arrStationIndex, 0, stationNum[arrCity]-maxIndex, 70, 520)-10, 1535, map(arrStationIndex, 0, stationNum[arrCity]-maxIndex, 70, 520)+10);
  /*
  if (cityName.length > maxIndex)
   line(90, map(depPlaceIndex, 0, cityName.length-maxIndex, 70, 520)-10, 90, map(depPlaceIndex, 0, cityName.length-maxIndex, 70, 520)+10);
   if (cityName.length > maxIndex)
   line(1490, map(arrPlaceIndex, 0, cityName.length-maxIndex, 70, 520)-10, 1490, map(arrPlaceIndex, 0, cityName.length-maxIndex, 70, 520)+10);
   if (trainName.length > maxIndex)
   line(1650, map(trainIndex, 0, trainName.length-maxIndex, 70, 520)-10, 1650, map(trainIndex, 0, trainName.length-maxIndex, 70, 520)+10);
   */
  strokeWeight(1);
}

void drawScale() {
  pivotTime.setTime(curTime);
  line(170, 650, 170, 680);
  fill(0);
  textAlign(CENTER, BOTTOM);
  text(curTime.getHour()+" : "+(int)curTime.getMinute(), 170, 645);

  pivotTime.setHalf();
  for (; pivotTime.getMinute()<curTime.getMinute()+60*scale; pivotTime.setMinute(pivotTime.getMinute()+10)) {
    float x = map(pivotTime.getMinute(), curTime.getMinute(), curTime.getMinute()+60*scale, 170, 1370);
    line(x, 650, x, 670);
    if (x>220 && x<1320) {
      Time scaleTime = new Time(pivotTime);
      scaleTime.calDate();
      fill(0);
      textAlign(CENTER, BOTTOM);
      text(scaleTime.getHour()+" : "+(int)scaleTime.getMinute(), x, 645);
    }
  }

  line(1370, 650, 1370, 680);
  textAlign(CENTER, BOTTOM);
  pivotTime.setTime(curTime);
  pivotTime.setMinute(curTime.getMinute()+60*scale);
  pivotTime.calDate();
  text(pivotTime.getHour()+":"+(int)pivotTime.getMinute(), 1370, 645);
}

void getData() {
  loading = true;
  dataTime.setTime(curTime);
  dataNum = 0;
  trainNum = new int[2][2][trainList.length];
  for (int dep=0; dep<2; dep++)
    if (depSelectedStation[dep] != null)
      for (int arr=0; arr<2; arr++)
        if (arrSelectedStation[arr] != null)
          for (int tr=0; tr<trainName.length; tr++)
            if (trainList[tr].getCheckBox()) {
              data = url+"getStrtpntAlocFndTrainInfo?serviceKey="+serviceKey+"&depPlaceId="+depSelectedStation[dep].getCode()+"&arrPlaceId="+arrSelectedStation[arr].getCode()+"&depPlandTime="+curTime.getDateString()+"&trainGradeCode="+trainList[tr].getCode();
              trainNum[dep][arr][tr] = int(loadXML(data, "xml").getChild("body").getChild("totalCount").getContent());
              dataNum += trainNum[dep][arr][tr];
              if (maxTrainNum < trainNum[dep][arr][tr]) maxTrainNum = trainNum[dep][arr][tr];
            }
  trainInfo = new TrainInfo[2][2][trainList.length][maxTrainNum];
  for (int dep=0; dep<2; dep++)
    if (depSelectedStation[dep] != null)
      for (int arr=0; arr<2; arr++)
        if (arrSelectedStation[arr] != null)
          for (int tr=0; tr<trainName.length; tr++)
            if (trainList[tr].getCheckBox()) {
              data = url+"getStrtpntAlocFndTrainInfo?serviceKey="+serviceKey+"&numOfRows="+trainNum[dep][arr][tr]+"&depPlaceId="+depSelectedStation[dep].getCode()+"&arrPlaceId="+arrSelectedStation[arr].getCode()+"&depPlandTime="+curTime.getDateString()+"&trainGradeCode="+trainList[tr].getCode();
              xml = loadXML(data, "xml");
              trainData = xml.getChild("body").getChild("items").getChildren("item");
              for (int i=0; i<trainNum[dep][arr][tr]; i++)
                trainInfo[dep][arr][tr][i] = new TrainInfo(trainData[i].getChild("depplandtime").getContent(), trainData[i].getChild("arrplandtime").getContent(), depSelectedStation[dep].getName(), arrSelectedStation[arr].getName(), tr);
            }
  trainDataList = new TrainInfo[dataNum];
  dataNum = 0;
  for (int dep=0; dep<2; dep++)
    for (int arr=0; arr<2; arr++)
      for (int tr=0; tr<trainName.length; tr++)
        for (int j=0; j<trainNum[dep][arr][tr]; j++)
          if (trainInfo[dep][arr][tr][j] != null) {
            trainDataList[dataNum] = trainInfo[dep][arr][tr][j];
            dataNum++;
          }
  //Arrays.sort(trainDataList);

  loading = false;
}

void drawData() throws Exception {
  trainDrawList = new TrainInfo[dataNum];
  trainDataNum = 0;
  for (int i=0; i<dataNum; i++) {
    pivotTime.setTime(curTime);
    pivotTime.setMinute(curTime.getMinute()+60*scale);
    pivotTime.calDate();
    if ((trainDataList[i].getArrTime()>curTime.getTime() && trainDataList[i].getArrTime()<pivotTime.getTime()) || (trainDataList[i].getDepTime()>curTime.getTime() && trainDataList[i].getDepTime()<pivotTime.getTime()) || (trainDataList[i].getDepTime()<=curTime.getTime() && trainDataList[i].getArrTime()>=pivotTime.getTime())) {
      trainDrawList[trainDataNum] = trainDataList[i];
      trainDataNum++;
    }
  }
  for (int i=index; i<trainDataNum && i<index+maxIndex; i++) {
    float LX = map(curTime.timeGap(trainDrawList[i].getDepTime()), 0, 60*scale, 170, 1370);
    LX = LX>170 ? LX:170;
    float RX = map(curTime.timeGap(trainDrawList[i].getArrTime()), 0, 60*scale, 170, 1370);
    RX = RX<1370 ? RX:1370;
    fill(trainColor[trainDrawList[i].getTrain()]);
    noStroke();
    rect(LX, 60+lineSpacing*(i-index)+5, RX, 90+lineSpacing*(i-index)-5);
    stroke(1);
    if (mouseX>LX && mouseX<RX && mouseY>60+lineSpacing*(i-index) && mouseY<90+lineSpacing*(i-index)) {
      if (LX != 170)
        line(LX, 60+lineSpacing*(i-index)+5, LX, 650);
      if (RX != 1370)
        line(RX, 60+lineSpacing*(i-index)+5, RX, 650);
    }
    if (RX-LX>130) {
      fill(255);
      textAlign(LEFT, CENTER);
      text(trainDrawList[i].getDepStation(), LX+5, 72+lineSpacing*(i-index));
      textAlign(RIGHT, CENTER);
      text(trainDrawList[i].getArrStation(), RX-5, 72+lineSpacing*(i-index));
    }
  }
}

void mousePressed() {
  if (!loading && ((mouseY>650 && mouseY<800) || (mouseX>170 && mouseX<1370 && mouseY>50 && mouseY<650)))
    mouseDragged = true;
}

void mouseReleased() {
  mouseDragged = false;
}

void mouseDragged() {
  if (mouseDragged)
    curTime.setMinute(curTime.minute-(mouseX-pmouseX)*0.1);
}

void mouseWheel(MouseEvent event) {
  if (!loading) {
    int e = (int)event.getCount();
    if (mouseY>650 && mouseY<800)
      scale += 0.1*e;
    if (((trainDataNum>=maxIndex && trainDataNum-index-e>=maxIndex) || e<0) && index+e>=0 && mouseX>170 && mouseX<1370 && mouseY>50 && mouseY<650)
      index += e;
    if (stationNum[depCity]-depStationIndex-e>=maxIndex && depStationIndex+e>=0 && mouseX>100 && mouseX<160 && mouseY>60 && mouseY<540)
      depStationIndex += e;
    if (stationNum[arrCity]-arrStationIndex-e>=maxIndex && arrStationIndex+e>=0 && mouseX>1470 && mouseX<1530 && mouseY>60 && mouseY<540)
      arrStationIndex += e;
    /*
     if (cityName.length-depPlaceIndex-e>=maxIndex && depPlaceIndex+e>=0 && mouseX>10 && mouseX<90 && mouseY>60 && mouseY<540)
     depPlaceIndex += e;
     if (cityName.length-arrPlaceIndex-e>=maxIndex && arrPlaceIndex+e>=0 && mouseX>1380 && mouseX<1460 && mouseY>60 && mouseY<540)
     arrPlaceIndex += e;
     if (trainName.length-trainIndex-e>=maxIndex && trainIndex+e>=0 && mouseX>1550 && mouseX<1630 && mouseY>60 && mouseY<540)
     trainIndex += e;
     */

    if (scale < 0.5) scale = 0.5;
    if (scale > 3) scale = 3;
  }
}

void mouseClicked() {
  if (!loading) {
    for (int i=depPlaceIndex; i<cityName.length && i<depPlaceIndex+maxIndex; i++)
      if (depCity!=i && mouseX>depPlaceList[i].getPoint()[0] && mouseX<depPlaceList[i].getPoint()[2] && mouseY>depPlaceList[i].getPoint()[1]-lineSpacing*depPlaceIndex && mouseY<depPlaceList[i].getPoint()[3]-lineSpacing*depPlaceIndex && mouseY>60 && mouseY<540) {
        depCity = i;
        depStationIndex = 0;
      }
    for (int i=arrPlaceIndex; i<cityName.length && i<arrPlaceIndex+maxIndex; i++)
      if (arrCity!=i && mouseX>arrPlaceList[i].getPoint()[0] && mouseX<arrPlaceList[i].getPoint()[2] && mouseY>arrPlaceList[i].getPoint()[1]-lineSpacing*arrPlaceIndex && mouseY<arrPlaceList[i].getPoint()[3]-lineSpacing*arrPlaceIndex && mouseY>60 && mouseY<540) {
        arrCity = i;
        arrStationIndex = 0;
      }
    for (int i=depStationIndex; i<stationNum[depCity] && i<depStationIndex+maxIndex; i++) {
      if (mouseX>depStationList[depCity][i].getPoint()[0] && mouseX<depStationList[depCity][i].getPoint()[2] && mouseY>depStationList[depCity][i].getPoint()[1]-lineSpacing*depStationIndex && mouseY<depStationList[depCity][i].getPoint()[3]-lineSpacing*depStationIndex && mouseY>60 && mouseY<540) {
        if (depStationList[depCity][i].getCheckBox()) {
          depStationList[depCity][i].setCheckBox(false);
          for (int j=0; j<2; j++)
            if (depSelectedStation[j] != null)
              if (!depSelectedStation[j].getCheckBox())
                depSelectedStation[j] = null;
        } else {
          for (int j=0; j<2; j++)
            if (depSelectedStation[j] == null) {
              depStationList[depCity][i].setCheckBox(true);
              depSelectedStation[j] = depStationList[depCity][i];
              int[] point = {100, 570+lineSpacing*j, 160, 600+lineSpacing*j};
              depSelectedStation[j].setSelectedPoint(point);
              break;
            }
        }
      }
    }
    for (int i=arrStationIndex; i<stationNum[arrCity] && i<arrStationIndex+maxIndex; i++) {
      if (mouseX>arrStationList[arrCity][i].getPoint()[0] && mouseX<arrStationList[arrCity][i].getPoint()[2] && mouseY>arrStationList[arrCity][i].getPoint()[1]-lineSpacing*arrStationIndex && mouseY<arrStationList[arrCity][i].getPoint()[3]-lineSpacing*arrStationIndex && mouseY>60 && mouseY<540) {
        if (arrStationList[arrCity][i].getCheckBox()) {
          arrStationList[arrCity][i].setCheckBox(false);
          for (int j=0; j<2; j++)
            if (arrSelectedStation[j] != null)
              if (!arrSelectedStation[j].getCheckBox())
                arrSelectedStation[j] = null;
        } else {
          for (int j=0; j<2; j++)
            if (arrSelectedStation[j] == null) {
              arrStationList[arrCity][i].setCheckBox(true);
              arrSelectedStation[j] = arrStationList[arrCity][i];
              int[] point = {1470, 570+lineSpacing*j, 1530, 600+lineSpacing*j};
              arrSelectedStation[j].setSelectedPoint(point);
              break;
            }
        }
      }
    }
    for (int i=0; i<2; i++) {
      if (depSelectedStation[i] != null)
        if (mouseX>depSelectedStation[i].getSelectedPoint()[0] && mouseX<depSelectedStation[i].getSelectedPoint()[2] && mouseY>depSelectedStation[i].getSelectedPoint()[1] && mouseY<depSelectedStation[i].getSelectedPoint()[3]) {
          depSelectedStation[i].setCheckBox(false);
          depSelectedStation[i] = null;
        }
      if (arrSelectedStation[i] != null)
        if (mouseX>arrSelectedStation[i].getSelectedPoint()[0] && mouseX<arrSelectedStation[i].getSelectedPoint()[2] && mouseY>arrSelectedStation[i].getSelectedPoint()[1] && mouseY<arrSelectedStation[i].getSelectedPoint()[3]) {
          arrSelectedStation[i].setCheckBox(false);
          arrSelectedStation[i] = null;
        }
    }
    for (int i=trainIndex; i<trainName.length && i<trainIndex+maxIndex; i++)
      if (mouseX>trainList[i].getPoint()[0] && mouseX<trainList[i].getPoint()[2] && mouseY>trainList[i].getPoint()[1]-lineSpacing*trainIndex && mouseY<trainList[i].getPoint()[3]-lineSpacing*trainIndex && mouseY>60 && mouseY<540)
        trainList[i].setCheckBox(!trainList[i].getCheckBox());
    if (mouseX>renew.getPoint()[0] && mouseX<renew.getPoint()[2] && mouseY>renew.getPoint()[1] && mouseY<renew.getPoint()[3]) {
      thread("getData");
      renewColor = #FFC600;
    }
  }
}
void depPlaceList() {
  for (int i=depPlaceIndex; i<cityName.length && i<depPlaceIndex+maxIndex; i++) {
    if (!loading && mouseX>depPlaceList[i].getPoint()[0] && mouseX<depPlaceList[i].getPoint()[2] && mouseY>depPlaceList[i].getPoint()[1]-lineSpacing*depPlaceIndex && mouseY<depPlaceList[i].getPoint()[3]-lineSpacing*depPlaceIndex)
      fill(100);
    else if (i == depCity) fill(#808080);
    else fill(0);
    textAlign(LEFT, TOP);
    text(depPlaceList[i].getName(), depPlaceList[i].getPoint()[0], depPlaceList[i].getPoint()[1]-lineSpacing*depPlaceIndex);
  }
}

void arrPlaceList() {
  for (int i=arrPlaceIndex; i<cityName.length && i<arrPlaceIndex+maxIndex; i++) {
    if (!loading && mouseX>arrPlaceList[i].getPoint()[0] && mouseX<arrPlaceList[i].getPoint()[2] && mouseY>arrPlaceList[i].getPoint()[1]-lineSpacing*arrPlaceIndex && mouseY<arrPlaceList[i].getPoint()[3]-lineSpacing*arrPlaceIndex)
      fill(100);
    else if (i == arrCity) fill(#808080);
    else fill(0);
    textAlign(LEFT, TOP);
    text(arrPlaceList[i].getName(), arrPlaceList[i].getPoint()[0], arrPlaceList[i].getPoint()[1]-lineSpacing*arrPlaceIndex);
  }
}

void depStationList() {
  for (int i=depStationIndex; i<stationNum[depCity] && i<depStationIndex+maxIndex; i++) {
    if (!loading && mouseX>depStationList[depCity][i].getPoint()[0] && mouseX<depStationList[depCity][i].getPoint()[2] && mouseY>depStationList[depCity][i].getPoint()[1]-lineSpacing*depStationIndex && mouseY<depStationList[depCity][i].getPoint()[3]-lineSpacing*depStationIndex)
      fill(100);
    else if (depStationList[depCity][i].getCheckBox()) fill(#E53238);
    else fill(0);
    textAlign(LEFT, TOP);
    text(depStationList[depCity][i].getName(), depStationList[depCity][i].getPoint()[0], depStationList[depCity][i].getPoint()[1]-lineSpacing*depStationIndex);
  }
}

void arrStationList() {
  for (int i=arrStationIndex; i<stationNum[arrCity] && i<arrStationIndex+maxIndex; i++) {
    if (!loading && mouseX>arrStationList[arrCity][i].getPoint()[0] && mouseX<arrStationList[arrCity][i].getPoint()[2] && mouseY>arrStationList[arrCity][i].getPoint()[1]-lineSpacing*arrStationIndex && mouseY<arrStationList[arrCity][i].getPoint()[3]-lineSpacing*arrStationIndex)
      fill(100);
    else if (arrStationList[arrCity][i].getCheckBox()) fill(#0064DE);
    else fill(0);
    textAlign(LEFT, TOP);
    text(arrStationList[arrCity][i].getName(), arrStationList[arrCity][i].getPoint()[0], arrStationList[arrCity][i].getPoint()[1]-lineSpacing*arrStationIndex);
  }
}

void trainList() {
  for (int i=0; i<trainName.length; i++) {
    if (!loading && mouseX>trainList[i].getPoint()[0] && mouseX<trainList[i].getPoint()[2] && mouseY>trainList[i].getPoint()[1]-lineSpacing*trainIndex && mouseY<trainList[i].getPoint()[3]-lineSpacing*trainIndex)
      fill(100);
    else if (trainList[i].getCheckBox()) fill(trainColor[i]);
    else fill(0);
    textAlign(LEFT, TOP);
    text(trainList[i].getName(), trainList[i].getPoint()[0], trainList[i].getPoint()[1]);
  }
}

void depSelectedStationList() {
  for (int i=0; i<2; i++)
    if (depSelectedStation[i] != null) {
      fill(0);
      textAlign(LEFT, TOP);
      text(depSelectedStation[i].getName(), depSelectedStation[i].getSelectedPoint()[0], depSelectedStation[i].getSelectedPoint()[1]);
    }
}

void arrSelectedStationList() {
  for (int i=0; i<2; i++)
    if (arrSelectedStation[i] != null) {
      fill(0);
      textAlign(LEFT, TOP);
      text(arrSelectedStation[i].getName(), arrSelectedStation[i].getSelectedPoint()[0], arrSelectedStation[i].getSelectedPoint()[1]);
    }
}
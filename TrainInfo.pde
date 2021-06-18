class TrainInfo implements Comparable<TrainInfo> {
  private String depTime, arrTime, depStation, arrStation;
  private int train, index;

  TrainInfo(String depTime, String arrTime, String depStation, String arrStation, int train) {
    this.depTime = depTime.substring(0, 12);
    this.arrTime = arrTime.substring(0, 12);
    this.depStation = depStation;
    this.arrStation = arrStation;
    this.train = train;
  }

  void setIndex(int index) {
    this.index = index;
  }

  long getDepTime() {
    return Long.parseLong(depTime);
  }

  long getArrTime() {
    return Long.parseLong(arrTime);
  }

  String getDepStation() {
    return depStation;
  }

  String getArrStation() {
    return arrStation;
  }

  int getTrain() {
    return train;
  }

  int getIndex() {
    return index;
  }
  
  int compareTo(TrainInfo trainInfo) {
    if (this.getDepTime() < trainInfo.getDepTime()) return -1;
    else if (this.getDepTime() == trainInfo.getDepTime()) {
      if (this.getArrTime() < trainInfo.getArrTime()) return -1;
      else if (this.getArrTime() == trainInfo.getArrTime()) return 0;
    }
    return 1;
  }
}
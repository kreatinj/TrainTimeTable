class Station extends CheckBox {
  private int[] selectedPoint = new int[4];

  Station (String name, String code, int x1, int y1, int x2, int y2) {
    super.name = name;
    super.code = code;
    super.point[0] = x1;
    super.point[1] = y1;
    super.point[2] = x2;
    super.point[3] = y2;
    super.checkBox = false;
  }

  int[] getSelectedPoint() {
    return selectedPoint;
  }

  void setSelectedPoint(int[] selectedPoint) {
    for (int i=0; i<4; i++)
      this.selectedPoint[i] = selectedPoint[i];
  }
}
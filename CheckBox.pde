class CheckBox {
  private String name, code;
  private boolean checkBox;
  private int[] point = new int[4];

  private CheckBox () {
  }

  CheckBox (String name, int x1, int y1, int x2, int y2) {
    this.name = name;
    point[0] = x1;
    point[1] = y1;
    point[2] = x2;
    point[3] = y2;
    checkBox = false;
  }

  CheckBox (String name, String code, int x1, int y1, int x2, int y2) {
    this.name = name;
    this.code = code;
    point[0] = x1;
    point[1] = y1;
    point[2] = x2;
    point[3] = y2;
    checkBox = false;
  }

  String getName() {
    return name;
  }

  String getCode() {
    return code;
  }

  boolean getCheckBox() {
    return checkBox;
  }

  int[] getPoint() {
    return point;
  }

  void setCheckBox(boolean checkBox) {
    this.checkBox = checkBox;
  }
}
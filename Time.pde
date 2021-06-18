import java.util.Date;
import java.text.SimpleDateFormat;

class Time {
  private int hour, day, month, year;
  private float minute;
  private final int[] Month = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
  private int[][][] leapYear = new int[13][3][400];

  Time() {
    minute = minute();
    hour = hour();
    day  = day();
    month = month();
    year = year();
    leapYear[2][0][0] = 1;
    leapYear[2][1][0] = -1;
    leapYear[2][2][0] = 1;
  }

  Time(Time time) {
    year = time.getYear();
    month = time.getMonth();
    day = time.getDay();
    hour = time.getHour();
    minute = time.getMinute();
    leapYear[2][0][0] = 1;
    leapYear[2][1][0] = -1;
    leapYear[2][2][0] = 1;
  }

  Time(int year, int month, int day, int hour, float minute) {
    this.minute = minute;
    this.hour = hour;
    this.day  = day;
    this.month = month;
    this.year = year;
    leapYear[2][0][0] = 1;
    leapYear[2][1][0] = -1;
    leapYear[2][2][0] = 1;
  }

  int getYear() {
    return year;
  }

  int getMonth() {
    return month;
  }

  int getDay() {
    return day;
  }

  int getHour() {
    return hour;
  }

  float getMinute() {
    return minute;
  }

  void setYear(int year) {
    this.year = year;
  }

  void setMonth(int month) {
    this.month = month;
  }

  void setDay(int day) {
    this.day = day;
  }

  void setHour(int hour) {
    this.hour = hour;
  }

  void setMinute(float minute) {
    this.minute = minute;
  }

  void setTime(Time time) {
    year = time.getYear();
    month = time.getMonth();
    day = time.getDay();
    hour = time.getHour();
    minute = time.getMinute();
  }

  void setHalf() {
    minute+=10-minute%10;
  }

  String getDateString() {
    String date = str(100000000+(int)pow(10, 4)*year+(int)pow(10, 2)*month+day);
    return date.substring(1);
  }

  String getTimeString() {
    String time = str(10000+(int)pow(10, 2)*hour+(int)minute);
    return time.substring(1);
  }

  long getTime() {
    return Long.parseLong(this.getDateString()+this.getTimeString());
  }

  long timeGap(long time) throws Exception {
    SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmm");

    Date beginDate = formatter.parse(this.getDateString()+this.getTimeString());
    Date endDate = formatter.parse(String.valueOf(time));

    long diff = endDate.getTime() - beginDate.getTime();
    long diffDays = diff / (60*1000);

    return diffDays;
  }

  void calDate() {
    if (minute<0 || hour<0 || day<1 || month<1) {
      while (minute<0) {
        minute += 60;
        hour -= 1;
      }
      while (hour<0) {
        hour += 24;
        day -= 1;
      }
      while (day<1) {
        day += Month[month-2<0 ? month+10:month-2]+leapYear(year, month-1);
        month -= 1;
        if (month<1) {
          month = 12;
          year-=1;
        }
      }
      while (month<1) {
        month += 12;
        year -= 1;
      }
    }
    if (minute>=60 || hour>23 || day>Month[month-1]+leapYear(year, month) || month>12) {
      while (minute>=60) {
        minute-=60;
        hour+=1;
      }
      while (hour>23) {
        hour-=24;
        day+=1;
      }
      while (day>Month[month-1]+leapYear[month][0][year%4]+leapYear[month][1][year%100]+leapYear[month][2][year%400]) {
        day-=Month[month-1]+leapYear[month][0][year%4]+leapYear[month][1][year%100]+leapYear[month][2][year%400];
        month+=1;
        if (month>12) {
          month = 1;
          year+=1;
        }
      }
      while (month>12) {
        month-=12;
        year+=1;
      }
    }
  }

  int leapYear(int year, int month) {
    return leapYear[month][0][year%4]+leapYear[month][1][year%100]+leapYear[month][2][year%400];
  }
}
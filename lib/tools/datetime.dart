
Map<int, String> monthList = {
  1: 'январь',
  2: 'февраль',
  3: 'март',
  4: 'апрель',
  5: 'май',
  6: 'июнь',
  7: 'июль',
  8: 'август',
  9: 'сентябрь',
  10: 'октябрь',
  11: 'ноябрь',
  12: 'декабрь' 
};

Map<int, String> monthListMulti = {
  1: 'января',
  2: 'февраля',
  3: 'марта',
  4: 'апреля',
  5: 'мая',
  6: 'июня',
  7: 'июля',
  8: 'августа',
  9: 'сентября',
  10: 'октября',
  11: 'ноября',
  12: 'декабря' 
};

String greetByHour() {
  int hour = DateTime.now().hour;
  int index = _getGreetIndex(hour);
  List<String> greetsList = [
    'доброе утро',
    'добрый день',
    'добрый вечер',
    'доброй ночи'
  ];
  return greetsList[index];
}

String monthAndYear(DateTime time) {
  int month = time.month;
  int year = time.year;

  return '${monthList[month]} $year';
}

String monthDateYear(DateTime time) {
  int day = time.day;
  int month = time.month;
  int year = time.year;

  return '$day ${monthListMulti[month]} $year';
}

int _getGreetIndex(int hour) {
  if(hour >= 6 && hour <= 11){ 
    return 0;
  }
  else if(hour > 11 && hour <= 16){ 
    return 1;
  }
  else if(hour > 16 && hour <= 22){
    return 2;
  }
  else if(hour > 22 || hour < 6){ 
    return 3; 
  } 
  return 0;
}

Duration getCurrentTimeDuration() {
  DateTime now = DateTime.now();
  return Duration(hours: now.hour, minutes: now.minute, seconds: now.second);
}

DateTime getDurationIgnoredDate(DateTime time) {
  return DateTime.parse(time.toString().split(' ')[0]);
}

DateTime todayLastYear() {
  DateTime now = DateTime.now();
  return DateTime(now.year -1, now.month, now.day);
}

bool isDateInDateRange(DateTime date, DateTime from, DateTime to) {
  DateTime compareDate = getDurationIgnoredDate(date);
  DateTime rangeFrom = getDurationIgnoredDate(from);
  DateTime rangeTo = getDurationIgnoredDate(to);
  bool isAfterOrEqual = compareDate.isAfter(getDurationIgnoredDate(rangeFrom)) || compareDate.isAtSameMomentAs(getDurationIgnoredDate(rangeFrom));
  bool isBeforeOrEqual = compareDate.isBefore(getDurationIgnoredDate(rangeTo)) || compareDate.isAtSameMomentAs(getDurationIgnoredDate(rangeTo));
  return isAfterOrEqual && isBeforeOrEqual;
}

bool isDateBeforeOrEqual(DateTime sourceDate, DateTime compateDate) {
  DateTime sourceDataIgnoredTime = getDurationIgnoredDate(sourceDate);
  return sourceDataIgnoredTime.isBefore(getDurationIgnoredDate(compateDate)) || sourceDataIgnoredTime.isAtSameMomentAs(getDurationIgnoredDate(compateDate));
}
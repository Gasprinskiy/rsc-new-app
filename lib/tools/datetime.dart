
Map<int, String> MonthList = {
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

  return '${MonthList[month]} $year';
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
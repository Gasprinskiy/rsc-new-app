
Map<String, String> errMap = {
  'wrong-password': 'Не верный пароль',
  'wrong-email': 'Не верный адрес эл. почты',
  'no-content': 'Нет данных',
  'internal-error': 'Внутреняя ошибка сервера',
  'wrong-email-verification-code': 'Не верный код подтверждения',
  'data-allready-exist': 'Данные уже существуют'
};

String createErrorMessage(String message) {
  print('msg: $message');
  switch (message) {
    case 'wrong-password':
      return 'Не верный пароль';
    case 'wrong-email':
      return 'Не верный адрес эл. почты';
    case 'no-content':
      return 'Нет данных';
    case 'internal-error':
      return 'Внутреняя ошибка сервера';
    case 'wrong-email-verification-code':
      return 'Не верный код подтверждения';
    case 'data-allready-exist':
      return 'Данные уже существуют';
    case 'no-server-connection':
      return 'Сервер не доступен, попробуйте позже';
    default:
      return 'Внутреняя ошибка сервера';
  }
}

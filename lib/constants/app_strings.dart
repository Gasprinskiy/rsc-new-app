class AppStrings {
  const AppStrings._();

  static const String appStorageKey = 'app_storage';
  static const String userStorageKey = 'user_storage';
  static const String accountingStorageKey = 'accounting_storage';
  static const String confirmationDateStore = 'email_confirmation_date_storage';
  static const String biometricsSettingsStoreKey =
      'biometrics_settings_storage';
  static const String pincodeStorageKey = 'pincode_storage';
  static const String tokenStorageKey = 'acces_token';

  static const String wellcome = 'Добро пожаловать';
  static const String loginToYouAccount = 'Войдите в свою учетную \nзапись.';
  static const String createAccount = 'Создайте учетную запись';
  static const String typeYourSalaryInfo = 'Введите данные о зарплате';
  static const String confirmYourEmail = 'Подтверждение почты';
  static const String confirmationCodeExpiresIn = 'Код истекает через:';
  static const String regiser = 'Регистрация';

  static const String createPinCode = 'Cоздайте пин код для входа';
  static const String typePinCode = 'Введите пин код для входа';
  // static const String cofirmPinCode = 'Подтвердите пин код';

  static const String confirmationCodeWasSentToYourEmail =
      'На вашу почту был отправлен 4х значный код, введите его';
  static const String confirmationCodeCouldBeInSpam =
      'Письма могут попасть в папку "Cпам"';
  static const String requestNewCode = 'Отправить код заного';

  static const String email = 'Адрес электронной почты';
  static const String pleaseEnterEmailAddress = 'Пожалуйста введите свою почту';
  static const String name = 'Имя';
  static const String verificationCode = 'Код потдверждения';
  static const String pleaseEnterYourName = 'Пожалуйста введите свое имя';
  static const String invalidEmailAddress = 'Не валидный адрес эл. почты';
  static const String skipEmailConfrimation = 'Пропустить подтвержение почты';
  static const String pleaseEnterConfirmationCode =
      'Пожалуйста введите код подтверждения';
  static const String password = 'Пароль';
  static const String confirmPasswor = 'Подтвердите пароль';
  static const String pleaseEnterPassword = 'Пожалуйста введите пароль';
  static const String pleaseConfirmPasswor = 'Пожалуйста подтвердите пароль';
  static const String passwordDoesNotMatch = 'Пароли не совпадают';
  static const String invalidPassword = 'Не валидный пароль';
  static const String login = 'Войти';
  static const String authRequired = 'Требуется авторизация';
  static const String useBiometricsForAuthification =
      'Использовать беометрию для входа в приложения?';

  static const String salary = 'Оклад';
  static const String percentFromSales = 'Процент от продаж';
  static const String plan = 'План';
  static const String pleaseEnterYourSalary = 'Пожалуйста введидите свой оклад';
  static const String pleaseEnterYourPercentFromSales =
      'Пожалуйста введидите процент от продаж';
  static const String pleaseEnterPlan = 'Пожалуйста введите план';
  static const String variablePercent = 'Переменчивый процент';
  static const String ignorePlan = 'Игнорировать план';
  static const String planGoal = 'Процент выполнения плана';
  static const String pleaseEnterPlanGoal =
      'Пожалуйста введите процент при выполнении';
  static const String percentChangeOnGoalReached =
      'Процент от продаж при выполнении';
  static const String bountyOnGoalReached = 'Премия при выполнении';

  static const String save = 'Сохранить';
  static const String addConditionds = 'Добавить условие смены процента';
  static const String add = 'Добавить';
  static const String condition = 'Условие';

  static const String areYouSure = 'Вы уверены?';
  static const String confirm = 'Подтвердить';
  static const String cancel = 'Отменить';
  static const String close = 'Закрыть';
  static const String proceed = 'Продолжить';
  static const String tiChoYebanulsa = 'Ты че ебанулся?';
  static const String yes = 'Да';
  static const String no = 'Нет';

  static const String forgotPassword = 'Забыли пароль?';
  static const String or = 'Или';
  static const String doNotHaveAnAccount = 'Нет учетной записи?';
  static const String register = 'Зарегестрируйтесь';
  static const String regiserMe = 'Зарегестрироватся';

  static const noInternetConnection = 'Нет соединения с интернетом';
  static const errOnWritingData = 'Ошибка при записи данных';

  // common input error
  static const String fieldCannotBeEmpty = 'Поле не может быть пустым';

  // descriptions
  static const String emailConfirmSkipDescription =
      'Пропуск подтвержение эл. почты лишает вас возможности синхронизации даных с облаком';
  static const String variablePercentDescription =
      'Дает возможность гибко настроить подсчет зарплаты, если Ваш процент от продаж меняется в зависимости от выполнения плана то вы можете добавить условия смены процента.';
  static const String ignorePlanDescription =
      'Приложение будет исключать план при подсчете процента от продаж и начнет считать процент от продаж только по достижению заданных вами условий';

  static const String percentChangeConditionsEmpty =
      'Не добавлены условия смены процента';
}

class CommonStrings {
  CommonStrings._();

  static const String areYouSure = 'Вы уверены?';
  static const String confirm = 'Подтвердить';
  static const String cancel = 'Отменить';
  static const String or = 'Или';
  static const String add = 'Добавить';
  static const String save = 'Сохранить';

  static const String fieldCannotBeEmpty = 'Поле не может быть пустым';
}

class StorageKeys {
  StorageKeys._();

  static const String appStorageKey = 'app_storage';
  static const String userStorageKey = 'user_storage';
  static const String confirmationDateStore = 'email_confirmation_date_storage';
}

class ErrorStrings {
  ErrorStrings._();

  static const noInternetConnection = 'Нет соединения с интернетом';
  static const errOnWritingData = 'Ошибка при записи данных';
}

class AuthAndRegisterPageStrings {
  AuthAndRegisterPageStrings._();

  static const String registration = 'Регистрация';
  static const String createAccount = 'Создайте учетную запись';

  static const String name = 'Имя';
  static const String email = 'Адрес электронной почты';

  static const String emailConfirmSkipDescription =
      'Пропуск подтвержение эл. почты лишает вас возможности синхронизации даных с облаком';
}

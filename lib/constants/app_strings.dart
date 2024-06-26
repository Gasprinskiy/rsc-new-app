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
  static const String syncStorageKey = 'sync_storage';

  static const String wellcome = 'Добро пожаловать';
  static const String loginToYouAccount = 'Войдите в свою учетную \nзапись.';
  static const String createAccount = 'Создайте учетную запись';
  static const String typeYourSalaryInfo = 'Введите данные по зарплате';
  static const String salaryInfo = 'Данные по зарплате';
  static const String confirmYourEmail = 'Подтверждение почты';
  static const String confirmationCodeExpiresIn = 'Код истекает через:';
  static const String regiser = 'Регистрация';
  static const String logout = 'Выйти';

  static const String archivate = 'Архивировать';
  static const String archive = 'Архив';

  static const String statistics = 'Статистика';

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
  static const String planGoal = 'При выполнении плана на';
  static const String pleaseEnterPlanGoal =
      'Пожалуйста введите процент при выполнении';
  static const String percentChangeOnGoalReached = 'Процент от продаж будет';
  static const String bountyOnGoalReached = 'Премия при выполнении';

  static const String finalSalary = 'Итоговая зарплата';
  static const String finalSalaryShort = 'Зарплата';
  static const String commonSalary = 'Общая зарплата';

  static const String save = 'Сохранить';
  static const String conditiondOfPercentChange = 'условие смены процента';
  static const String add = 'Добавить';
  static const String redact = 'Редактировать';
  static const String condition = 'Условие';
  static const String changePassword = 'Сменить пароль';
  static const String loadMore = 'Зазгрузить еще';

  static const String areYouSure = 'Вы уверены?';
  static const String confirm = 'Подтвердить';
  static const String cancel = 'Отменить';
  static const String close = 'Закрыть';
  static const String proceed = 'Продолжить';
  static const String tiChoYebanulsa = 'Ты че ебанулся?';
  static const String yes = 'Да';
  static const String no = 'Нет';
  static const String start = 'Начать';

  static const String forgotPassword = 'Забыли пароль?';
  static const String or = 'Или';
  static const String doNotHaveAnAccount = 'Нет учетной записи?';
  static const String register = 'Зарегестрируйтесь';
  static const String regiserMe = 'Зарегестрироватся';

  static const String noInternetConnection = 'Нет соединения с интернетом';
  static const String errOnWritingData = 'Ошибка при записи данных';
  static const String unreqError = 'Неопознанная ошибка';
  static const String couldNotSyncData = 'Не удалось синхронизовать данные';
  static const String couldNotSyncUserData = 'Не удалось синхронизовать данные пользователя';
  static const String dataStoredInLocalStorage = 'Данные добавлены';
  static const String dataUpdated = 'Данные обновлены';
  static const String dataStoredAndSyncronized = 'Данные добавлены и синхронизированы';
  static const String reportCreatedAndSyncronized = 'Отчет создан и синхронизован';
  static const String reportArchivated = 'Отчет архивирован';
  static const String reportCreated = 'Отчет создан';
  static const String dataUpdatedAndSyncronized = 'Данные обновлены и синхронизированы';
  static const String dataSyncronized = 'Данные синхронизированы';
  static const String noDataToSync = 'Нет данных для синхронизации';
  static const String noDataReportFound = 'Новый отчет нe начат';
  static const String noData = 'Нет данных';
  static const String commonDataWillBeInThisBlock = 'Тут будут появлятся общие данные по текущему отчету в процессе работы с приложением';
  static const String salesNotFound = 'Продажи не найдены';
  static const String tipsNotFound = 'Чаевые не найдены';
  static const String prepaymentsNotFound = 'Авансы не найдены';
  static const String dataNotFound = 'Данные не найдены';
  static const String cannotArchivateUnsyncReport = 'Нельзя архивировать не синхронизированный отчет';
  static const String allUnsycDataWillBeRemoved = 'Все несинхронизированные данные будут утеряны';

  static const String curreReportData = 'Текущий отчет';
  static const String reportNotFound = 'Текущий отчет не найден';
  static const String startNewReport = 'Начать новый отчет';
  static const String areYouSureYouWantArhivateReport = 'Вы уверены что хотите архивировать текущий отчет?';
  static const String recentActions = 'За последнее время';
  static const String started = 'Начало';
  static const String planProgress = 'Прогресс плана';
  static const String creationDate = 'Дата создания';
  static const String date = 'Дата';
  static const String reportBy = 'Отчет за';
  static const String monthDiagram = 'По месяцам';

  static const String from = 'От';
  static const String to = 'До';

  static const String apply = 'Применить';
  static const String reset = 'Сбросить';

  static const String saleStored = 'Продажа добавлена';

  static const String sales = 'Продажи';
  static const String recordSales = 'Рекордные продажи';
  static const String commonSales = 'Общие продажи';
  static const String recordSalary = 'Рекордная зарплата';
  static const String tips = 'Чаевые';
  static const String prepayments = 'Авансы';
  static const String sale = 'Продажа';
  static const String tip = 'Чаевые';
  static const String prepayment = 'Аванс';
  static const String total = 'Общее';
  static const String commoData = 'Общие данные';
  static const String detailData = 'Детальные данные';
  static const String cashTaxes = 'Инкасация';
  static const String nonCash = 'Без нал';

  static const String commonDiagram = 'Общая диаграмма';
  static const String commonData = 'Общие данные';

  static const String saleAddRedact = 'продажу';
  static const String tipAddRedact = 'чаевые';
  static const String prepaymentAddRedact = 'аванс';

  static const String amount = 'Суммарно';
  static const String lastYear = 'Прошлый год'; 
  static const String lastYearThisMonth = 'Год назад этот месяц';
  static const String progress = 'Прогресс';
  static const String recordData = 'Рекордные показатели';
  static const String avarageData = 'Средние показатели';

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

  static String syncDataCount(int synchronized, int all) {
    return 'Синхронизовано $synchronized из $all';
  }
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

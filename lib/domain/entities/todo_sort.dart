enum TodoSort { manual, newest, oldest, alphabetical }

extension TodoSortX on TodoSort {
  String get label {
    switch (this) {
      case TodoSort.manual:
        return 'Вручную';
      case TodoSort.newest:
        return 'Новые';
      case TodoSort.oldest:
        return 'Старые';
      case TodoSort.alphabetical:
        return 'А–Я';
    }
  }
}

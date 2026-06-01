enum TodoFilter { all, active, completed }

extension TodoFilterX on TodoFilter {
  String get label {
    switch (this) {
      case TodoFilter.all:
        return 'Все';
      case TodoFilter.active:
        return 'Активные';
      case TodoFilter.completed:
        return 'Готовые';
    }
  }
}

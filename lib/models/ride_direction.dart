enum RideDirection {
  homeToWork,
  workToHome,
}

extension RideDirectionExtension on RideDirection {
  String get label {
    switch (this) {
      case RideDirection.homeToWork:
        return 'Casa → Trabalho';
      case RideDirection.workToHome:
        return 'Trabalho → Casa';
    }
  }

  String get helperText {
    switch (this) {
      case RideDirection.homeToWork:
        return 'Ideal para o início do expediente';
      case RideDirection.workToHome:
        return 'Pensado para o retorno para casa';
    }
  }

  String get apiValue {
    switch (this) {
      case RideDirection.homeToWork:
        return 'home_to_work';
      case RideDirection.workToHome:
        return 'work_to_home';
    }
  }
}

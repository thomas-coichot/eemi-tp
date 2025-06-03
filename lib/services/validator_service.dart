class ValidatorService {
  static String? isRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le champ est requis';
    }
    return null;
  }

  static String? isUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le champ est requis';
    }

    final urlPattern = r'^(https?:\/\/)?([\w\-]+\.)+[a-zA-Z]{2,}(:\d+)?(\/\S*)?$';
    final regExp = RegExp(urlPattern);

    if (!regExp.hasMatch(value)) {
      return 'Veuillez entrer une URL valide';
    }

    return null;
  }
}

class CreateRecipeController {
  String title = '';
  String country = '';
  bool isHalal = false;
  String time = '';
  String serving = '';
  List<String> ingredients = [];
  List<String> steps = [];
  List<Map<String, String>> nutritions = [];

  void setTitle(String value) => title = value;
  void setCountry(String value) => country = value;
  void setHalal(bool value) => isHalal = value;
  void setTime(String value) => time = value;
  void setServing(String value) => serving = value;
  void setIngredients(List<String> value) => ingredients = value;
  void setSteps(List<String> value) => steps = value;
  void setNutritions(List<Map<String, String>> value) => nutritions = value;

  void removeIngredientAt(int index) {
    if (index >= 0 && index < ingredients.length) {
      ingredients.removeAt(index);
    }
  }

  void removeStepAt(int index) {
    if (index >= 0 && index < steps.length) {
      steps.removeAt(index);
    }
  }

  void removeNutritionAt(int index) {
    if (index >= 0 && index < nutritions.length) {
      nutritions.removeAt(index);
    }
  }

  void clearAll() {
    title = '';
    country = '';
    isHalal = false;
    time = '';
    serving = '';
    ingredients.clear();
    steps.clear();
    nutritions.clear();
  }
}

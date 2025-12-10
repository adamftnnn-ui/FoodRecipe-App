import 'package:flutter/material.dart';

class ProfileController {
  final ValueNotifier<Map<String, dynamic>> userNotifier =
      ValueNotifier(<String, dynamic>{
        'name': 'Nama User',
        'country': 'Indonesia',
        'gender': 'Laki-laki',
        'avatarUrl': '',
        'uploads': 0,
      });

  final ValueNotifier<List<Map<String, dynamic>>> userRecipes = ValueNotifier(
    <Map<String, dynamic>>[],
  );

  void addRecipe(Map<String, dynamic> recipe) {
    userRecipes.value = [...userRecipes.value, recipe];
    _updateUploadCount();
  }

  void removeRecipeAt(int index) {
    if (index >= 0 && index < userRecipes.value.length) {
      final temp = [...userRecipes.value];
      temp.removeAt(index);
      userRecipes.value = temp;
      _updateUploadCount();
    }
  }

  void updateRecipeAt(int index, Map<String, dynamic> newData) {
    if (index >= 0 && index < userRecipes.value.length) {
      final temp = [...userRecipes.value];
      temp[index] = newData;
      userRecipes.value = temp;
      _updateUploadCount();
    }
  }

  void _updateUploadCount() {
    final current = Map<String, dynamic>.from(userNotifier.value);
    current['uploads'] = userRecipes.value.length;
    userNotifier.value = current;
  }

  void updateUser(Map<String, dynamic> newUserData) {
    userNotifier.value = {...userNotifier.value, ...newUserData};
  }

  void clearAll() {
    userNotifier.value = <String, dynamic>{
      'name': '',
      'country': '',
      'gender': '',
      'avatarUrl': '',
      'uploads': 0,
    };
    userRecipes.value = <Map<String, dynamic>>[];
  }
}

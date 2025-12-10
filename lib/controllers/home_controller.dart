import '../models/user_model.dart';
import '../models/recipe_model.dart';
import '../models/event_model.dart';
import '../repositories/user_repository.dart';
import '../repositories/recipe_repository.dart';
import '../repositories/event_repository.dart';

class HomeController {
  final UserRepository userRepository;
  final RecipeRepository recipeRepository;
  final EventRepository eventRepository;

  HomeController({
    UserRepository? userRepository,
    RecipeRepository? recipeRepository,
    EventRepository? eventRepository,
  }) : userRepository = userRepository ?? UserRepository(),
       recipeRepository = recipeRepository ?? RecipeRepository(),
       eventRepository = eventRepository ?? EventRepository();

  Future<UserModel> fetchUser() {
    return userRepository.fetchUser();
  }

  Future<List<String>> fetchSuggestions() {
    return recipeRepository.fetchSuggestions();
  }

  Future<List<RecipeModel>> fetchTrendingRecipes() {
    return recipeRepository.fetchTrendingRecipes();
  }

  Future<List<EventModel>> fetchEvents() {
    return eventRepository.fetchEvents();
  }
}

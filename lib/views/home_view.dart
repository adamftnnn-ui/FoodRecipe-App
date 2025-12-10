import 'package:flutter/material.dart';
import '/views/recipe_list_view.dart';
import '../models/user_model.dart';
import '../models/recipe_model.dart';
import '../models/event_model.dart';
import '../controllers/home_controller.dart';
import '../widgets/banner_widget.dart';
import '../widgets/header_widget.dart';
import '../widgets/category_widget.dart';
import '../widgets/search_bar.dart';
import '../widgets/suggestion_widget.dart';
import '../widgets/trending_widget.dart';
import '../widgets/event_widget.dart';
import '../views/create_recipe_view.dart';
import '../views/chat_view.dart';
import '../views/profile_view.dart';
import '../controllers/create_recipe_controller.dart';
import '../controllers/profile_controller.dart';
import 'package:hugeicons/hugeicons.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController _homeController = HomeController();
  UserModel? _user;
  List<String> _suggestions = [];
  List<RecipeModel> _trendingRecipes = [];
  List<EventModel> _events = [];
  bool _isLoading = true;
  String? _error;
  int _selectedIndex = 0;

  final createController = CreateRecipeController();
  final profileController = ProfileController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _homeController.fetchUser(),
        _homeController.fetchSuggestions(),
        _homeController.fetchTrendingRecipes(),
        _homeController.fetchEvents(),
      ]);
      setState(() {
        _user = results[0] as UserModel;
        _suggestions = results[1] as List<String>;
        _trendingRecipes = results[2] as List<RecipeModel>;
        _events = results[3] as List<EventModel>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget _buildNavItem({
    required IconData iconData,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: isActive ? Colors.green[500] : Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(iconData, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.green[500] : Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(body: Center(child: Text('Error: $_error')));
    }

    // PAGES sekarang dibangun di sini, menggunakan data state TERBARU
    final pages = [
      HomeContent(
        user: _user,
        suggestions: _suggestions,
        trendingRecipes: _trendingRecipes,
        events: _events,
      ),
      CreateRecipeView(
        controller: createController,
        profileController: profileController,
        onRecipePosted: () {
          setState(() {
            _selectedIndex = 3;
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecipeListView(
                initialKeyword: '',
                title: 'Daftar Resepku',
                recipes: profileController.userRecipes.value,
                showDelete: true,
                profileController: profileController,
              ),
            ),
          );
        },
      ),
      const ChatView(),
      ProfileView(controller: profileController),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              iconData: HugeIcons.strokeRoundedHome01,
              label: 'Beranda',
              isActive: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            _buildNavItem(
              iconData: HugeIcons.strokeRoundedAddSquare,
              label: 'Buat Resep',
              isActive: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            _buildNavItem(
              iconData: HugeIcons.strokeRoundedBubbleChat,
              label: 'Obrolan',
              isActive: _selectedIndex == 2,
              onTap: () => _onItemTapped(2),
            ),
            _buildNavItem(
              iconData: HugeIcons.strokeRoundedUser,
              label: 'Profil',
              isActive: _selectedIndex == 3,
              onTap: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final UserModel? user;
  final List<String> suggestions;
  final List<RecipeModel> trendingRecipes;
  final List<EventModel> events;

  const HomeContent({
    super.key,
    required this.user,
    required this.suggestions,
    required this.trendingRecipes,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          HeaderWidget(user: user!),
          BannerWidget(
            banners: [
              'assets/images/banner1.png',
              'assets/images/banner2.png',
              'assets/images/banner3.png',
            ],
          ),
          const CategoryWidget(),
          SearchBarr(
            placeholder: 'Cari resep atau bahan...',
            enableNavigation: true,
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 8),
          ),
          SuggestionWidget(suggestions: suggestions),
          TrendingWidget(recipes: trendingRecipes),
          EventWidget(events: events),
        ],
      ),
    );
  }
}

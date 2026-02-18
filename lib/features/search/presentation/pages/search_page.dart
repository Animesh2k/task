import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final List<String> _recentSearches = [
      t.search.items.weatherForecast,
      t.search.items.locationServices,
      t.search.items.appSettings,
    ];
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Obx(
              () => Container(
                decoration: BoxDecoration(gradient: AppColors.mainGradient),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.glassBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: AppColors.white),
                      decoration: InputDecoration(
                        hintText: t.search.placeholder,
                        hintStyle: TextStyle(color: AppColors.textWhite70),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.textWhite70,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: AppColors.textWhite70,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                  });
                                },
                              )
                            : const SizedBox.shrink(),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Recent Searches
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.search.recentSearches,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 20),
                        ..._recentSearches.map(
                          (search) =>
                              _buildSearchItem(context, search, Icons.history),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          t.search.suggestions,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 20),
                        _buildSearchItem(
                          context,
                          t.search.items.weather,
                          Icons.wb_sunny_outlined,
                        ),
                        const SizedBox(height: 12),
                        _buildSearchItem(
                          context,
                          t.search.items.profile,
                          Icons.person_outline,
                        ),
                        const SizedBox(height: 12),
                        _buildSearchItem(
                          context,
                          t.search.items.settings,
                          Icons.settings_outlined,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchItem(BuildContext context, String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.white),
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: AppColors.textWhite70, size: 16),
        ],
      ),
    );
  }
}

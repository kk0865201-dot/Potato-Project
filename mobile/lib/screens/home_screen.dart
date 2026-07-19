import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../models/variety.dart';
import '../providers/auth_provider.dart';
import '../providers/varieties_provider.dart';
import '../utils/debouncer.dart';
import '../widgets/potato_3d_viewer.dart';
import '../widgets/potato_background.dart';
import '../widgets/potato_card.dart';
import '../widgets/remote_image.dart';
import '../widgets/status_view.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer();

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debouncer.run(() {
      if (!mounted) return;
      context.read<VarietiesProvider>().setSearch(query);
    });
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.pixels >
        notification.metrics.maxScrollExtent - 300) {
      context.read<VarietiesProvider>().loadMore();
    }
    return false;
  }

  void _openDetails(Variety item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailsScreen(item: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<VarietiesProvider>();
    final userName = context.watch<AuthProvider>().user?.name;
    final items = provider.items;
    final featured = provider.featured;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PotatoBackground(
        child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName != null
                        ? 'home_greeting_user'.tr(args: [userName])
                        : 'home_greeting'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode
                          ? AppColors.darkSubtext
                          : AppColors.lightSubtext,
                    ),
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 4),
                  Text(
                    'home_title'.tr(),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? AppColors.darkText
                          : AppColors.lightText,
                    ),
                  ).animate().fadeIn(duration: 500.ms).slideX(
                        begin: -0.1,
                        end: 0,
                        duration: 500.ms,
                      ),
                  const SizedBox(height: 16),

                  // Search bar — queries the Laravel API (?search=)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.darkCard : Colors.grey[100],
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: isDarkMode
                              ? AppColors.darkSubtext
                              : AppColors.lightSubtext,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: _onSearchChanged,
                            style: TextStyle(
                              color: isDarkMode
                                  ? AppColors.darkText
                                  : AppColors.lightText,
                              fontSize: 15,
                            ),
                            decoration: InputDecoration(
                              hintText: 'search_potatoes'.tr(),
                              hintStyle: TextStyle(
                                color: isDarkMode
                                    ? AppColors.darkSubtext
                                    : AppColors.lightSubtext,
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        if (provider.search.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              context.read<VarietiesProvider>().setSearch('');
                            },
                            child: Icon(
                              Icons.close,
                              size: 20,
                              color: isDarkMode
                                  ? AppColors.darkSubtext
                                  : AppColors.lightSubtext,
                            ),
                          ),
                      ],
                    ),
                  ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
                ],
              ),
            ),

            // Content — loading / error / empty / data
            Expanded(
              child: StatusView(
                state: provider.state,
                isEmpty: items.isEmpty,
                error: provider.error,
                onRetry: () => context.read<VarietiesProvider>().load(),
                emptyTitleKey: 'no_results',
                child: RefreshIndicator(
                  color: AppColors.potatoPrimary,
                  onRefresh: () => context.read<VarietiesProvider>().load(),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: _onScrollNotification,
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        // Interactive 3D potato hero (same model as the website).
                        if (provider.search.isEmpty) ...[
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                              child: Text(
                                'explore_3d'.tr(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: isDarkMode
                                      ? AppColors.darkText
                                      : AppColors.lightText,
                                ),
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: Potato3DViewer(height: 280),
                          ),
                        ],

                        if (featured.isNotEmpty && provider.search.isEmpty) ...[
                          SliverToBoxAdapter(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 12, 20, 0),
                              child: Text(
                                'featured_potatoes'.tr(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: isDarkMode
                                      ? AppColors.darkText
                                      : AppColors.lightText,
                                ),
                              ),
                            ),
                          ),

                          // Featured horizontal list
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: 200,
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    featured.length > 4 ? 4 : featured.length,
                                itemBuilder: (context, index) {
                                  return _buildFeaturedCard(
                                    context,
                                    featured[index],
                                    isDarkMode,
                                  );
                                },
                              ),
                            ).animate().fadeIn(duration: 500.ms).slideX(
                                  begin: 0.1,
                                  end: 0,
                                  duration: 500.ms,
                                ),
                          ),
                        ],

                        // All potatoes section label
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                            child: Text(
                              'all_potatoes'.tr(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: isDarkMode
                                    ? AppColors.darkText
                                    : AppColors.lightText,
                              ),
                            ),
                          ),
                        ),

                        // Grid of potato cards
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              childAspectRatio: 0.75,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final item = items[index];
                                return PotatoCard(
                                  item: item,
                                  onTap: () => _openDetails(item),
                                );
                              },
                              childCount: items.length,
                            ),
                          ),
                        ),

                        // Lazy-loading footer
                        SliverToBoxAdapter(
                          child: provider.isLoadingMore
                              ? const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.potatoPrimary,
                                    ),
                                  ),
                                )
                              : const SizedBox(height: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(
      BuildContext context, Variety item, bool isDarkMode) {
    return GestureDetector(
      onTap: () => _openDetails(item),
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.potatoPrimary,
              AppColors.potatoPrimaryDark,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.potatoPrimary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image from the API
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: RemoteImage(
                    url: item.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    accentColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, size: 14, color: AppColors.starYellow),
                  const SizedBox(width: 4),
                  Text(
                    item.rating.toString(),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

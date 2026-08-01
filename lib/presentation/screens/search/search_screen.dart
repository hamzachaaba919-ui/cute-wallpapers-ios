import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../domain/entities/wallpaper_entity.dart';
import '../../../providers/wallpaper_provider.dart';
import '../../../services/local_storage_service.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/wallpaper/wallpaper_grid.dart';

/// The Search tab: instant, local search over the bundled catalog (title,
/// collection, tags) plus a small list of recent searches persisted on
/// device. No network request is ever made.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _recentSearches = const [];
  String _query = '';

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
    _loadRecentSearches();
  }

  void _onFocusChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadRecentSearches() async {
    final List<String> recent =
        await context.read<LocalStorageService>().getStringList(AppConstants.prefKeyRecentSearches);
    if (mounted) setState(() => _recentSearches = recent);
  }

  Future<void> _commitSearch(String query) async {
    final String trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final List<String> updated = [trimmed, ..._recentSearches.where((entry) => entry != trimmed)]
        .take(AppConstants.maxRecentSearches)
        .toList(growable: false);

    setState(() => _recentSearches = updated);
    await context.read<LocalStorageService>().setStringList(AppConstants.prefKeyRecentSearches, updated);
  }

  Future<void> _clearRecentSearches() async {
    setState(() => _recentSearches = const []);
    await context.read<LocalStorageService>().remove(AppConstants.prefKeyRecentSearches);
  }

  void _applyQuery(String value) {
    _controller.text = value;
    _controller.selection = TextSelection.collapsed(offset: value.length);
    setState(() => _query = value);
    _commitSearch(value);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasQuery = _query.trim().isNotEmpty;
    final List<WallpaperEntity> results =
        hasQuery ? context.watch<WallpaperProvider>().search(_query) : const [];

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.pageHorizontalPadding,
              AppDimensions.space16,
              AppDimensions.pageHorizontalPadding,
              AppDimensions.space8,
            ),
            child: Text('Search', style: AppTextStyles.displayMedium),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.pageHorizontalPadding,
              vertical: AppDimensions.space16,
            ),
            child: AnimatedScale(
              scale: _focusNode.hasFocus ? 1.015 : 1,
              duration: const Duration(milliseconds: AppDimensions.durationMedium),
              curve: Curves.easeOutCubic,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: AppDimensions.durationMedium),
                curve: Curves.easeOutCubic,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                  border: Border.all(
                    color: _focusNode.hasFocus ? AppColors.primary : Colors.transparent,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _focusNode.hasFocus
                          ? AppColors.primary.withValues(alpha: 0.24)
                          : AppColors.shadow,
                      blurRadius: _focusNode.hasFocus ? 22 : 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: AppDimensions.durationMedium),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: Icon(
                        Icons.search_rounded,
                        key: ValueKey<bool>(_focusNode.hasFocus),
                        color: _focusNode.hasFocus ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.space12),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: AppTextStyles.bodyMedium,
                        textInputAction: TextInputAction.search,
                        onChanged: (value) => setState(() => _query = value),
                        onSubmitted: _commitSearch,
                        decoration: InputDecoration(
                          hintText: 'Cute, kawaii, animals, pink…',
                          hintStyle: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary.withValues(alpha: 0.55),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (hasQuery)
                      IconButton(
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                        icon: const Icon(Icons.close_rounded, size: 20),
                        color: AppColors.textSecondary,
                        tooltip: 'Clear search',
                      ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: hasQuery
                ? (results.isEmpty
                    ? const EmptyState(
                        icon: Icons.search_off_rounded,
                        title: 'No wallpapers found',
                        message: 'Try a different word, like a collection name or a mood.',
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.only(top: AppDimensions.space8),
                        child: WallpaperGrid(wallpapers: results, shrinkWrap: true),
                      ))
                : _RecentSearches(
                    recent: _recentSearches,
                    onTap: _applyQuery,
                    onClear: _recentSearches.isEmpty ? null : _clearRecentSearches,
                  ),
          ),
          SizedBox(height: context.bottomSafeArea),
        ],
      ),
    );
  }
}

class _RecentSearches extends StatelessWidget {
  const _RecentSearches({required this.recent, required this.onTap, this.onClear});

  final List<String> recent;
  final ValueChanged<String> onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    if (recent.isEmpty) {
      return const EmptyState(
        icon: Icons.history_rounded,
        title: 'No recent searches',
        message: 'Wallpapers you search for will show up here for quick access.',
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageHorizontalPadding),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent searches', style: AppTextStyles.overline),
            GestureDetector(
              onTap: onClear,
              child: Text('Clear', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.space12),
        Wrap(
          spacing: AppDimensions.space8,
          runSpacing: AppDimensions.space8,
          children: [
            for (final String query in recent)
              GestureDetector(
                onTap: () => onTap(query),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.space16,
                    vertical: AppDimensions.space8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                    boxShadow: const [
                      BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.history_rounded, size: AppDimensions.iconSizeSmall, color: AppColors.primary),
                      const SizedBox(width: AppDimensions.space8),
                      Text(query, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

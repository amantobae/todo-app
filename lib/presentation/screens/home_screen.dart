import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/constants/app_spacing.dart';
import 'package:todo_app/core/theme/app_colors.dart';
import 'package:todo_app/core/theme/app_gradients.dart';
import 'package:todo_app/core/theme/app_theme_extensions.dart';
import 'package:todo_app/core/utils/responsive.dart';
import 'package:todo_app/core/widgets/cyber_background.dart';
import 'package:todo_app/presentation/controllers/todo_controller.dart';
import 'package:todo_app/presentation/widgets/app_button.dart';
import 'package:todo_app/presentation/widgets/filter_sort_bar.dart';
import 'package:todo_app/presentation/widgets/neon_fab.dart';
import 'package:todo_app/presentation/widgets/stats_panel.dart';
import 'package:todo_app/presentation/widgets/todo_form_dialog.dart';
import 'package:todo_app/presentation/widgets/todo_list_view.dart';
import 'package:todo_app/presentation/widgets/todo_search_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodoController>().initialize();
    });
  }

  Future<void> _openAddDialog() async {
    final result = await showTodoFormDialog(context: context);
    if (result != null && mounted) {
      await context.read<TodoController>().addTodo(
            title: result.$1,
            description: result.$2,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TodoController>();
    final padding = context.screenPadding;
    final maxWidth = context.contentMaxWidth;
    final screenSize = screenSizeOf(context);
    final isDesktop = screenSize == ScreenSize.desktop;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CyberBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final mainContent = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HomeHeader(
                    activeCount: controller.activeCount,
                    showAddButton: isDesktop,
                    onAddPressed: _openAddDialog,
                  ),
                  if (!isDesktop) ...[
                    const SizedBox(height: AppSpacing.lg),
                    StatsPanel(controller: controller, compact: true),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  TodoSearchField(
                    value: controller.searchQuery,
                    onChanged: controller.setSearchQuery,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const FilterSortBar(),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: TodoListView(onAddPressed: _openAddDialog),
                  ),
                ],
              );

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Padding(
                    padding: padding,
                    child: isDesktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 300,
                                child: StatsPanel(controller: controller),
                              ),
                              const SizedBox(width: AppSpacing.xxxl),
                              Expanded(child: mainContent),
                            ],
                          )
                        : mainContent,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: isDesktop
          ? null
          : Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: NeonFab(onPressed: _openAddDialog),
            ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.activeCount,
    required this.showAddButton,
    required this.onAddPressed,
  });

  final int activeCount;
  final bool showAddButton;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) =>
                    AppGradients.primary.createShader(bounds),
                child: Text(
                  'Neon Tasks',
                  style: theme.textTheme.displayLarge,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                activeCount == 0
                    ? 'Все задачи выполнены ✦'
                    : '$activeCount активных задач',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (showAddButton)
          AppButton(
            label: 'Новая задача',
            icon: Icons.add_rounded,
            onPressed: onAddPressed,
          ),
      ],
    );
  }
}

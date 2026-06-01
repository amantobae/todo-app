import 'package:flutter/material.dart';
import 'package:todo_app/core/constants/app_durations.dart';
import 'package:todo_app/core/theme/app_colors.dart';
import 'package:todo_app/core/theme/app_theme_extensions.dart';

class TodoSearchField extends StatefulWidget {
  const TodoSearchField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<TodoSearchField> createState() => _TodoSearchFieldState();
}

class _TodoSearchFieldState extends State<TodoSearchField> {
  late final TextEditingController _controller;
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void didUpdateWidget(TodoSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.tokens;

    return AnimatedContainer(
      duration: AppDurations.medium,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(tokens.inputRadius),
        boxShadow: _focused
            ? [
                BoxShadow(
                  color: AppColors.acidGreen.withOpacity(0.2),
                  blurRadius: 24,
                ),
              ]
            : null,
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        style: theme.textTheme.bodyMedium,
        cursorColor: AppColors.acidGreen,
        decoration: InputDecoration(
          hintText: 'Поиск задач...',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textMuted,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: _focused ? AppColors.acidGreen : AppColors.textMuted,
          ),
          suffixIcon: widget.value.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  color: AppColors.textSecondary,
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged('');
                  },
                  tooltip: 'Очистить',
                )
              : null,
        ),
      ),
    );
  }
}

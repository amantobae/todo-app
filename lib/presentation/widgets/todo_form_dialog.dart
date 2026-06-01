import 'package:flutter/material.dart';
import 'package:todo_app/core/constants/app_spacing.dart';
import 'package:todo_app/presentation/widgets/app_button.dart';

typedef TodoFormResult = (String title, String description);

Future<TodoFormResult?> showTodoFormDialog({
  required BuildContext context,
  String initialTitle = '',
  String initialDescription = '',
  String title = 'Новая задача',
}) {
  return showDialog<TodoFormResult>(
    context: context,
    builder: (ctx) => _TodoFormDialog(
      initialTitle: initialTitle,
      initialDescription: initialDescription,
      title: title,
    ),
  );
}

class _TodoFormDialog extends StatefulWidget {
  const _TodoFormDialog({
    required this.initialTitle,
    required this.initialDescription,
    required this.title,
  });

  final String initialTitle;
  final String initialDescription;
  final String title;

  @override
  State<_TodoFormDialog> createState() => _TodoFormDialogState();
}

class _TodoFormDialogState extends State<_TodoFormDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController =
        TextEditingController(text: widget.initialDescription);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop(
        context,
        (_titleController.text, _descriptionController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(widget.title, style: theme.textTheme.titleLarge),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                autofocus: true,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Название',
                  hintText: 'Что нужно сделать?',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введите название задачи';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Описание (необязательно)',
                  hintText: 'Детали задачи...',
                ),
                onFieldSubmitted: (_) => _submit(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        AppButton(
          label: 'Отмена',
          isPrimary: false,
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: AppSpacing.sm),
        AppButton(
          label: 'Сохранить',
          icon: Icons.check_rounded,
          onPressed: _submit,
        ),
      ],
    );
  }
}

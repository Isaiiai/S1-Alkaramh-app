import 'package:alkaramh/app_localizations.dart';
import 'package:alkaramh/config/color/colors_file.dart';
import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:flutter/material.dart';

class ErrorDialogbox {
  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (context) {
        return ErrorDialogContent(message: message);
      },
    );
  }
}

class ErrorDialogContent extends StatefulWidget {
  final String message;
  final VoidCallback? retry;

  const ErrorDialogContent({Key? key, required this.message, this.retry})
      : super(key: key);

  @override
  State<ErrorDialogContent> createState() => _ErrorDialogContentState();
}

class _ErrorDialogContentState extends State<ErrorDialogContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: -10.0, end: 10.0)
              .chain(CurveTween(curve: Curves.elasticIn)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: 10.0, end: -10.0)
              .chain(CurveTween(curve: Curves.elasticIn)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: -5.0, end: 5.0)
              .chain(CurveTween(curve: Curves.elasticIn)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: 5.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 1),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_shakeAnimation.value, 0),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: EdgeInsets.zero,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Section
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        const Icon(Icons.person, size: 80, color: Colors.white),
                        const SizedBox(height: 10),
                        Text(
                          AppLocalizations.of(context)!
                              .translate('info'),
                        )
                      ],
                    ),
                  ),
                  // Middle Section
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(widget.message,
                        textAlign: TextAlign.center, style: MyTextTheme.normal),
                  ),
                  // Retry Button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        // Default action to pop the dialog
                        if (widget.retry != null) {
                          widget.retry!();
                        } else {
                          Navigator.of(context)
                              .pop(); // Close dialog by default
                        }
                      },
                      child: Text(
                        "Retry",
                        style: MyTextTheme.normal.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

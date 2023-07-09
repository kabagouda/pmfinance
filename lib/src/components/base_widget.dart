import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/size_utils.dart';

class BaseWidget extends StatelessWidget {
  final Widget child;
  final String? appBarTitle;
  final bool showLoading;
  final bool showInternetError;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final bool? showTitle;
  final bool? showAppBar;
  final bool? withBottomSheet;
  final bool? useResizeToAvoidBottomInset;
  final bool withHorizontalPadding;
  final bool withVerticalPadding;
  final bool onlyBottomPadding;
  final bool usePoppins;
  final VoidCallback? onSkip;
  final List<Widget>? actions;

  const BaseWidget({
    super.key,
    required this.child,
    this.appBarTitle,
    this.showLoading = false,
    this.showInternetError = false,
    this.appBar,
    this.floatingActionButton,
    this.showTitle,
    this.showAppBar,
    this.withBottomSheet,
    this.useResizeToAvoidBottomInset = true,
    this.withHorizontalPadding = true,
    this.withVerticalPadding = true,
    this.onlyBottomPadding = true,
    this.usePoppins = false,
    this.onSkip,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final appBarTitle = this.appBarTitle ?? '';
    final showTitle = this.showTitle ?? true;
    final showAppBar = this.showAppBar ?? true;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: useResizeToAvoidBottomInset ?? true,
        backgroundColor: const Color.fromRGBO(173, 175, 177, 1),
        appBar: showAppBar
            ? AppBar(
                elevation: 0,
                iconTheme: IconThemeData(
                  color: AppColors.black,
                ),
                backgroundColor: const Color.fromRGBO(173, 175, 177, 1),
                shadowColor: Theme.of(context).scaffoldBackgroundColor,
                title: showTitle == true
                    ? Text(
                        appBarTitle,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getFontSize(20),
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
                actions: [
                  if (onSkip != null)
                    TextButton(
                      onPressed: onSkip,
                      child: Text(
                        'Passer',
                        style: AppTextStyles.title(
                          usePoppins: usePoppins,
                          fontSize: getFontSize(14),
                        ),
                      ),
                    ),
                  if (actions != null) ...actions!,
                ],
              )
            : null,
        body: Stack(
          children: [
            Padding(
              padding: showAppBar == true
                  ? EdgeInsets.only(
                      right: withHorizontalPadding ? getHorizontalSize(25) : 0,
                      left: withHorizontalPadding ? getHorizontalSize(25) : 0,
                      top: withVerticalPadding ? getVerticalSize(21) : 0,
                      bottom: getVerticalSize(10),
                    )
                  : EdgeInsets.only(
                      left: withHorizontalPadding ? getHorizontalSize(25) : 0,
                      right: withHorizontalPadding ? getHorizontalSize(25) : 0,
                      top: withVerticalPadding ? getVerticalSize(51) : 0,
                      bottom: withVerticalPadding ? getVerticalSize(21) : 0,
                    ),
              child: child,
            ),
            Align(
              alignment: Alignment.center,
              child: Visibility(
                visible: showLoading,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}

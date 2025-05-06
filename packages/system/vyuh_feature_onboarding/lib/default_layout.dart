import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_onboarding/onboarding.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'default_layout.g.dart';

@JsonSerializable()
final class DefaultOnboardingLayout
    extends LayoutConfiguration<OnboardingContent> {
  static const schemaName = '${OnboardingContent.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: DefaultOnboardingLayout.fromJson,
    title: 'Simple Page View Onboarding Layout',
  );

  DefaultOnboardingLayout() : super(schemaType: schemaName);

  factory DefaultOnboardingLayout.fromJson(Map<String, dynamic> json) =>
      _$DefaultOnboardingLayoutFromJson(json);

  @override
  Widget build(BuildContext context, OnboardingContent content) {
    return _OnboardingPageView(content: content);
  }
}

class _OnboardingPageView extends StatefulWidget {
  final OnboardingContent content;

  const _OnboardingPageView({required this.content});

  @override
  State<_OnboardingPageView> createState() => _OnboardingPageViewState();
}

class _OnboardingPageViewState extends State<_OnboardingPageView> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    final page = _pageController.page?.round() ?? 0;
    if (page != _currentPage) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  void _goToNextPage() {
    if (_currentPage < widget.content.steps.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _handleDone();
    }
  }

  void _handleDone() {
    if (widget.content.doneAction != null) {
      widget.content.doneAction!.execute(context);
    }
  }

  void _handleSkip() {
    _handleDone();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastPage = _currentPage == widget.content.steps.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.content.steps.length,
                itemBuilder: (context, index) {
                  return _buildPage(context, widget.content.steps[index]);
                },
              ),
            ),

            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.content.steps.length,
                  (index) => _buildDotIndicator(index, theme),
                ),
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip button
                  if (!isLastPage)
                    TextButton(
                      onPressed: _handleSkip,
                      child: const Text('Skip'),
                    )
                  else
                    const SizedBox(width: 80), // Placeholder for alignment

                  // Next/Done button
                  ElevatedButton(
                    onPressed: _goToNextPage,
                    child: Text(isLastPage ? 'Done' : 'Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDotIndicator(int index, ThemeData theme) {
    final isActive = index == _currentPage;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.primary
            : theme.colorScheme.primary.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }

  Widget _buildPage(BuildContext context, OnboardingStep step) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          if (step.image != null || step.icon != null)
            Expanded(
              flex: 3,
              child: Center(
                child: _buildImage(step, theme),
              ),
            ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              step.title,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),

          // Description
          if (step.description != null)
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: vyuh.content.buildContent(context, step.description!),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImage(OnboardingStep step, ThemeData theme) {
    if (step.image != null) {
      return ContentImage(
        ref: step.image!,
        fit: BoxFit.contain,
      );
    }

    if (step.icon != null) {
      return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.1),
        ),
        child: Center(child: step.icon!),
      );
    }

    return const SizedBox.shrink();
  }
}

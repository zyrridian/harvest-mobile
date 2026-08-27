import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/core/config/router/app_router.dart';
import 'package:harvest_app/core/services/storage_service.dart';
import 'package:harvest_app/core/widgets/web_constrained_box.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kTextGrey = Color(0xFF6E7A75);

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: PhosphorIconsRegular.plant,
      title: 'Fresh from the Farm',
      description:
          'Connect directly with local farmers and get the freshest produce delivered to your doorstep.',
      color: kDarkGreen,
    ),
    OnboardingPage(
      icon: PhosphorIconsRegular.calendarCheck,
      title: 'Pre-Order Harvests',
      description:
          'Know exactly when farmers are harvesting and secure your fresh produce at better prices.',
      color: kDarkGreen,
    ),
    OnboardingPage(
      icon: PhosphorIconsRegular.mapPin,
      title: 'Support Local',
      description:
          'Discover farmers in your area and build a sustainable local food community.',
      color: kDarkGreen,
    ),
    OnboardingPage(
      icon: PhosphorIconsRegular.sealCheck,
      title: 'Quality Guaranteed',
      description:
          'Get organic, fresh, and hand-picked produce directly from verified growers.',
      color: kDarkGreen,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    ref.read(preferencesServiceProvider).setFirstLaunchComplete();
    context.go(AppRouter.roleSelection);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: WebConstrainedBox(
          maxWidth: 600,
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton(
                    onPressed: _completeOnboarding,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: kTextGrey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),

              // Page indicators
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? _pages[_currentPage].color
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),

              // Next/Get Started button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _pages[_currentPage].color,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
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

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F5F2), // Light green tint
              borderRadius: BorderRadius.circular(32),
            ),
            child: PhosphorIcon(
              page.icon,
              size: 64,
              color: page.color,
            ),
          ),
          const SizedBox(height: 48),

          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: kDarkGreen,
            ),
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: kTextGrey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

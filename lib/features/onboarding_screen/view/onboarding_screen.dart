import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:health_fixed/features/auth/ui/login_screen.dart';
// import 'package:health_fixed/features/auth/ui/signup_screen.dart';
// import 'package:health_fixed/features/main_nav/ui/main_nav_page.dart';
import 'package:health_fixed/core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  final _pages = [
    {
      "image": "assets/images/img_fixed.png",
      "title": "Health Tracking Made Simple",
      "subtitle": "Seamlessly monitor your health, every day",
    },
    {
      "image": "assets/images/img_fixed.png",
      "title": "Manage Appointments",
      "subtitle": "Book and track doctor appointments with ease",
    },
    {
      "image": "assets/images/img_fixed.png",
      "title": "Stay Connected",
      "subtitle": "Chat with your healthcare providers instantly",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final lastIndex = _pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // PAGEVIEW
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) {
                  final p = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          p["image"]!,
                          width: MediaQuery.of(context).size.width * 0.7,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          p["title"]!,
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          p["subtitle"]!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // DOTS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _page == i ? Colors.green : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            // BUTTONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child:
                  _page < lastIndex
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.green),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              context.go('/main_nav');
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              child: Text(
                                "Skip",
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(color: Colors.green),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              child: Text(
                                "Next",
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )
                      : Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                // Navigate to sign-up
                                context.push('/sign_up');
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                child: Text(
                                  "Create Account",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium?.copyWith(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.green),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                // Navigate to login
                                context.push('/login');
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                child: Text(
                                  "Log In",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium?.copyWith(
                                    fontSize: 16,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

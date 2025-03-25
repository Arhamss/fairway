import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/widgets/intro_widget.dart';
import 'package:fairway/utils/widgets/core_widgets/button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreens extends StatefulWidget {
  const IntroScreens({super.key});

  @override
  _IntroScreensState createState() => _IntroScreensState();
}

class _IntroScreensState extends State<IntroScreens> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              children: const [
                IntroductionWidget(
                  imagePath: AssetPaths.intro1,
                  title: 'Diverse sparkling food.',
                  description:
                      'We use the best local ingredients to create fresh and delicious food and drinks.',
                ),
                IntroductionWidget(
                  imagePath: AssetPaths.intro2,
                  title: 'Concierge all orders',
                  description:
                      'Free Concierge on the primary order whilst the usage of CaPay fee method.',
                ),
                IntroductionWidget(
                  imagePath: AssetPaths.intro3,
                  title: '20+ Restaurants',
                  description:
                      'Easily find your favorite food and have it delivered in record time.',
                ),
              ],
            ),
          ),
          SmoothPageIndicator(
            controller: _controller,
            count: 3,
            effect: const ExpandingDotsEffect(
              dotWidth: 5,
              dotHeight: 5,
              activeDotColor: AppColors.activeDotColor,
              dotColor: AppColors.greyShade4,
              strokeWidth: 80,
              expansionFactor: 6.3,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 50, 24, 100),
        child: FairwayButton(
          textColor: AppColors.white,
          borderRadius: 15,
          backgroundColor: AppColors.primaryButton,
          onPressed: () {
            final currentPage = _controller.page?.round() ?? 0;
            if (currentPage < 2) {
              _controller.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            } else {
              context.goNamed(
                AppRouteNames.signIn,
              );
            }
          },
          text: 'Get started',
          isLoading: false,
          borderColor: AppColors.primaryButton,
        ),
      ),
    );
  }
}

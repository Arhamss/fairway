import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/onboarding_flow/presentation/widgets/intro_widget.dart';
import 'package:fairway/utils/widgets/core_widgets/button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController();
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    FocusManager.instance.primaryFocus?.unfocus();
    _controller.addListener(() {
      final page = _controller.page?.round() ?? 0;
      if (_currentPageIndex != page) {
        setState(() {
          _currentPageIndex = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
              activeDotColor: AppColors.secondaryBlue,
              dotColor: AppColors.greyShade4,
              strokeWidth: 80,
              expansionFactor: 6.3,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          0,
          24,
          MediaQuery.of(context).size.height * 0.1,
        ),
        child: FairwayButton(
          textColor: AppColors.white,
          borderRadius: 15,
          onPressed: () {
            if (_currentPageIndex < 2) {
              _controller.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            } else {
              context.goNamed(AppRouteNames.signIn);
            }
          },
          text: (_currentPageIndex < 2) ? 'Next' : 'Get Started',
          isLoading: false,
        ),
      ),
    );
  }
}

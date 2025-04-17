import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/widgets/help/faq_item.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  static final List<FaqItem> _faqItems = [
    const FaqItem(
      question: 'How do I create a new account?',
      answer: 'To create a new account, click on the "Sign Up" button...',
    ),
    const FaqItem(
      question: 'I forgot my password. How do I reset it?',
      answer: 'You can reset your password by clicking "Forgot Password"...',
    ),
    const FaqItem(
      question: 'I want to cancel an order I have placed. How can I do this?',
      answer: 'To cancel an order, go to your order history...',
    ),
    const FaqItem(
      question:
          'I am having trouble logging into my account. How can I resolve this?',
      answer: "If you're having trouble logging in...",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkWhiteBackground,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: AppColors.white,
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Text(
          'Help Center',
          style: context.h2.copyWith(
            color: AppColors.black,
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _faqItems
            .map(
              (item) => ExpandableFaqItem(
                question: item.question,
                answer: item.answer,
              ),
            )
            .toList(),
      ),
    );
  }
}

import 'package:fairway/constants/app_colors.dart';
import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/home/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/subscription/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/subscription/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/subscription/presentation/widgets/benefit_item.dart';
import 'package:fairway/fairway/features/subscription/presentation/widgets/subscription_plan_card.dart';
import 'package:fairway/utils/widgets/core_widgets/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, homeState) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            forceMaterialTransparency: true,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Subscription',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(
                  height: 32,
                ),
                SvgPicture.asset(
                  AssetPaths.fairwaySignupLogo,
                  height: 177.03,
                  width: 160,
                ),
                const SizedBox(
                  height: 32,
                ),
                const BenefitItem(
                  text: 'Special offers and discounts coupons every week',
                ),
                const SizedBox(height: 20),
                const BenefitItem(
                  text: 'no delivery charges at all',
                ),
                const SizedBox(height: 32),
                SubscriptionPlanCard(
                  title: r'Annual $10',
                  description: '13 days free trial',
                  isSelected: true,
                  onTap: () {},
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: 48,
            ),
            child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
              builder: (context, state) {
                final isSubscribed =
                    state.subscriptionData.data?.userData.subscriber ?? false;
                return SubscriptionActionButton(
                  isSubscribed: isSubscribed,
                  isLoading: state.isLoading,
                  onSubscribe: () {
                    context.read<SubscriptionCubit>().updateSubscription(
                          true,
                          homeState.userProfile.data!.id,
                        );
                  },
                  onCancel: () {
                    context.read<SubscriptionCubit>().updateSubscription(
                          false,
                          homeState.userProfile.data!.id,
                        );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

/// Widget for the subscription action button (subscribe/cancel)
class SubscriptionActionButton extends StatelessWidget {
  const SubscriptionActionButton({
    required this.isSubscribed,
    required this.onSubscribe,
    required this.onCancel,
    required this.isLoading,
    super.key,
  });
  final bool isSubscribed;
  final VoidCallback onSubscribe;
  final VoidCallback onCancel;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return FairwayButton(
      borderRadius: 12,
      text: isSubscribed ? 'Cancel a Subscription' : 'Subscribe Now',
      backgroundColor: isSubscribed ? AppColors.error : AppColors.primaryBlue,
      disabled: isLoading,
      onPressed: isSubscribed ? onCancel : onSubscribe,
      textColor: Colors.white,
      fontWeight: FontWeight.w600,
      isLoading: isLoading,
    );
  }
}

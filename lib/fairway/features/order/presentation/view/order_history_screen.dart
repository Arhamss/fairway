import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/order/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/order/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/order/presentation/widgets/order_history/in_progress_orders.dart';
import 'package:fairway/fairway/features/order/presentation/widgets/order_history/completed_orders.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';
import 'package:fairway/utils/widgets/core_widgets/sliding_tab.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Load order history when the screen is first displayed
  }

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
          'Order History',
          style: context.h2.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 8),
            child: FairwaySlidingTab(
              height: 37,
              shortenWidth: true,
              textOne: 'In-Progress',
              textTwo: 'Completed',
              onTapOne: () => context.read<OrderCubit>().setCurrentTab(0),
              onTapTwo: () => context.read<OrderCubit>().setCurrentTab(1),
              selectedColor: AppColors.activeTabColor,
              textStyle: context.b3.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),

          // Order Lists
          Expanded(
            child: BlocBuilder<OrderCubit, OrderState>(
              builder: (context, state) {
                if (state.orderHistoryModel.isLoading) {
                  return const Center(
                    child: LoadingWidget(),
                  );
                } else if (state.orderHistoryModel.isFailure) {
                  return Center(
                    child: Text(
                      state.orderHistoryModel.errorMessage ??
                          'An error occurred',
                      style:
                          context.b1.copyWith(color: AppColors.textSecondary),
                    ),
                  );
                }

                final orders = state.orderHistoryModel.data?.orders ?? [];

                // Show appropriate tab content based on selected tab
                return state.currentTab == 0
                    ? InProgressOrdersList(orders: orders)
                    : CompletedOrdersList(orders: orders);
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/order/domain/enums/order_preparation_state.dart';
import 'package:fairway/fairway/features/order/presentation/cubit/cubit.dart';
import 'package:fairway/fairway/features/order/presentation/cubit/state.dart';
import 'package:fairway/fairway/features/order/presentation/widgets/sheet_widgets/delivery_details_row.dart';
import 'package:fairway/fairway/features/order/presentation/widgets/sheet_widgets/food_delivered_grid.dart';
import 'package:fairway/fairway/features/order/presentation/widgets/sheet_widgets/order_preparation_status.dart';
import 'package:fairway/fairway/features/order/presentation/widgets/sheet_widgets/order_sheet_header.dart';
import 'package:fairway/fairway/features/order/presentation/widgets/sheet_widgets/sheet_estimated_time.dart';
import 'package:fairway/utils/widgets/core_widgets/button.dart';
import 'package:fairway/utils/widgets/core_widgets/divider.dart';

class OrderDetailsSheet extends StatelessWidget {
  const OrderDetailsSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.95,
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppColors.greyShade7,
                        size: 35,
                      ),
                    ),
                  ],
                ),
              ),
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const OrderSheetHeader(),
                      const SizedBox(height: 16),
                      const FairwayDivider(),
                      const SizedBox(height: 24),
                      const EstimatedTime(),
                      const SizedBox(height: 16),
                      OrderPreparationStatus(
                        currentState: OrderPreparationState.fromName(
                          state.orderResponseModel.data!.status,
                        ),
                        estimatedTime: state
                            .orderResponseModel.data!.estimatedTime
                            .toString(),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            DeliveryDetailsRow(
                              label: 'Deliver to',
                              value: state
                                  .orderResponseModel.data!.airport.airportName,
                              svgPath: AssetPaths.locationIconOutlined,
                            ),
                            DeliveryDetailsRow(
                              label: 'Terminal',
                              value: state
                                  .orderResponseModel.data!.airport.terminal,
                              svgPath: AssetPaths.locationIconOutlined,
                            ),
                            DeliveryDetailsRow(
                              label: 'Gate No',
                              value:
                                  state.orderResponseModel.data!.airport.gate,
                              svgPath: AssetPaths.locationIconOutlined,
                            ),
                            DeliveryDetailsRow(
                              label: 'Amount Paid',
                              value: state.orderResponseModel.data!.totalPrice
                                  .toString(),
                              svgPath: AssetPaths.walletIcon,
                              isCurrency: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: FoodDeliveredGrid(
                          items: state.orderResponseModel.data!.items,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: FairwayButton(
                  padding: const EdgeInsets.all(18),
                  text: 'See Locker Details',
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  borderRadius: 16,
                  onPressed: () => context.pop(),
                  textColor: AppColors.white,
                  isLoading: false,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

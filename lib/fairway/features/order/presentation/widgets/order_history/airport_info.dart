import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/order/data/models/airport_model.dart';

class AirportInfo extends StatelessWidget {
  const AirportInfo({
    required this.airport,
    super.key,
  });

  final OrderAirportModel airport;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            airport.airportName,
            style: context.b1.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: AppColors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gate Number ${airport.gate}',
                style: context.b2.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Terminal ${airport.terminal.replaceAll('Terminal ', '')}',
                style: context.b2.copyWith(
                  color: AppColors.greyShade7,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

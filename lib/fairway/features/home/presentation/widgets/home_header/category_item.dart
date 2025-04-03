import 'package:fairway/export.dart';

final List<Map<String, String>> categories = [
  {
    'label': 'Sandwich',
    'icon': AssetPaths.sandwich,
  },
  {
    'label': 'Pizza',
    'icon': AssetPaths.pizza,
  },
  {
    'label': 'Burgers',
    'icon': AssetPaths.burger,
  },
];

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    required this.label,
    required this.iconPath,
  });
  final String label;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: AppColors.greyShade5,
          child: SvgPicture.asset(iconPath, height: 40),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: context.b2.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

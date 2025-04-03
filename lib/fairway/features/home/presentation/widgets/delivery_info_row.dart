// import 'package:flutter/material.dart';
// import 'package:fairway/constants/app_colors.dart';
// import 'package:fairway/constants/app_text_style.dart';
// import 'package:fairway/fairway/models/user_data_model.dart';
// import 'package:flutter_svg/svg.dart';
//
// class DeliveryInfoRow extends StatelessWidget {
//   const DeliveryInfoRow({
//     super.key,
//     this.userData,
//   });
//   final UserData? userData;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Expanded(
//           child: Row(
//             children: [
//               // Increased size container for SVG
//               Container(
//                 width: 48, // Increased width
//                 height: 48, // Increased height
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: AppColors.greyShade5,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: SvgPicture.asset(
//                   'assets/svgs/location.svg',
//                 ),
//               ),
//               const SizedBox(width: 12), // Increased spacing
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Delivery to',
//                       style: context.b2.copyWith(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14, // Slightly larger
//                         color: AppColors.black,
//                       ),
//                     ),
//                     Text(
//                       userData?.location ?? 'Select location',
//                       style: context.b1.copyWith(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 16, // Slightly larger
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           width: 40, // Fixed width for better alignment
//           height: 40, // Fixed height for better alignment
//           decoration: BoxDecoration(
//             color: AppColors.greyShade5,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: IconButton(
//             icon: const Icon(Icons.filter_list, color: AppColors.black),
//             onPressed: () {
//               // Handle filter action
//             },
//             padding: EdgeInsets.zero, // Remove padding
//           ),
//         ),
//       ],
//     );
//   }
// }

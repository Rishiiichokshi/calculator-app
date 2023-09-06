// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'custom_text.dart';
//
// typedef ClickOnTap = Function();
//
// class CommonAppBar extends StatelessWidget {
//   const CommonAppBar({
//     Key? key,
//     this.titleText,
//     this.backPress,
//     this.showAction = false,
//     this.isElevation = true,
//     this.clickOnTap,
//   }) : super(key: key);
//   final String? titleText;
//   final bool? showAction, isElevation;
//   final VoidCallback? backPress;
//   final ClickOnTap? clickOnTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         AppBar(
//             backgroundColor: ColorUtils.white,
//             elevation: 4,
//             title: CustomText(
//               titleText ?? '',
//               fontWeight: FontWeight.w600,
//               color: ColorUtils.primary,
//               fontSize: 14.sp,
//             ),
//             centerTitle: true,
//             leading: InkWell(
//                 onTap: backPress ?? () => Get.back(),
//                 child: const Icon(
//                   Icons.arrow_back,
//                   color: ColorUtils.primary,
//                 )),
//             actions: showAction!
//                 ? [
//                     InkWell(
//                       onTap: clickOnTap!,
//                       child: const Icon(
//                         Icons.bookmarks_outlined,
//                         color: ColorUtils.primary,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 5.w,
//                     ),
//                   ]
//                 : [const SizedBox()]),
//       ],
//     );
//   }
// }

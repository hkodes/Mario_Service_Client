// import 'dart:developer';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:auto_route/auto_route.dart';

// /// Show this on [ACCEPTED,STARTED,ARRIVED,PICKEDUP,DROPPED,PAYMENT,COMPLETED] State, when the users instant request
// class ProviderUpdatedUI extends StatelessWidget {
//   final CheckOrderResponse checkOrderResponse;
//   const ProviderUpdatedUI({
//     Key key,
//     this.checkOrderResponse,
//   }) : super(key: key);

//   void _popAFterBuild(BuildContext context) {
//     WidgetsBinding.instance.scheduleFrameCallback((timeStamp) {
//       context.router
//           .pushAndRemoveUntil(DashBoardRoute(), predicate: (route) => false);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (checkOrderResponse.data.length == 0) {
//       _popAFterBuild(context);
//       return Container();
//     }
//     log("-------Current status------");
//     log("-------Current status------");
//     log("-------Current status------");
//     log(checkOrderResponse.data[0].status);
//     log("-------Current status------");
//     log("-------Current status------");
//     log("-------Current status------");
//     return Container(
//       height: MediaQuery.of(context).size.height / 3,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(8.0),
//           topRight: Radius.circular(8.0),
//         ),
//         color: const Color(0xffffffff),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0x1a000000),
//             offset: Offset(0, -2),
//             blurRadius: 6,
//           ),
//         ],
//       ),
//       child: SingleChildScrollView(child: _getWidget(context)),
//     );
//   }

//   _getWidget(BuildContext context) {
//     if (checkOrderResponse.data[0].status == 'STARTED') {
//       return Travelling(checkOrderResponse);
//     } else if (checkOrderResponse.data[0].status == "ARRIVED" ||
//         checkOrderResponse.data[0].status == 'PICKEDUP') {
//       return Arrived(checkOrderResponse);
//     } else if (checkOrderResponse.data[0].status == "DROPPED") {
//       return DroppedShowBill(checkOrderResponse);
//     } else if (checkOrderResponse.data[0].status == 'COMPLETED' ||
//         checkOrderResponse.data[0].status == 'PAYMENT') {
//       return RateReview(checkOrderResponse);
//     }
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         SizedBox(
//           height: 24,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'STATUS:  ',
//               style: TextStyle(
//                 fontFamily: 'Nunito Sans',
//                 fontSize: 14,
//                 color: const Color(0xff000000),
//                 letterSpacing: 0.28,
//                 fontWeight: FontWeight.w500,
//                 height: 1.2,
//               ),
//               textHeightBehavior:
//                   TextHeightBehavior(applyHeightToFirstAscent: false),
//               textAlign: TextAlign.left,
//             ),
//             Text(
//               '${checkOrderResponse.data[0].status}',
//               style: TextStyle(
//                 fontFamily: 'Nunito Sans',
//                 fontSize: 20,
//                 color: const Color(0xff000000),
//                 letterSpacing: 0.28,
//                 fontWeight: FontWeight.w700,
//                 height: 1.2,
//               ),
//               textHeightBehavior:
//                   TextHeightBehavior(applyHeightToFirstAscent: false),
//               textAlign: TextAlign.left,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// ///This is when the driver is on the way to the user home for service
// class Travelling extends StatelessWidget {
//   final CheckOrderResponse checkOrderResponse;
//   Travelling(this.checkOrderResponse);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: CachedNetworkImage(
//                       imageUrl:
//                           checkOrderResponse.data[0].provider.avatar ?? "",
//                       width: 62,
//                       height: 62,
//                       placeholder: (context, url) =>
//                           new CircularProgressIndicator(),
//                       errorWidget: (context, url, error) => new Icon(
//                         Icons.person,
//                         size: 62,
//                       ),
//                     ),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         checkOrderResponse.data[0].provider.firstName +
//                             " " +
//                             checkOrderResponse.data[0].provider.lastName,
//                         style: TextStyle(
//                           fontFamily: 'Metropolis',
//                           fontSize: 18,
//                           color: const Color(0xff4a4b4d),
//                           fontWeight: FontWeight.w700,
//                         ),
//                         textAlign: TextAlign.left,
//                       ),
//                       SizedBox(
//                         height: 16,
//                       ),
//                       RatingBar(
//                         initialRating: double.parse(
//                             checkOrderResponse.data[0].provider.rating ??
//                                 "0.0"),
//                         direction: Axis.horizontal,
//                         allowHalfRating: true,
//                         itemCount: 5,
//                         itemSize: 20,
//                         itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
//                         onRatingUpdate: (rating) {
//                           print(rating);
//                         },
//                         ratingWidget: RatingWidget(
//                           empty: Icon(
//                             Icons.star,
//                             color: Colors.amber,
//                             size: 12,
//                           ),
//                           full: Icon(
//                             Icons.star,
//                             color: Colors.amber,
//                             size: 12,
//                           ),
//                           half: Icon(
//                             Icons.star,
//                             color: Colors.amber,
//                             size: 12,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       "From",
//                       style: TextStyle(
//                         fontFamily: 'Metropolis',
//                         fontSize: 18,
//                         color: const Color(0xff4a4b4d),
//                         fontWeight: FontWeight.w300,
//                       ),
//                       textAlign: TextAlign.left,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       checkOrderResponse.data[0].sAddress,
//                       style: TextStyle(
//                         fontFamily: 'Metropolis',
//                         fontSize: 14,
//                         color: const Color(0xff4a4b4d),
//                         fontWeight: FontWeight.w700,
//                       ),
//                       textAlign: TextAlign.left,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       checkOrderResponse.data[0].sLatitude +
//                           "\n" +
//                           checkOrderResponse.data[0].sLongitude,
//                       style: TextStyle(
//                         fontFamily: 'Metropolis',
//                         fontSize: 14,
//                         color: const Color(0xff4a4b4d),
//                         fontWeight: FontWeight.w700,
//                       ),
//                       textAlign: TextAlign.left,
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       "To",
//                       style: TextStyle(
//                         fontFamily: 'Metropolis',
//                         fontSize: 18,
//                         color: const Color(0xff4a4b4d),
//                         fontWeight: FontWeight.w300,
//                       ),
//                       textAlign: TextAlign.left,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       checkOrderResponse.data[0].sAddress,
//                       style: TextStyle(
//                         fontFamily: 'Metropolis',
//                         fontSize: 14,
//                         color: const Color(0xff4a4b4d),
//                         fontWeight: FontWeight.w700,
//                       ),
//                       textAlign: TextAlign.left,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       checkOrderResponse.data[0].dLatitude +
//                           "\n" +
//                           checkOrderResponse.data[0].dLongitude,
//                       style: TextStyle(
//                         fontFamily: 'Metropolis',
//                         fontSize: 14,
//                         color: const Color(0xff4a4b4d),
//                         fontWeight: FontWeight.w700,
//                       ),
//                       textAlign: TextAlign.left,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         // AcceptRejectPair(
//         //   rejectRequest: () => rejectRequest(),
//         //   accept: (String requestId, BuildContext context) {
//         //     return updateStatus(
//         //       requestId,
//         //       context,
//         //     );
//         //   },
//         // )
//       ],
//     );
//   }
// }

// // ///This is when the driver has reached the user
// // class Arrived extends StatelessWidget {
// //   final CheckOrderResponse checkOrderResponse;
// //   Arrived(this.checkOrderResponse);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.stretch,
// //       children: [
// //         Padding(
// //           padding: const EdgeInsets.all(8.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Row(
// //                 children: [
// //                   Padding(
// //                     padding: const EdgeInsets.all(8.0),
// //                     child: CachedNetworkImage(
// //                       imageUrl:
// //                           checkOrderResponse.data[0].provider.avatar ?? "",
// //                       width: 62,
// //                       height: 62,
// //                       placeholder: (context, url) =>
// //                           new CircularProgressIndicator(),
// //                       errorWidget: (context, url, error) => new Icon(
// //                         Icons.person,
// //                         size: 62,
// //                       ),
// //                     ),
// //                   ),
// //                   Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         checkOrderResponse.data[0].provider.firstName +
// //                             " " +
// //                             checkOrderResponse.data[0].provider.lastName,
// //                         style: TextStyle(
// //                           fontFamily: 'Metropolis',
// //                           fontSize: 18,
// //                           color: const Color(0xff4a4b4d),
// //                           fontWeight: FontWeight.w700,
// //                         ),
// //                         textAlign: TextAlign.left,
// //                       ),
// //                       SizedBox(
// //                         height: 16,
// //                       ),
// //                       RatingBar(
// //                         initialRating: double.parse(
// //                             checkOrderResponse.data[0].provider.rating ??
// //                                 "0.0"),
// //                         direction: Axis.horizontal,
// //                         allowHalfRating: true,
// //                         itemCount: 5,
// //                         itemSize: 20,
// //                         itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
// //                         onRatingUpdate: (rating) {
// //                           print(rating);
// //                         },
// //                         ratingWidget: RatingWidget(
// //                           empty: Icon(
// //                             Icons.star,
// //                             color: Colors.amber,
// //                             size: 12,
// //                           ),
// //                           full: Icon(
// //                             Icons.star,
// //                             color: Colors.amber,
// //                             size: 12,
// //                           ),
// //                           half: Icon(
// //                             Icons.star,
// //                             color: Colors.amber,
// //                             size: 12,
// //                           ),
// //                         ),
// //                       )
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Padding(
// //                     padding: const EdgeInsets.all(8.0),
// //                     child: Text(
// //                       "Status",
// //                       style: TextStyle(
// //                         fontFamily: 'Metropolis',
// //                         fontSize: 18,
// //                         color: const Color(0xff4a4b4d),
// //                         fontWeight: FontWeight.w700,
// //                       ),
// //                       textAlign: TextAlign.center,
// //                     ),
// //                   ),
// //                   Padding(
// //                     padding: const EdgeInsets.all(8.0),
// //                     child: Text(
// //                       checkOrderResponse.data[0].status,
// //                       style: TextStyle(
// //                         fontFamily: 'Metropolis',
// //                         fontSize: 18,
// //                         color: const Color(0xff4a4b4d),
// //                         fontWeight: FontWeight.w700,
// //                       ),
// //                       textAlign: TextAlign.center,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //         // AcceptRejectPair(
// //         //   rejectRequest: () => rejectRequest(),
// //         //   accept: (String requestId, BuildContext context) {
// //         //     return updateStatus(
// //         //       requestId,
// //         //       context,
// //         //     );
// //         //   },
// //         // )
// //       ],
// //     );
// //   }
// // }

// // ///This is when the driver has Completed the task of  the user
// // ///now the billing is shown to the user
// // class DroppedShowBill extends StatelessWidget {
// //   final Map<String,dynamic> checkOrderResponse;
// //   DroppedShowBill(this.checkOrderResponse);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.stretch,
// //       children: [
// //         Padding(
// //           padding: const EdgeInsets.only(top: 16.0),
// //           child: Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Row(
// //                   children: [
// //                     Padding(
// //                       padding: const EdgeInsets.all(24.0),
// //                       child: CachedNetworkImage(
// //                         imageUrl:
// //                             checkOrderResponse.data[0].provider.avatar ?? "",
// //                         width: 62,
// //                         height: 62,
// //                         placeholder: (context, url) =>
// //                             new CircularProgressIndicator(),
// //                         errorWidget: (context, url, error) => new Icon(
// //                           Icons.person,
// //                           size: 62,
// //                         ),
// //                       ),
// //                     ),
// //                     Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Text(
// //                           checkOrderResponse.data[0].provider.firstName +
// //                               " " +
// //                               checkOrderResponse.data[0].provider.lastName,
// //                           style: TextStyle(
// //                             fontFamily: 'Metropolis',
// //                             fontSize: 18,
// //                             color: const Color(0xff4a4b4d),
// //                             fontWeight: FontWeight.w700,
// //                           ),
// //                           textAlign: TextAlign.left,
// //                         ),
// //                         SizedBox(
// //                           height: 16,
// //                         ),
// //                         RatingBar(
// //                           initialRating: double.parse(
// //                               checkOrderResponse.data[0].provider.rating ??
// //                                   "0.0"),
// //                           direction: Axis.horizontal,
// //                           allowHalfRating: true,
// //                           itemCount: 5,
// //                           itemSize: 20,
// //                           itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
// //                           onRatingUpdate: (rating) {
// //                             print(rating);
// //                           },
// //                           ratingWidget: RatingWidget(
// //                             empty: Icon(
// //                               Icons.star,
// //                               color: Colors.amber,
// //                               size: 12,
// //                             ),
// //                             full: Icon(
// //                               Icons.star,
// //                               color: Colors.amber,
// //                               size: 12,
// //                             ),
// //                             half: Icon(
// //                               Icons.star,
// //                               color: Colors.amber,
// //                               size: 12,
// //                             ),
// //                           ),
// //                         )
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //                 Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: Text(
// //                     "Invoice",
// //                     style: TextStyle(
// //                       fontFamily: 'Metropolis',
// //                       fontSize: 18,
// //                       color: const Color(0xff4a4b4d),
// //                       fontWeight: FontWeight.w300,
// //                     ),
// //                     textAlign: TextAlign.left,
// //                   ),
// //                 ),
// //                 Row(
// //                   children: [
// //                     Padding(
// //                       padding: const EdgeInsets.all(8.0),
// //                       child: Text(
// //                         "Request ID",
// //                         style: TextStyle(
// //                           fontFamily: 'Metropolis',
// //                           fontSize: 18,
// //                           color: const Color(0xff4a4b4d),
// //                           fontWeight: FontWeight.w700,
// //                         ),
// //                         textAlign: TextAlign.left,
// //                       ),
// //                     ),
// //                     Expanded(
// //                       child: Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Text(
// //                           checkOrderResponse.data[0].id.toString(),
// //                           style: TextStyle(
// //                             fontFamily: 'Metropolis',
// //                             fontSize: 18,
// //                             color: const Color(0xff4a4b4d),
// //                             fontWeight: FontWeight.w700,
// //                           ),
// //                           textAlign: TextAlign.left,
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 Row(
// //                   children: [
// //                     Padding(
// //                       padding: const EdgeInsets.all(8.0),
// //                       child: Text(
// //                         "Amount to be Paid",
// //                         style: TextStyle(
// //                           fontFamily: 'Metropolis',
// //                           fontSize: 18,
// //                           color: const Color(0xff4a4b4d),
// //                           fontWeight: FontWeight.w700,
// //                         ),
// //                         textAlign: TextAlign.left,
// //                       ),
// //                     ),
// //                     Expanded(
// //                       child: Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Text(
// //                           checkOrderResponse.data[0].serviceType.price,
// //                           style: TextStyle(
// //                             fontFamily: 'Metropolis',
// //                             fontSize: 18,
// //                             color: const Color(0xff4a4b4d),
// //                             fontWeight: FontWeight.w700,
// //                           ),
// //                           textAlign: TextAlign.left,
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //         // AcceptRejectPair(
// //         //   rejectRequest: () => rejectRequest(),
// //         //   accept: (String requestId, BuildContext context) {
// //         //     return updateStatus(
// //         //       requestId,
// //         //       context,
// //         //     );
// //         //   },
// //         // )
// //       ],
// //     );
// //   }
// // }

// class RateReview extends StatefulWidget {
//   // final CheckOrderResponse checkOrderResponse;

//   // RateReview(this.checkOrderResponse);

//   @override
//   State<StatefulWidget> createState() {
//     return CompletedViewState();
//   }
// }

// class CompletedViewState extends State<RateReview> {
//   TextEditingController textEditingController = TextEditingController();
//   int userRating = 5;

//   ///completed
//   bool complted = false;

//   _reviewUser(BuildContext context) {
//     if (textEditingController.text.length == 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Review required'),
//         ),
//       );
//     } else {
//       //   BlocProvider.of<MapBloc>(context).add(ReviewCustomerEvent(
//       //       textEditingController.text,
//       //       userRating,
//       //       widget.checkOrderResponse.data[0].id));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return complted
//         ? Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 16.0),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               "Review",
//                               style: TextStyle(
//                                 fontFamily: 'Metropolis',
//                                 fontSize: 18,
//                                 color: const Color(0xff4a4b4d),
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                           RatingBar.builder(
//                             initialRating: 5,
//                             minRating: 1,
//                             direction: Axis.horizontal,
//                             allowHalfRating: false,
//                             glow: false,
//                             itemSize: 36,
//                             itemCount: 5,
//                             itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
//                             itemBuilder: (context, _) => Icon(
//                               Icons.star,
//                               color: Colors.amber,
//                             ),
//                             onRatingUpdate: (rating) {
//                               userRating = rating as int;
//                             },
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 12,
//                       ),
//                       TextField(
//                         controller: textEditingController,
//                         minLines: 3,
//                         maxLines: 5,
//                       ),
//                       SizedBox(
//                         height: 12,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () => _reviewUser(context),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text("Rate and Review"
//                                     // getText(
//                                     //   BlocProvider.of<NewOrderBloc>(context)
//                                     //       .tripResponse
//                                     //       .requests[0]
//                                     //       .request
//                                     //       .status,
//                                     ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 // AcceptRejectPair(
//                 //   rejectRequest: () => rejectRequest(),
//                 //   accept: (String requestId, BuildContext context) {
//                 //     return updateStatus(
//                 //       requestId,
//                 //       context,
//                 //     );
//                 //   },
//                 // )
//               ),
//             ],
//           )
//         : Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 16.0),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(24.0),
//                             child: CachedNetworkImage(
//                               imageUrl: widget.checkOrderResponse.data[0]
//                                       .provider.avatar ??
//                                   "",
//                               width: 62,
//                               height: 62,
//                               placeholder: (context, url) =>
//                                   new CircularProgressIndicator(),
//                               errorWidget: (context, url, error) => new Icon(
//                                 Icons.person,
//                                 size: 62,
//                               ),
//                             ),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 widget.checkOrderResponse.data[0].provider
//                                         .firstName +
//                                     " " +
//                                     widget.checkOrderResponse.data[0].provider
//                                         .lastName,
//                                 style: TextStyle(
//                                   fontFamily: 'Metropolis',
//                                   fontSize: 18,
//                                   color: const Color(0xff4a4b4d),
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                                 textAlign: TextAlign.left,
//                               ),
//                               SizedBox(
//                                 height: 16,
//                               ),
//                               RatingBar(
//                                 initialRating: double.parse(widget
//                                         .checkOrderResponse
//                                         .data[0]
//                                         .provider
//                                         .rating ??
//                                     "0.0"),
//                                 direction: Axis.horizontal,
//                                 allowHalfRating: true,
//                                 itemCount: 5,
//                                 itemSize: 20,
//                                 itemPadding:
//                                     EdgeInsets.symmetric(horizontal: 2.0),
//                                 onRatingUpdate: (rating) {
//                                   print(rating);
//                                 },
//                                 ratingWidget: RatingWidget(
//                                   empty: Icon(
//                                     Icons.star,
//                                     color: Colors.amber,
//                                     size: 12,
//                                   ),
//                                   full: Icon(
//                                     Icons.star,
//                                     color: Colors.amber,
//                                     size: 12,
//                                   ),
//                                   half: Icon(
//                                     Icons.star,
//                                     color: Colors.amber,
//                                     size: 12,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           "Invoice",
//                           style: TextStyle(
//                             fontFamily: 'Metropolis',
//                             fontSize: 18,
//                             color: const Color(0xff4a4b4d),
//                             fontWeight: FontWeight.w300,
//                           ),
//                           textAlign: TextAlign.left,
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               "Request ID",
//                               style: TextStyle(
//                                 fontFamily: 'Metropolis',
//                                 fontSize: 18,
//                                 color: const Color(0xff4a4b4d),
//                                 fontWeight: FontWeight.w700,
//                               ),
//                               textAlign: TextAlign.left,
//                             ),
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 widget.checkOrderResponse.data[0].id.toString(),
//                                 style: TextStyle(
//                                   fontFamily: 'Metropolis',
//                                   fontSize: 18,
//                                   color: const Color(0xff4a4b4d),
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                                 textAlign: TextAlign.left,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               "Amount to be Paid",
//                               style: TextStyle(
//                                 fontFamily: 'Metropolis',
//                                 fontSize: 18,
//                                 color: const Color(0xff4a4b4d),
//                                 fontWeight: FontWeight.w700,
//                               ),
//                               textAlign: TextAlign.left,
//                             ),
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 widget.checkOrderResponse.data[0].serviceType
//                                     .price,
//                                 style: TextStyle(
//                                   fontFamily: 'Metropolis',
//                                   fontSize: 18,
//                                   color: const Color(0xff4a4b4d),
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                                 textAlign: TextAlign.left,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 setState(() {
//                                   complted = true;
//                                 });
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text("Contine"
//                                     // getText(
//                                     //   BlocProvider.of<NewOrderBloc>(context)
//                                     //       .tripResponse
//                                     //       .requests[0]
//                                     //       .request
//                                     //       .status,
//                                     ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // AcceptRejectPair(
//               //   rejectRequest: () => rejectRequest(),
//               //   accept: (String requestId, BuildContext context) {
//               //     return updateStatus(
//               //       requestId,
//               //       context,
//               //     );
//               //   },
//               // )
//             ],
//           );
//   }
// }

// class LoadImage extends StatelessWidget {
//   final String picture;
//   LoadImage(this.picture);

//   @override
//   Widget build(BuildContext context) {
//     if (picture == null) {
//       log("Piicture is null");
//       return Icon(Icons.person);
//     }

//     return Image.network(fixImage(picture));
//   }
// }

// /// This function will fix the broken url that doesnot contain Base url
// String fixImage(String url) {
//   if (!(url.startsWith("https://pos.globalmobile.com.np") ||
//       url.startsWith("https://pos.globalmobile.com.np"))) {
//     return "https://pos.globalmobile.com.np" + url;
//   } else {
//     return url;
//   }
// }

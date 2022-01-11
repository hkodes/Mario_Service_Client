import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mario_service/common/base.dart';
import 'package:mario_service/views/map_order/map_order.dart';

class CategoryListingPage extends StatefulWidget {
  final String title;
  final List<dynamic> serviceCategoryModel;

  const CategoryListingPage(this.title, this.serviceCategoryModel);

  @override
  State<StatefulWidget> createState() {
    return CategoryListingPageState();
  }
}

class CategoryListingPageState extends State<CategoryListingPage> {
  String title;
  List<dynamic> serviceCategoryModel = [];

  int selectedIndex = 0;

  @override
  void initState() {
    title = widget.title;
    serviceCategoryModel = widget.serviceCategoryModel;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(title, style: TextStyle(fontSize: 20)),
        ),
        body: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 7, right: 7),
              child: SizedBox(
                height: 100,
                child: InkWell(
                  onTap: () => _updateIndex(index, context),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.97,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border:
                          Border.all(color: Colors.deepOrangeAccent, width: 1),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: CachedNetworkImage(
                            imageUrl: serviceCategoryModel[index]['image'],
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                          height: 12,
                        ),
                        Text(
                          serviceCategoryModel[index]['name'],
                          style: TextStyle(
                            fontFamily: 'Metropolis',
                            fontSize: 12,
                            color: selectedIndex == index
                                ? const Color(0xff000000)
                                : const Color(0xff4a4b4d),
                            fontWeight: selectedIndex == index
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: serviceCategoryModel.length,
        ));
  }

  void _updateIndex(int index, BuildContext context) {
    setState(() {
      selectedIndex = index;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MapOrder(serviceCategoryModel[index], false, {})));
    });

    // print(serviceCategoryModel.childrenRecursive[index]);
    // // if (length == 0) {
    // context.router.push(MapOrder(
    //     serviceCategoryModelList:
    //         serviceCategoryModel.childrenRecursive[index]));
    // // }
  }
}

// class CategoryItem extends StatelessWidget {
//   final ServiceCategoryModel serviceCategoryModel;

//   const CategoryItem({
//     Key key,
//     @required this.serviceCategoryModel,
//   })  : assert(serviceCategoryModel != null),
//         super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0),
//       child: StripContainer(
//         child: SizedBox(
//           height: 128,
//           child: Row(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20.0),
//                   child: Container(
//                     width: 120,
//                     height: 120,
//                     color: Colors.grey.shade200,
//                     child: CachedNetworkImage(
//                       imageUrl: serviceCategoryModel.image,
//                       fit: BoxFit.cover,
//                       placeholder: (context, url) =>
//                           CircularProgressIndicator(),
//                       errorWidget: (context, url, error) => Icon(
//                         Icons.error,
//                         size: 75,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Text(
//                     serviceCategoryModel.name,
//                     style: TextStyle(
//                       fontFamily: 'Metropolis',
//                       fontSize: 16,
//                       color: const Color(0xff4a4b4d),
//                       fontWeight: FontWeight.w700,
//                     ),
//                     textAlign: TextAlign.left,
//                   ),
//                   Text(
//                     serviceCategoryModel.description ?? 'no description',
//                     style: TextStyle(
//                       fontFamily: 'Metropolis',
//                       fontSize: 12,
//                       color: const Color(0xffb6b7b7),
//                       height: 1.6,
//                     ),
//                     textHeightBehavior:
//                         TextHeightBehavior(applyHeightToFirstAscent: false),
//                     textAlign: TextAlign.left,
//                   ),
//                   Text("Rs." + serviceCategoryModel.price),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

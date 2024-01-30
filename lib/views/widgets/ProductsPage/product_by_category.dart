import 'package:ecom_app/controllers/category_controllers.dart';
import 'package:ecom_app/models/categories_models.dart';
import 'package:ecom_app/models/products_models.dart';
import 'package:ecom_app/responsive/responsive_layout.dart';
import 'package:ecom_app/views/shared/list_item.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../controllers/products_controllers.dart';
import '../ProductsDetail/product_details.dart';

class ProductByCategory extends StatefulWidget {
  const ProductByCategory({Key? key}) : super(key: key);

  @override
  _ProductByCategoryState createState() => _ProductByCategoryState();
}

class _ProductByCategoryState extends State<ProductByCategory> {
  final ProductController products = ProductController();

  final CategoryController categoryController = CategoryController();

  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    products.fetchProductsData();
    products.fetchProductsByCategory();
    categoryController.fetchAllCategoriesData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FutureBuilder(
          future: categoryController.fetchAllCategoriesData(),
          builder: (context, AsyncSnapshot<List<Categories>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Categories>? cat = snapshot.data;
              print(cat);
              return Container(
                height: 50.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cat?.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: selectedCategory == cat?[index]
                            ? Colors.blue
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        cat![index].title,
                        style: TextStyle(
                          color: selectedCategory == cat[index]
                              ? const Color.fromARGB(255, 0, 0, 0)
                              : Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
        FutureBuilder(
            future: products.fetchProductsData(),
            builder: (context, AsyncSnapshot<List<Products>?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                List<Products>? prod = snapshot.data;
                
                return LayoutBuilder(builder: (context, Constraints) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: GridView.builder(
                      itemCount: prod != null ? prod.length : 0,
                      padding: EdgeInsets.only(bottom: 150.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 817 ? 3 : 2,
                        childAspectRatio: Responsive.isMobile(context)
                            ? MediaQuery.of(context).size.aspectRatio * 1.8
                            : 1.5,
                      ),
                      itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                    data: prod?[index],
                                  ),
                                ));
                          },
                          child: ListItem(prod?[index])),
                    ),
                  );
                });
              }
            }),
      ],
    );
  }

//   Widget _buildCategoryRow(List<Categories>? categories) {
//   return Container(
//     height: 50,
//     child:
//   );
// }
}

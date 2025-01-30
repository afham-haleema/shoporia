import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shoporia_app/controllers/db_service.dart';
import 'package:shoporia_app/models/categories_model.dart';

class CategoryContainer extends StatefulWidget {
  const CategoryContainer({super.key});

  @override
  State<CategoryContainer> createState() => _CategoryContainerState();
}

class _CategoryContainerState extends State<CategoryContainer> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DbService().readCategories(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<CategoriesModel> categories =
              CategoriesModel.fromJsonList(snapshot.data!.docs)
                  as List<CategoriesModel>;
          if (categories.isEmpty) {
            return SizedBox();
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 8,
                children: categories
                    .map(
                        (e) => CategoryButton(imagepath: e.image, name: e.name))
                    .toList(),
              ),
            );
          }
        } else {
          return Shimmer(
              child: Container(
                height: 90,
                width: double.infinity,
              ),
              gradient:
                  LinearGradient(colors: [Colors.grey.shade200, Colors.white]));
        }
      },
    );
  }
}

class CategoryButton extends StatefulWidget {
  final String imagepath, name;
  const CategoryButton(
      {super.key, required this.imagepath, required this.name});

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/specific',
            arguments: {'name': widget.name});
      },
      child: Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: Offset(2, 2),
                color: Colors.grey.shade400.withOpacity(0.2),
                spreadRadius: 1)
          ],
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              widget.imagepath,
              height: 50,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              '${widget.name.substring(0, 1).toUpperCase()}${widget.name.substring(1)}',
            )
          ],
        ),
      ),
    );
  }
}

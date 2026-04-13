import 'package:flutter/material.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';

class ItemCard extends StatelessWidget {
  final String title;
  final String? imagePath;
  final String? imageUrl;
  final VoidCallback onTap;

  const ItemCard({
    Key? key,
    required this.title,
    this.imagePath,
    this.imageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: SizeConfig.blockHeight * 11.5,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(
                            Icons.image,
                            color: Colors.grey,
                            size: SizeConfig.blockHeight * 8,
                          ),
                        ),
                      )
                    : Image.asset(imagePath!, fit: BoxFit.contain),
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockWidth * 2,
                  vertical: SizeConfig.blockHeight * 0.8,
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: SizeConfig.blockHeight * 1.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

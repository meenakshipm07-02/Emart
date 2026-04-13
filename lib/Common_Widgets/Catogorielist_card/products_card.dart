import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Common_Widgets/Screen_Colors/screen_colors.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';

class ProductCard extends StatefulWidget {
  final String name;
  final String imageUrl;
  final double price;
  final bool initiallyFavourite;
  final VoidCallback? onAdd;
  final Function(bool)? onFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onBuyNow;

  const ProductCard({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.initiallyFavourite = false,
    this.onAdd,
    this.onFavorite,
    this.onTap,
    this.onBuyNow,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool isFavourite;

  @override
  void initState() {
    super.initState();
    isFavourite = widget.initiallyFavourite; // initialize with API state
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Padding(
              padding: const EdgeInsets.all(6),
              child: Container(
                height: SizeConfig.blockHeight * 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.name,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: SizeConfig.blockHeight * 1.5,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() => isFavourite = !isFavourite);

                      if (widget.onFavorite != null) {
                        await widget.onFavorite!(isFavourite);
                      }
                    },
                    child: Icon(
                      Icons.favorite,
                      size: SizeConfig.blockHeight * 2.5,
                      color: isFavourite ? Colors.red : Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.blockHeight * 0.6),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "₹ ${widget.price}",
                    style: GoogleFonts.poppins(
                      fontSize: SizeConfig.blockHeight * 1.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onAdd,
                    child: Container(
                      height: SizeConfig.blockHeight * 2.5,
                      width: SizeConfig.blockHeight * 2.5,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: SizeConfig.blockHeight * 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.blockHeight * 0.6),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 6),
              child: GestureDetector(
                onTap: widget.onBuyNow,
                child: Container(
                  width: double.infinity,
                  height: SizeConfig.blockHeight * 2.9,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.subtitle),
                  ),
                  child: Center(
                    child: Text(
                      "Buy Now",
                      style: GoogleFonts.poppins(
                        fontSize: SizeConfig.blockHeight * 1.4,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
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

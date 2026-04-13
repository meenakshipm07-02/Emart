import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Common_Widgets/Screen_Colors/screen_colors.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';
import 'package:grocery_app/Common_Widgets/Circular_progressindicator/progress_indicator.dart';

class FavouriteCard extends StatefulWidget {
  final String name;
  final String imageUrl;
  final double price;
  final bool initiallyFavourite;
  final VoidCallback onAddToCart;
  final Future<void> Function() onRemoveFavourite;
  final VoidCallback? onTap;
  final String weight;

  const FavouriteCard({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.initiallyFavourite,
    required this.onAddToCart,
    required this.onRemoveFavourite,
    this.onTap,
    required this.weight,
  }) : super(key: key);

  @override
  State<FavouriteCard> createState() => _FavouriteCardState();
}

class _FavouriteCardState extends State<FavouriteCard> {
  late bool isFavourite;
  bool isRemoving = false;

  @override
  void initState() {
    super.initState();
    isFavourite = widget.initiallyFavourite;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 0.1, vertical: 3.5),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: SizeConfig.blockWidth * 22.5,
                height: SizeConfig.blockWidth * 19.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CustomLoader(color: AppColors.success),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),

              SizedBox(width: SizeConfig.blockWidth * 5),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.name,
                            style: GoogleFonts.poppins(
                              fontSize: SizeConfig.blockWidth * 3.2,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        GestureDetector(
                          onTap: isRemoving
                              ? null
                              : () async {
                                  if (!mounted) return;
                                  setState(() => isRemoving = true);

                                  await widget.onRemoveFavourite();

                                  if (!mounted) return;
                                  setState(() => isRemoving = false);
                                },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: Container(
                              height: SizeConfig.blockHeight * 3.5,
                              width: SizeConfig.blockHeight * 4,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: isRemoving
                                    ? const SizedBox(
                                        height: 10,
                                        width: 10,
                                        child: CustomLoader(
                                          color: AppColors.error,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Image.asset(
                                        'assets/Icons/delete.png',
                                        height: SizeConfig.blockHeight * 2,
                                        width: SizeConfig.blockHeight * 2,
                                        color: AppColors.error,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.blockHeight * 0.2),
                    Text(
                      widget.weight,
                      style: GoogleFonts.poppins(
                        fontSize: SizeConfig.blockWidth * 3.1,
                        color: AppColors.subtitle,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: SizeConfig.blockHeight * 0.2),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₹ ${widget.price}",
                          style: GoogleFonts.poppins(
                            fontSize: SizeConfig.blockWidth * 3.2,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            height: SizeConfig.blockHeight * 3.2,
                            width: SizeConfig.blockHeight * 10,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: widget.onAddToCart,
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: SizeConfig.blockHeight * 1.9,
                              ),
                              label: Text(
                                'Cart',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.blockHeight * 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

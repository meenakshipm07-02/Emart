import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';

class CartCard extends StatefulWidget {
  final String imageUrl;
  final String itemName;
  final String itemWeight;
  final String itemPrice;
  final int initialQuantity;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;
  final Function(int newQuantity)? onIncrement;
  final Function(int newQuantity)? onDecrement;

  const CartCard({
    Key? key,
    required this.imageUrl,
    required this.itemName,
    required this.itemWeight,
    required this.itemPrice,
    required this.initialQuantity,
    this.onRemove,
    this.onTap,
    this.onIncrement,
    this.onDecrement,
  }) : super(key: key);

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
  }

  void increment() {
    setState(() => quantity++);
    widget.onIncrement?.call(quantity);
  }

  void decrement() {
    if (quantity > 1) {
      setState(() => quantity--);
      widget.onDecrement?.call(quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: SizeConfig.blockWidth * 22.5,
              height: SizeConfig.blockWidth * 19,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(widget.imageUrl, fit: BoxFit.contain),
              ),
            ),

            SizedBox(width: SizeConfig.blockWidth * 5),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.itemName,
                              style: GoogleFonts.poppins(
                                fontSize: SizeConfig.blockWidth * 3.2,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: SizeConfig.blockHeight * 0.5),
                            Text(
                              widget.itemWeight,
                              style: GoogleFonts.poppins(
                                fontSize: SizeConfig.blockWidth * 3.1,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          height: SizeConfig.blockHeight * 3.2,
                          width: SizeConfig.blockHeight * 10,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                201,
                                68,
                                58,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 3,
                              ),
                            ),
                            onPressed: widget.onRemove ?? () {},
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: SizeConfig.blockHeight * 1.9,
                            ),
                            label: Text(
                              'Remove',
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

                  SizedBox(height: SizeConfig.blockHeight * 0.5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.itemPrice,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.blockWidth * 3.2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        height: SizeConfig.blockHeight * 3.2,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: decrement,
                              child: Container(
                                height: SizeConfig.blockHeight * 3,
                                width: SizeConfig.blockHeight * 3.5,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.black,
                                  size: 18,
                                ),
                              ),
                            ),
                            SizedBox(width: SizeConfig.blockWidth * 2.5),
                            Text(
                              '$quantity',
                              style: GoogleFonts.poppins(
                                fontSize: SizeConfig.blockWidth * 3.8,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: SizeConfig.blockWidth * 2.5),
                            GestureDetector(
                              onTap: increment,
                              child: Container(
                                height: SizeConfig.blockHeight * 3,
                                width: SizeConfig.blockHeight * 3.5,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}

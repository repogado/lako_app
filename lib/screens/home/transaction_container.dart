import 'package:flutter/material.dart';
import 'package:lako_app/models/user.dart';
import 'package:lako_app/widgets/buttons/def_button.dart';

class TransactionContainer extends StatefulWidget {
  final User customer;
  final User vendor;

  const TransactionContainer(
      {Key? key, required this.customer, required this.vendor})
      : super(key: key);

  @override
  State<TransactionContainer> createState() => _TransactionContainerState();
}

class _TransactionContainerState extends State<TransactionContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Stack(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    child: Icon(
                      Icons.chat,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Icon(
                      Icons.info,
                      color: Colors.blue,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                   widget.vendor.vendor!.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "500 meters",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Customer: ${widget.customer.firstName} ${widget.customer.lastName}",
                      style: TextStyle(color: Colors.white),
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.vendor.imgUrl == null
                          ? "https://cdn-icons-png.flaticon.com/512/149/149071.png"
                          : widget.vendor.imgUrl!),
                      radius: 20,
                    ),
                  ],
                ),
                Divider(color: Colors.white),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Vendor: ${widget.vendor.firstName} ${widget.vendor.lastName}",
                      style: TextStyle(color: Colors.white),
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.vendor.imgUrl == null
                          ? "https://cdn-icons-png.flaticon.com/512/149/149071.png"
                          : widget.vendor.imgUrl!),
                      radius: 20,
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: DefButton(
                        onPress: () {},
                        title: "DELIVERED",
                        mode: 3,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: DefButton(
                        onPress: () {},
                        title: "CANCEL",
                        mode: 3,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

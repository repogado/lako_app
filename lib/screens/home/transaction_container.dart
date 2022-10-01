import 'package:flutter/material.dart';
import 'package:lako_app/widgets/buttons/def_button.dart';

class TransactionContainer extends StatefulWidget {
  const TransactionContainer({Key? key}) : super(key: key);

  @override
  State<TransactionContainer> createState() => _TransactionContainerState();
}

class _TransactionContainerState extends State<TransactionContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  "TAHO VENDOR",
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
                    "Customer: Test Customer",
                    style: TextStyle(color: Colors.white),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
                    radius: 20,
                  ),
                ],
              ),
              Divider(color: Colors.white),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Vendor: Rey Pogado",
                    style: TextStyle(color: Colors.white),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
                    radius: 20,
                  ),
                ],
              ),
              SizedBox(height: 15),
              DefButton(
                onPress: () {},
                title: "CANCEL",
                mode: 3,
              )
            ],
          ),
        ],
      ),
    );
  }
}

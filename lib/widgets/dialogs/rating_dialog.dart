import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

showRatingDialog(BuildContext context, Function onSubmit) {
  double rating = 0;
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Submit"),
    onPressed: () {
      Navigator.pop(context);
      onSubmit(rating);
    },
  );
  Widget continueButton = TextButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text('Please rate your vendor'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: Align(
            alignment: Alignment.center,
            child: RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rate) {
                rating = rate;
              },
            ),
          ),
        ),
      ],
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

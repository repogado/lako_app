import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

showRatingDialog(BuildContext context,int id ,Function onSubmit) {

  TextEditingController _textController = TextEditingController();

  double rating = 0;
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Submit"),
    onPressed: () {
      Navigator.pop(context);
      onSubmit(id, rating,_textController.text);
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
              maxRating: 5,
              direction: Axis.horizontal,
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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.only(top:15),
          decoration: BoxDecoration(
            border: Border.all(width: 1,color: Colors.grey)
          ),
          child: TextFormField(
            controller: _textController,
            minLines:
                4, // any number you need (It works as the rows for the textarea)
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Write your experience here'
            ),
          ),
        )
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

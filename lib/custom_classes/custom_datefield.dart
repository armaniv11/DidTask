import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateField extends StatefulWidget {
  final double width;
  final double height;
  final String heading;
  final initialDate;
  final Color bgColor;
  final Color headingColor;
  final ValueChanged<String>? callBack;
  final double horizontalPadding;
  final double verticalPadding;

  const CustomDateField(
      {Key? key,
      this.width = double.maxFinite,
      this.height = 20.0,
      required this.heading,
      this.bgColor = Colors.white,
      this.headingColor = Colors.grey,
      required this.callBack,
      required this.initialDate,
      this.horizontalPadding = 8.0,
      this.verticalPadding = 6.0})
      : super(key: key);

  @override
  _CustomDateFieldState createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    print("initial Date");
    print(widget.initialDate);
    String heading = widget.heading;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: widget.horizontalPadding,
          vertical: widget.verticalPadding),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: widget.bgColor),
          width: widget.width,
          // height: widget.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(heading),
              const SizedBox(
                  height: 20,
                  child: const VerticalDivider(
                    color: Colors.blue,
                    thickness: 2,
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.initialDate ??
                      DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                  height: 20,
                  child: VerticalDivider(
                    color: Colors.blue,
                    thickness: 2,
                  )),
              InkWell(
                onTap: () async {
                  final choice = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2021),
                      lastDate: DateTime(2023),
                      initialDate: DateTime.parse(widget.initialDate));
                  print(choice);
                  if (choice != null) {
                    setState(() {
                      // dateSelected = DateFormat('yyyy-MM-dd').format(choice);
                      widget.callBack!(DateFormat('yyyy-MM-dd').format(choice));
                    });
                  }
                },
                child: const Icon(
                  Icons.edit,
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

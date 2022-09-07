import 'package:flutter/material.dart';

class CustomDropDown extends StatefulWidget {
  final String? heading;
  final List? items;
  final String? selected;
  final ValueChanged<String> callBack;
  final bool showHeading;
  final double horizontalPadding;
  final double verticalPadding;
  final Color color;

  const CustomDropDown(
      {Key? key,
      required this.heading,
      required this.items,
      required this.callBack,
      required this.selected,
      this.showHeading = true,
      this.color = Colors.black,
      this.horizontalPadding = 8,
      this.verticalPadding = 2})
      : super(key: key);

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    String? _selected = widget.selected;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              !widget.showHeading
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(left: 10, right: 6),
                      child: Text(
                        widget.heading!,
                        style: TextStyle(
                            fontSize: 12,
                            color: widget.color,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
              !widget.showHeading
                  ? Container()
                  : const SizedBox(
                      height: 20,
                      child: VerticalDivider(
                        color: Colors.blue,
                        thickness: 2,
                      )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: DropdownButton(
                    hint: const Text("Please select an option!!"),
                    underline: const SizedBox(),
                    onChanged: (dynamic val) {
                      setState(() {
                        _selected = val;

                        widget.callBack(_selected!);
                      });
                    },
                    isExpanded: true,
                    iconEnabledColor: Colors.blue[800],
                    dropdownColor: Colors.grey[100],
                    style: TextStyle(
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800]),
                    value: _selected,
                    items: widget.items!.map((location) {
                      return DropdownMenuItem(
                        child: Text(location),
                        value: location,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

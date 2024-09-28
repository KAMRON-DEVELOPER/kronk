import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  final Function(DateTime?) onDatePicked;
  const DatePicker({super.key, required this.onDatePicked});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime selectedDate = DateTime.now();
  late final FixedExtentScrollController dayController;
  late final FixedExtentScrollController monthController;
  late final FixedExtentScrollController yearController;

  @override
  void initState() {
    super.initState();
    dayController =
        FixedExtentScrollController(initialItem: selectedDate.day - 1);
    monthController =
        FixedExtentScrollController(initialItem: selectedDate.month - 1);
    yearController = FixedExtentScrollController(initialItem: 99);
    print("${yearController.initialItem}");
  }

  @override
  void dispose() {
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      padding: const EdgeInsets.all(8),
      color: Colors.blueGrey.withOpacity(0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("${selectedDate.toLocal()}".split(' ')[0]),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Day selector
              _buildDaySelector(),
              // Month selector
              _buildMonthSelector(),
              // Year selector
              _buildYearSelector(),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              widget.onDatePicked(selectedDate);
            },
            child: const Text("Select the Date"),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return Container(
      width: 60,
      height: 150,
      alignment: Alignment.center,
      child: ListWheelScrollView.useDelegate(
        controller: dayController,
        itemExtent: 50,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) {
          setState(() {
            selectedDate =
                DateTime(selectedDate.year, selectedDate.month, index + 1);
          });
        },
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: 31,
          builder: (context, index) {
            return Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: selectedDate.day - 1 == index ? 24 : 16,
                  color: selectedDate.day - 1 == index
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      width: 60,
      height: 150,
      alignment: Alignment.center,
      child: ListWheelScrollView.useDelegate(
        controller: monthController,
        itemExtent: 50,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) {
          setState(() {
            selectedDate =
                DateTime(selectedDate.year, index + 1, selectedDate.day);
          });
        },
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: 12,
          builder: (context, index) {
            return Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: selectedDate.month - 1 == index ? 24 : 16,
                  color: selectedDate.month - 1 == index
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildYearSelector() {
    return Container(
      width: 80,
      height: 150,
      alignment: Alignment.center,
      child: ListWheelScrollView.useDelegate(
        controller: yearController,
        itemExtent: 50,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) {
          setState(() {
            selectedDate = DateTime(DateTime.now().year - 99 + index,
                selectedDate.month, selectedDate.day);
          });
        },
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: 100,
          builder: (context, index) {
            return Center(
              child: Text(
                '${DateTime.now().year - 99 + index}',
                style: TextStyle(
                  fontSize:
                      selectedDate.year == DateTime.now().year - 99 + index
                          ? 24
                          : 16,
                  color: selectedDate.year == DateTime.now().year - 99 + index
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void showCustomDateSelector({
  required BuildContext context,
  required Function(DateTime?) onDateSelected,
}) {
  showGeneralDialog(
    context: context,
    barrierColor: Colors.black54,
    barrierDismissible: true,
    barrierLabel: "",
    transitionDuration: const Duration(milliseconds: 150),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return Transform.scale(
        scale: animation.value,
        child: Opacity(
          opacity: animation.value,
          child: Dialog(
            backgroundColor: Colors.greenAccent.withOpacity(0.2),
            // clipBehavior: Clip.antiAlias,
            insetPadding: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: DatePicker(
              onDatePicked: (pickedDate) {
                onDateSelected(pickedDate);
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return const SizedBox.shrink();
    },
  );
}

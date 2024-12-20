import 'package:flutter/material.dart';

class ExpensesBar extends StatelessWidget {
  const ExpensesBar(
      {super.key,
      required this.day,
      required this.totalSpend,
      required this.totalAmountRatio});
  final String day;
  final double totalSpend;
  final double totalAmountRatio;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            FittedBox(child: Text('$totalSpend')),
            const SizedBox(
              height: 5,
            ),
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.15,
                  width: 15,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height*0.15 * totalAmountRatio,
                  width: 15,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(day),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/bar.dart';
import 'model.dart';
class Chart extends StatelessWidget {
 const Chart({super.key, required this.resent});
  final List<ExpensesData> resent;
  List<Map<String,Object>> get logicList{
    return List.generate(7, (index) {
      var day = DateTime.now().subtract(Duration(days: index));
      double sum=0.0;
      for (var i = 0; i < resent.length; i++) {
        if (resent[i].dateTime.day == day.day &&
            resent[i].dateTime.month == day.month &&
            resent[i].dateTime.year == day.year)
        {
          sum += resent[i].amount;
        }
      }
      return {
        'day': DateFormat('E').format(day),
        'spend':sum
      };
    }).reversed.toList();
  }
  double get totalSpending {
    return logicList.fold(0.0, (sum, item) {
      return sum + (item['spend'] as double);
    });
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height*0.25,
      child: Card(
        elevation: 6,
        color: Colors.white,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: logicList.map((e) {
              return ExpensesBar(
                day: e['day'] as String,
                totalSpend: e['spend'] as double,
                totalAmountRatio: totalSpending==0.0?0.0:
                (e['spend'] as double)/totalSpending,
              );
            },).toList()
        ),
      ),
    );
  }
}

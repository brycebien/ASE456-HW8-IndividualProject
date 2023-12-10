import 'package:ase456_hw8_individual_project/utility/date_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class QueryReport {
  final List<Map<String, dynamic>> resultsList = [];
  final FirebaseFirestore fireStore;
  final String startDate;
  final String endDate;

  QueryReport(
      {required this.fireStore,
      required this.startDate,
      required this.endDate});

  Future<List<Map<String, dynamic>>?> queryRecord() async {
    List<Map<String, dynamic>> resultsList = [];
    CollectionReference records = fireStore.collection('records');
    QuerySnapshot querySnapshot;

    if (startDate != '' && endDate != '') {
      DateTime startDate =
          DateTime.parse(DateValidator.ValidateDate(this.startDate));
      DateTime endDate =
          DateTime.parse(DateValidator.ValidateDate(this.endDate));

      List<DateTime> dateList = Iterable.generate(
        endDate.difference(startDate).inDays + 1,
        (i) => startDate.add(Duration(days: i)),
      ).toList();

      for (DateTime date in dateList) {
        print('DATE BEING QUER:::${DateFormat('yyyy-MM-dd').format(date)}');
        Query querySearch = records.where('date',
            isEqualTo: DateFormat('yyyy-MM-dd').format(date));
        querySnapshot = await querySearch.get();
        querySnapshot.docs.forEach(
          (DocumentSnapshot document) {
            Map<String, dynamic> results =
                document.data() as Map<String, dynamic>;
            resultsList.add(results);
          },
        );
      }
      return resultsList;
    } else {
      return null;
    }
  }
}

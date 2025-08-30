import 'package:attendify/app/utils/calendar_utils.dart';
import 'package:get/get.dart';

class AdminManageAttandanceViewModel extends GetxController {
  RxString monthName = CalendarUtils.getCurrentMonthName().obs;
  RxString year = CalendarUtils.getCurrentYear().toString().obs;
  RxString selectedYear = ''.obs;
  RxString selectedMonth = ''.obs;
  RxList monthsList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ].obs;
  RxList yearList = [
    '2024',
    '2025',
    '2026',
    '2027',
    '2028',
    '2029',
    '2030',
    '2031',
  ].obs;
  updateyear(String sYear) {
    selectedYear.value = sYear;
  }
  updateMonth(String sMonth){
    selectedMonth.value=sMonth;
  }

  updateAttandance(String sMonth, String sYear) {
    monthName.value = sMonth;
    year.value = sYear;
  }
}

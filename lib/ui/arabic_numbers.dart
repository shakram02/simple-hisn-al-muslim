const String arabicNumbers = '٠١٢٣٤٥٦٧٨٩';

String arabicNumber(int number) {
  return number
      .toString()
      .split('')
      .map((char) => arabicNumbers[int.parse(char)])
      .join('');
}

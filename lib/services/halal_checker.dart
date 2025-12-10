/// Daftar kata kunci bahan/makanan/minuman yang dianggap tidak halal.
/// Kita pakai pendekatan blacklist sederhana berbasis substring.
const List<String> haramKeywords = [
  // Daging babi & turunannya
  'pork',
  'pig',
  'bacon',
  'ham',
  'prosciutto',
  'salami',
  'pepperoni',
  'chorizo',
  'sausage',
  'pancetta',
  'lard',
  'gammon',

  // Alkohol
  'wine',
  'red wine',
  'white wine',
  'cooking wine',
  'beer',
  'ale',
  'cider',
  'rum',
  'vodka',
  'whisky',
  'whiskey',
  'gin',
  'brandy',
  'tequila',
  'bourbon',
  'champagne',
  'liqueur',
  'amaretto',

  // Lainnya yang umum diragukan
  'gelatin',
  'non-halal',
];

/// Mengecek apakah daftar teks (ingredients, title, summary, dll)
/// mengandung kata-kata yang dianggap haram.
/// Jika ada SATU saja teks yang mengandung keyword haram → return false (tidak halal).
/// Kalau tidak ada satupun → dianggap halal.
bool checkHalalStatus(List<String> texts) {
  for (final text in texts) {
    final lower = text.toLowerCase();
    for (final keyword in haramKeywords) {
      if (lower.contains(keyword)) {
        return false;
      }
    }
  }
  return true;
}

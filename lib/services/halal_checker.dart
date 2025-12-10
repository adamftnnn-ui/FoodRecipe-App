const List<String> haramKeywords = [
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
  'gelatin',
  'non-halal',
];

bool checkHalalStatus(List<String> texts) {
  for (final text in texts) {
    final String lower = text.toLowerCase();
    for (final keyword in haramKeywords) {
      if (lower.contains(keyword)) {
        return false;
      }
    }
  }
  return true;
}

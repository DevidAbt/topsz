class AutocompleteResult {
  final String value;

  AutocompleteResult({required this.value});

  factory AutocompleteResult.fromJson(Map<String, dynamic> json) {
    return AutocompleteResult(value: json['value']);
  }
}

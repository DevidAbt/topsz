// ignore_for_file: non_constant_identifier_names
class SearchResult {
  final String dict;
  final int resultCount;
  final List<Basic> basic;
  final List<Extended> extended;

  SearchResult({
    required this.dict,
    required this.resultCount,
    required this.basic,
    required this.extended,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
        dict: json["dict"],
        resultCount: json["resultCount"],
        basic: (json["basic"] as List).map((e) => Basic.fromJson(e)).toList(),
        extended: (json["extended"] as List)
            .map((e) => Extended.fromJson(e))
            .toList());
  }
}

class Basic {
  final String headword;
  final String? variant;
  final String? pronunciation_UK;
  final List<Pos> POSs;

  Basic({
    required this.headword,
    required this.variant,
    required this.pronunciation_UK,
    required this.POSs,
  });

  factory Basic.fromJson(Map<String, dynamic> json) {
    return Basic(
        headword: json["headword"],
        variant: json["variant"],
        pronunciation_UK: json["pronunciation_UK"],
        POSs: (json["POSs"] as List).map((e) => Pos.fromJson(e)).toList());
  }
}

class Pos {
  final String pos;
  final String ord;
  final List<SenseGroup> sensegroups;
  final String? POSspec;

  Pos({
    required this.pos,
    required this.ord,
    required this.sensegroups,
    required this.POSspec,
  });

  factory Pos.fromJson(Map<String, dynamic> json) {
    return Pos(
        pos: json["pos"],
        ord: json["ord"],
        sensegroups: (json["sensegroups"] as List)
            .map((e) => SenseGroup.fromJson(e))
            .toList(),
        POSspec: json["POSspec"]);
  }
}

class SenseGroup {
  final String? sensegrouptype;
  final String? specheadword;
  final String? NounCountableuncountable;
  final String? VerbTransitive;
  final String? VerbType;
  final String? AdejctiveWherenoun;
  final String? ord;
  final String? remark;
  final List<Sense> senses;

  SenseGroup(
      {required this.sensegrouptype,
      required this.specheadword,
      required this.NounCountableuncountable,
      required this.VerbTransitive,
      required this.VerbType,
      required this.AdejctiveWherenoun,
      required this.ord,
      required this.remark,
      required this.senses});

  factory SenseGroup.fromJson(Map<String, dynamic> json) {
    return SenseGroup(
        sensegrouptype: json["sensegrouptype"],
        specheadword: json["specheadword"],
        NounCountableuncountable: json["NounCountableuncountable"],
        VerbTransitive: json["VerbTransitive"],
        VerbType: json["VerbType"],
        AdejctiveWherenoun: json["AdejctiveWherenoun"],
        ord: json["ord"],
        remark: json["remark"],
        senses:
            (json["senses"] as List).map((e) => Sense.fromJson(e)).toList());
  }
}

class Sense {
  final String word;
  final String? example;
  final String? style_labels;
  final String? subject_labels;
  final String? regional_labels;
  final String? ord;

  Sense({
    required this.word,
    required this.example,
    required this.style_labels,
    required this.subject_labels,
    required this.regional_labels,
    required this.ord,
  });

  factory Sense.fromJson(Map<String, dynamic> json) {
    return Sense(
        word: json["word"],
        example: json["example"],
        style_labels: json["style_labels"],
        subject_labels: json["subject_labels"],
        regional_labels: json["regional_labels"],
        ord: json["ord"]);
  }
}

class Extended {
  final String headword;
  final List<String> senses;

  Extended({
    required this.headword,
    required this.senses,
  });

  factory Extended.fromJson(Map<String, dynamic> json) {
    List<String> senses;
    if (json.containsKey("senses")) {
      senses = (json['senses'] as List).cast<String>();
    } else {
      senses = (json['POSs']["1"]["sensegroups"]["1"]["senses"]["1"] as String)
          .split(";");
    }
    return Extended(headword: json['headword'], senses: senses);
  }
}

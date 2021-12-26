import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:topsz/models/SearchResult.dart';
import 'package:topsz/service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _typeAheadController = TextEditingController();

  SearchResult? _searchResult;

  String _dictOption = "🇬🇧 ⇉ 🇭🇺";
  List<String> _dictOptions = ["🇬🇧 ⇉ 🇭🇺", "🇭🇺 ⇉ 🇬🇧"];
  String _dict = "ENHU";
  List<String> _dicts = ["ENHU", "HUEN"];

  bool _searched = false;
  bool _offline = false;

  void _search(String word) async {
    try {
      _typeAheadController.text = word;
      SearchResult? searchResult = await getResults(
          "EN", _dicts[_dictOptions.indexOf(_dictOption)], word);
      setState(() {
        _searchResult = searchResult;
        _searched = true;
        _offline = false;
      });
    } catch (e) {
      if (e is SocketException) {
        setState(() {
          _searched = true;
          _offline = true;
        });
      }
    }
  }

  Future<List<String>> _getAutocomplete(String pattern) async {
    List<String> suggestions;
    try {
      suggestions = await getAutocomplete("EN", _dict, pattern);
      setState(() {
        _offline = false;
      });
    } catch (e) {
      suggestions = [];
      if (e is SocketException) {
        setState(() {
          _offline = true;
        });
      }
    }
    return suggestions;
  }

  void _clear() {
    _typeAheadController.clear();
    _searchResult = null;
    _searched = false;
  }

  Widget _buildMeaningCards() {
    if (_searchResult != null && _searchResult!.basic.length > 0) {
      Basic basic = _searchResult!.basic[0];
      var meaningCards =
          basic.POSs.map((pos) => _buildMeaningCard(pos)).toList();
      var cardList = [
        _buildTitleCard(basic.headword, basic.pronunciation_UK),
        ...meaningCards
      ];

      return ListView(
        padding: EdgeInsets.zero,
        children: cardList,
      );
    } else {
      List<Widget> list = [];
      if (_offline || _searched) {
        String errorMessage = _offline ? "No network" : "Not found";
        list.add(_buildTitleCard(errorMessage, null));
      }
      return ListView(
        padding: EdgeInsets.zero,
        children: list,
      );
    }
  }

  Widget _buildTitleCard(String expression, String? pronunciation) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      expression,
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                pronunciation != null
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12, top: 5),
                          child: Text(
                            pronunciation,
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          )),
    );
  }

  Widget _buildMeaningCard(Pos pos) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
          elevation: 5,
          child: Container(
            // decoration: BoxDecoration(border: Border.all(width: 1)),
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: pos.sensegroups
                                  .map((sg) => Padding(
                                        padding: const EdgeInsets.only(
                                            top: 2, bottom: 2, right: 10),
                                        child: Text(
                                            "• ${sg.senses.map((s) => s.word).join(", ")}",
                                            style: TextStyle(fontSize: 22)),
                                      ))
                                  .toList()),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Stack(
                      children: [
                        Card(
                          elevation: 3,
                          color: Colors.grey[700],
                          child: Align(
                            alignment: Alignment.center,
                            widthFactor: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                pos.pos,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 50, 15, 15),
          child: Center(
              child: DropdownButton(
            elevation: 16,
            style: TextStyle(fontSize: 35),
            onChanged: (String? changedValue) {
              setState(() {
                _dictOption = changedValue!;
                _dict = _dicts[_dictOptions.indexOf(_dictOption)];
                _clear();
              });
            },
            value: _dictOption,
            items: _dictOptions
                .map((value) =>
                    DropdownMenuItem(value: value, child: Text(value)))
                .toList(),
          )),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
                onSubmitted: (word) => _search(word),
                autofocus: true,
                controller: _typeAheadController,
                style: TextStyle(fontSize: 32),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0x2196f3))),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () => {
                        setState(() {
                          _clear();
                        })
                      },
                    ))),
            suggestionsCallback: (pattern) async {
              if (pattern == "") {
                return [];
              }
              return _getAutocomplete(pattern);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion!.toString()),
              );
            },
            onSuggestionSelected: (suggestion) {
              _search(suggestion as String);
            },
          ),
        ),
        Expanded(child: _buildMeaningCards())
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    ));
  }
}

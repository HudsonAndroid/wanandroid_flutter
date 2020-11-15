
import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/data/entity/search_word.dart';
import 'package:wanandroid_flutter/data/repository/wan_repository.dart';
import 'package:wanandroid_flutter/generated/l10n.dart';
import 'package:wanandroid_flutter/ui/common/wrap_layout.dart';

typedef OnKeyWordClick = void Function(SearchWord word);

class DefaultSearchPage extends StatefulWidget {
  final OnKeyWordClick wordClick;

  DefaultSearchPage({Key key, this.wordClick}): super(key: key);

  @override
  State<StatefulWidget> createState() => _DefaultSearchPageState();

}

class _DefaultSearchPageState extends State<DefaultSearchPage> {
  List<SearchWord> searchWords = [];

  @override
  void initState() {
    super.initState();
    _loadHotWords();
  }

  _loadHotWords() async {
    searchWords = await WanRepository().getHotSearch();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, top: 15),
          child: Text(S.of(context).hot_search),
        ),
        WrapLayout(
          contents: searchWords,
          onItemClick: (item, position){
            widget.wordClick(searchWords[position]);
          },
        )
      ],
    );
  }

}
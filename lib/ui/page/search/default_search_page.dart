import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroid_flutter/data/entity/search_word.dart';
import 'package:wanandroid_flutter/data/repository/wan_repository.dart';
import 'package:wanandroid_flutter/generated/l10n.dart';
import 'package:wanandroid_flutter/ui/common/round_button.dart';
import 'package:wanandroid_flutter/ui/common/wrap_layout.dart';
import 'package:wanandroid_flutter/ui/page/search/search_page.dart';

typedef OnKeyWordClick = void Function(String word);

class DefaultSearchPage extends StatefulWidget {
  final OnKeyWordClick wordClick;

  DefaultSearchPage({Key key, this.wordClick}): super(key: key);

  @override
  State<StatefulWidget> createState() => _DefaultSearchPageState();

}

class _DefaultSearchPageState extends State<DefaultSearchPage> {
  List<SearchWord> searchWords = [];
  List<String> historyWords = [];

  @override
  void initState() {
    super.initState();
    _loadHotWords();
    _loadHistoryWords();
  }

  _loadHotWords() async {
    searchWords = await WanRepository().getHotSearch();
    setState(() {});
  }

  _loadHistoryWords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    historyWords = prefs.getStringList(SearchPage.KEY_HISTORY).reversed.toList();
    setState(() {});
  }

  _cleanHistoryWords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(SearchPage.KEY_HISTORY, null);
    setState(() {
      historyWords = null;
    });
  }
  
  Widget _createHistory() {
    if(historyWords == null || historyWords.length == 0){
      return Container();
    }else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10, top: 15),
                child: Text(S.of(context).history_search),
              ),
              Expanded(
                child: SizedBox(),
              ),
              RoundButton(
                height: 25,
                style: TextStyle(color: Colors.grey, fontSize: 10),
                borderColor: Colors.grey,
                bgColor: Colors.transparent,
                text: S.of(context).action_clean_record,
                margin: EdgeInsets.only(top: 15, right: 8),
                onPressed: (){
                  _cleanHistoryWords();
                },
              )
            ],
          ),
          WrapLayout(
            contents: historyWords,
            onItemClick: (item, position){
              widget.wordClick(historyWords[position]);
            },
          )
        ],
      );
    }
  }

  Widget _createHotSearch() {
    if(searchWords == null || searchWords.length == 0) {
      return Container();
    }else{
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
              widget.wordClick(searchWords[position].name);
            },
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _createHotSearch(),
        _createHistory()
      ],
    );
  }

}
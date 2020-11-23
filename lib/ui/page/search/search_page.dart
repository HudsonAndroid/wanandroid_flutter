import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroid_flutter/data/repository/wan_repository.dart';
import 'package:wanandroid_flutter/generated/l10n.dart';
import 'package:wanandroid_flutter/ui/page/article_page.dart';
import 'package:wanandroid_flutter/ui/page/search/default_search_page.dart';

class SearchPage extends StatefulWidget {
  static const String KEY_HISTORY = "history_search";
  static const int MAX_HISTORY_COUNT = 16;

  @override
  State<StatefulWidget> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  TextEditingController _controller = TextEditingController();
  String searchWord;
  String editContent;

  Future<bool> _onWillPop() async {
    if (searchWord != null) {
      // is on second page, clean it
      _controller.text = '';
      setState(() {
        searchWord = null;
        editContent = null;
      });
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      /// 修改返回的逻辑
      child: Scaffold(
        appBar: AppBar(
          // 标题设置成输入框
          title: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            controller: _controller,
            onChanged: (String value) {
              editContent = value;
            },
            maxLines: 1,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 8, left: 6, right: 6),
              hintText: S.of(context).tips_search_hint,
              filled: true,
              fillColor: (Colors.white70),
              hintStyle: new TextStyle(color: Colors.grey),
              border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(7),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: S.of(context).action_search,
              onPressed: () {
                if (editContent != null && editContent.trim().length > 0) {
                  setState(() {
                    searchWord = editContent;
                  });
                  _saveSearchHistory(editContent);
                }
              },
            )
          ],
        ),
        body: _getPage(),
      ),
    );
  }

  _saveSearchHistory(String word) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> historyWords = prefs.getStringList(SearchPage.KEY_HISTORY);
    if (historyWords != null) {
      if (historyWords.length > SearchPage.MAX_HISTORY_COUNT) {
        historyWords
            .sublist(historyWords.length - SearchPage.MAX_HISTORY_COUNT);
      }
      if (historyWords.contains(word)) {
        historyWords.remove(word);
      }
    } else {
      historyWords = [];
    }
    historyWords.add(word);
    prefs.setStringList(SearchPage.KEY_HISTORY, historyWords);
  }

  Widget _getPage() {
    if (searchWord == null) {
      return DefaultSearchPage(
        wordClick: (word) {
          _controller.text = word;
          setState(() {
            searchWord = word;
          });
          _saveSearchHistory(word);
        },
      );
    } else {
      return ArticlePage(
        loadArticle: (int pageNo) {
          return WanRepository().getSearchResult(searchWord, pageNo);
        },
      );
    }
  }
}

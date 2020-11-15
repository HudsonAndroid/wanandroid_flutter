
import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/data/repository/wan_repository.dart';
import 'package:wanandroid_flutter/generated/l10n.dart';
import 'package:wanandroid_flutter/ui/page/article_page.dart';
import 'package:wanandroid_flutter/ui/page/search/default_search_page.dart';

class SearchPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => SearchPageState();

}

class SearchPageState extends State<SearchPage> {
  TextEditingController _controller = TextEditingController();
  String searchWord;
  String editContent;

  Future<bool> _onWillPop() async {
    if(searchWord != null){
      // is on second page, clean it
      _controller.text = '';
      setState(() {
        searchWord = null;
        editContent = null;
      });
      return false;
    }else{
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
//        title: Text(S.of(context).action_search),
          actions: <Widget>[
            Container(
              width: 290,
              margin: EdgeInsets.only(top: 8, bottom: 8),
              alignment: Alignment.center,
              /// 有个问题，文字居然垂直方向没法居中
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                controller: _controller,
                onChanged: (String value){
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
            ),
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: S.of(context).action_search,
              onPressed: () {
                if(editContent != null && editContent.trim().length > 0){
                  setState(() {
                    searchWord = editContent;
                  });
                }
              },
            )
          ],
        ),
        body: _getPage(),
      ),
    );
  }

  Widget _getPage() {
    if(searchWord == null){
      return DefaultSearchPage(
        wordClick: (word){
          _controller.text = word.name;
          setState(() {
            searchWord = word.name;
          });
        },
      );
    }else{
      return ArticlePage(
        loadArticle: (int pageNo){
          return WanRepository().getSearchResult(searchWord, pageNo);
        },
      );
    }
  }

}
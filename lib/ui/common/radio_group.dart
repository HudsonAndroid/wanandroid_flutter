
import 'package:flutter/material.dart';

typedef OnSelectChange = void Function(RadioModel model);

class RadioGroup extends StatefulWidget{
  final List<RadioModel> selections = [];
  final double itemHeight;
  final OnSelectChange onSelectChange;

  RadioGroup(List<RadioModel> selectionList, {this.itemHeight = 60, this.onSelectChange})
      : assert(selectionList != null) {
    selections.addAll(selectionList);
  }

  @override
  State<StatefulWidget> createState() => _RadioGroupState();

}

class _RadioGroupState extends State<RadioGroup> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.selections.length,
        itemBuilder: (context, index){
          return Container(
            height: widget.itemHeight,
            margin: EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.center,
            child: InkWell(
              onTap: (){
                for(int i = 0; i < widget.selections.length; i++ ) {
                  if(index == i){
                    widget.selections[i].selected = true;
                  }else{
                    widget.selections[i].selected = false;
                  }
                }
                setState(() {});
                if(widget.onSelectChange != null){
                  widget.onSelectChange(widget.selections[index]);
                }
                Navigator.of(context).pop();
              },
              child: RadioButton(widget.selections[index], height: widget.itemHeight),
            ),
          );
        });
  }

}

class RadioButton extends StatelessWidget {
  final RadioModel _model;
  final double height;

  RadioButton(this._model, {this.height = 60});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(_model.displayText),
        Expanded(child: SizedBox(height: height,),),
        _buildSelectState()
      ],
    );
  }

  _buildSelectState(){
    if(_model.selected){
      return Icon(
        Icons.check
      );
    }else{
      return Container();
    }
  }

}

class RadioModel {
  bool selected = false;
  /// 展示选择的文本
  final String displayText;
  /// 实际代表的数据
  final dynamic label;

  RadioModel(this.displayText, this.label, {this.selected});

  RadioModel.simple(String text, {this.selected}): displayText = text, label = text;
}
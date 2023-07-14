
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SQRefresh extends StatefulWidget {

  final SQRefreshModel model;

  final Widget Function(BuildContext context, int index)? itemBuilder;

  final Widget? emptyWidget;

  const SQRefresh({super.key, required this.model, this.itemBuilder, this.emptyWidget});
  @override
  State<StatefulWidget> createState() {
    return _SQRefreshState();
  }

}

class _SQRefreshState extends State<SQRefresh> {
  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        controller: widget.model._refreshController,
        header: const ClassicHeader(
          releaseIcon:  Icon(Icons.arrow_upward, color: Colors.grey),
        ),
        footer: const ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          failedText: "无更多数据",
        ),
        enablePullDown: widget.model.canRefresh(),
        enablePullUp: widget.model.canLoadMore(),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: _getContentWidget(),


    );
  }

  Widget _getContentWidget() {
    if(widget.model.itemList.isEmpty) {
      return widget.emptyWidget ?? Container();
    }

    return ListView.builder(itemBuilder: widget.itemBuilder!,itemCount: widget.model.itemList.length,padding: EdgeInsets.zero,);
  }

  _onRefresh()  async{
    await widget.model._onRefresh();
    if(mounted) {
      setState(() {

      });
    }
    widget.model._refreshController.refreshCompleted();

  }
  _onLoading() async {
    if (widget.model._refreshController.isRefresh) {
      widget.model._refreshController.loadComplete();
      return;
    }
     await widget.model._onLoading();
    if (mounted) {
      setState(() {});
    }
    widget.model._refreshController.loadComplete();

  }


}


mixin SQRefreshModel  {

  List itemList = [];
  final _refreshController = RefreshController();

  int _pageSize = 10;
  int _pageNum = 1;

  ///是否可以下拉刷新
  bool canRefresh(){
    return true;
  }

  bool canLoadMore(){
    return true;
  }


  ///主动刷新
  callRefresh({bool needMove = true}) {
    _refreshController.requestRefresh(duration: const Duration(milliseconds: 250),needMove: needMove);
  }



  _onRefresh() async {
    _pageNum = 1;
    itemList = await loadData(_pageNum, _pageSize) ?? [];
    if(itemList.isNotEmpty) {
      _pageNum = _pageNum + 1;
    }
    listChange();
  }

  _onLoading() async {
    List list =  await loadData(_pageNum, _pageSize) ?? [];
    if(list.isNotEmpty) {
      _pageNum = _pageNum + 1;
    }
    itemList.addAll(list);
    listChange();
  }

  Future<List?> loadData(int pageNum , int pageSize) ;


  listChange(){

  }

}
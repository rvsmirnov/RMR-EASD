import 'package:MWPX/widgets/dialog_widgets/dialog.dart';
import 'package:flutter/material.dart';

/// Рамка с табами для групп элементов экрана Командировок
class MWPGroupsBox extends StatefulWidget {
  final String _frameName;
  final Widget _contentWidget;
  final String _frameName2;
  final Widget _contentWidget2;
  final EdgeInsetsGeometry? contentPadding;

  MWPGroupsBox(
    this._frameName,
    this._contentWidget,
    this._frameName2,
    this._contentWidget2, {
    this.contentPadding = const EdgeInsets.all(7),
  });

  @override
  State<MWPGroupsBox> createState() => _MWPGroupsBoxState();
}

class _MWPGroupsBoxState extends State<MWPGroupsBox>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  int intTab = 0;

  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Material(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    TabBar(
                      isScrollable: true,
                      onTap: (tabInt) {
                        // print('tabInt $tabInt');
                        setState(() {
                          intTab = tabInt;
                        });
                      },
                      padding: EdgeInsets.all(0),
                      labelPadding: EdgeInsets.all(0),
                      indicatorPadding: EdgeInsets.all(0),
                      indicator: UnderlineTabIndicator(
                        insets: EdgeInsets.all(5),
                      ),
                      indicatorWeight: 0,
                      indicatorSize: TabBarIndicatorSize.tab,
                      controller: _tabController,
                      tabs: [
                        Tab(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                  color: intTab == 0
                                      ? Color.fromARGB(255, 226, 226, 226)
                                      : Colors.white,
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      topRight: Radius.circular(7))),
                              child: Container(
                                child: Text(
                                  widget._frameName,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black87),
                                  overflow: TextOverflow.visible,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                  color: intTab == 1
                                      ? Color.fromARGB(255, 226, 226, 226)
                                      : Colors.white,
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      topRight: Radius.circular(7))),
                              child: Container(
                                child: Text(
                                  widget._frameName2,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black87),
                                  overflow: TextOverflow.visible,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 30,
                      child: IconButton(
                        onPressed: () {
                          Dialogs.infoDialog(
                            context: context,
                            title: intTab == 0
                                ? widget._frameName
                                : widget._frameName2,
                            content: intTab == 0
                                ? widget._contentWidget
                                : widget._contentWidget2,
                          );
                        },
                        icon: Icon(Icons.search),
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              // height: 40,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Expanded(
                  // child:
                  Container(
                    // width: 700,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 250, 250, 250),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    padding: widget.contentPadding,
                    child: widget._contentWidget,
                  ),
                  // ),
                  // Expanded(
                  // child:
                  Container(
                    // width: 700,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 250, 250, 250),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    padding: widget.contentPadding,
                    child: widget._contentWidget2,
                  ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class FindJob extends StatefulWidget {
  FindJob({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FindJobState createState() => _FindJobState();
}

class _FindJobState extends State<FindJob> {
  int bottomSelectedIndex = 0;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        Ongoing(),
        Completed(),
        Archived(),
      ],
    );
  }

   @override
  void initState() {
    super.initState();
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      'Ongoing',
      'Completed',
      'Archived',
    ];
    return MaterialApp(
      home: DefaultTabController(
        length: tabs.length,
        child:Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
          backgroundColor: const Color(0xffbe3e57),
          title: Center(child:Text("Find Jobs")),
          bottom: TabBar(
            indicatorColor: Colors.white,
            isScrollable: true,
            tabs : [ for (final tab in tabs) Tab(text: tab),]),),
        body: TabBarView(
            children: [
              for (final tab in tabs)
                Center(
                  child: Text(tab),
                ),
            ],
          ),
      ),)
    );
  }
}

class Ongoing extends StatefulWidget {
  @override
  _OngoingState createState() => _OngoingState();
}

class _OngoingState extends State<Ongoing> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Ongoing')
    );
  }
}

class Completed extends StatefulWidget {
  @override
  _CompletedState createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Completed')
    );
  }
}

class Archived extends StatefulWidget {
  @override
  _ArchivedState createState() => _ArchivedState();
}

class _ArchivedState extends State<Archived> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Archived')
    );
  }
}
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'Article.dart';
import 'blockurl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSwitched = false;
  late Future<List<Article>> futureArticle;
  late Future<List<BlockedUrl>> futureBlockedUrl;

  Future<List<Article>> fetchArticles() async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('Articles'));
    final ParseResponse apiResponse = await parseQuery.query();
    print(apiResponse.statusCode);
    print(apiResponse.results);
    List<Article> listOfArticle = <Article>[];
    if (apiResponse.success && apiResponse.results != null) {
      for (var object in apiResponse.results as List<ParseObject>) {
        listOfArticle.add(Article(
            objectId: object.objectId.toString(),
            author: object.get<String>('Author').toString(),
            title: object.get<String>('Title').toString(),
            content: object.get<String>('Content').toString()));
      }
    }
    print(listOfArticle);
    return listOfArticle;
  }
  Future<List<BlockedUrl>> fetchBlockedUrl() async {
    final QueryBuilder<ParseObject> parseQuery =
    QueryBuilder<ParseObject>(ParseObject('BlockedUrl'));
    final ParseResponse apiResponse = await parseQuery.query();
    print(apiResponse.statusCode);
    print(apiResponse.results);
    List<BlockedUrl> listOfBlockeUrl = <BlockedUrl>[];
    if (apiResponse.success && apiResponse.results != null) {
      for (var object in apiResponse.results as List<ParseObject>) {
        listOfBlockeUrl.add(BlockedUrl(
            objectId: object.objectId.toString(),
            enabled: object.get<String>('Enabled').toString(),
            url: object.get<String>('URL').toString()));
      }
    }
    print(listOfBlockeUrl);
    return listOfBlockeUrl;
  }

  Future<void> updateStatus(String value, String objectId) async {
    var todo = ParseObject('BlockedUrl')
      ..objectId = objectId
      ..set('Enabled', value);
    await todo.save();
  }

  @override
  void initState() {
    super.initState();
    // futureBlockedUrl = fetchBlockedUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/logo-big.png',
              scale: 5,
            ),
            Image.asset(
              'assets/logo-text.png',
              scale: 2,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20.0),
            DefaultTabController(
              length: 2, // length of tabs
              initialIndex: 0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      child: TabBar(
                        indicator: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelColor: Colors.yellow,
                        unselectedLabelColor: Colors.white,
                        labelStyle: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                        indicatorColor: Colors.black,
                        tabs: const [
                          Tab(text: 'BLOCKED'),
                          Tab(text: 'ARTICLES'),
                        ],
                      ),
                    ),
                    Container(
                      height: 400, //height of TabBarView
                      decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: Colors.grey, width: 0.5))),
                      child: TabBarView(children: <Widget>[
                        Column(
                          children: [
                            const SizedBox(
                              height: 30.0,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Add site to block:",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      decoration: TextDecoration.none),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: TextField(
                                keyboardType: TextInputType.url,
                                decoration: InputDecoration(
                                  hintText: 'www.addtoblock.com',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Blocked Sites:",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      decoration: TextDecoration.none),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "(sites can be manually blocked)",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      decoration: TextDecoration.none),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Center(
                              child: FutureBuilder<List<BlockedUrl>>(
                                future: fetchBlockedUrl(),
                                builder: (context, snapshot) {
                                  return snapshot.connectionState == ConnectionState.waiting
                                      ? const CircularProgressIndicator()
                                      : Column(
                                    children: List.generate(snapshot.data!.length,
                                          (index) {
                                        return Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                              ),
                                              child: Transform.scale(
                                                  scale: 2.0,
                                                  child: Switch(
                                                    value: snapshot.data?[index].enabled.toLowerCase()  == true.toString().toLowerCase(),
                                                    onChanged: (value) {
                                                      print(value);
                                                      var objectId = snapshot.data![index].objectId;
                                                      updateStatus(value.toString(), objectId);
                                                    },
                                                    activeTrackColor: Colors.white,
                                                    activeColor: Colors.yellow,
                                                    inactiveTrackColor: Colors.white,
                                                    inactiveThumbColor: Colors.grey,
                                                  )),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                              ),
                                              child: Text(
                                                snapshot.data?[index].url ?? "null",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            )

                          ],
                        ),
                        Center(
                          child: FutureBuilder<List<Article>>(
                            future: fetchArticles(),
                            builder: (context, snapshot) {
                              return snapshot.connectionState == ConnectionState.waiting
                                  ? const CircularProgressIndicator()
                                  : Column(
                                children: List.generate(snapshot.data!.length,
                                      (index) {
                                    return Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(
                                            10,
                                          ),
                                          child: CircleAvatar(
                                            backgroundColor:
                                            Colors.brown.shade800,
                                            child: Text(snapshot.data?[index].author ?? "null") ,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children:  [
                                              Text(
                                                snapshot.data?[index].title ?? "null",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                              SizedBox(
                                                width: 250,
                                                child: Text(
                                                  snapshot.data?[index].content ?? "null",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        )
                      ]),
                    )
                  ]),
            ),
          ]),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_statemanagement_startter/models/use_res_model.dart';
import 'package:demo_statemanagement_startter/services/http_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController controller = ScrollController();
  bool isLoading = false;
  List<RandomUser> list = [];
  int currentPage = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadRandomUserList();

    controller.addListener(() {
      if (controller.position.maxScrollExtent <= controller.offset) {

        loadRandomUserList();
      }
    });
  }

  loadRandomUserList() async {
    setState(() {
      isLoading = true;
    });
    var response = await Network.GET(Network.API_RANDOM_USER_LIST,
        Network.paramsRandomUserList(currentPage));


    var data = Network.parseRandomUserList(response!);
    currentPage = data.info.page + 1;
    setState(() {
      list.addAll(data.results);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("State management starter set state"),
      ),
      body: Stack(
        children: [
          ListView.builder(
            controller: controller,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return _itemOfUser(list[index], index);
            },
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SizedBox.shrink()
        ],
      ),
    );
  }

  Widget _itemOfUser(RandomUser randomUser, index) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          CachedNetworkImage(
            height: 80,
            width: 80,
            fit: BoxFit.cover,
            imageUrl: randomUser.picture.medium,
            placeholder: (context, url) => Container(
              height: 80,
              width: 80,
              color: Colors.grey,
            ),
            errorWidget: (context, url, error) => Container(
              height: 80,
              width: 80,
              color: Colors.grey,
              child: const Icon(Icons.error),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${index} - ${randomUser.name.first} ${randomUser.name.last}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                randomUser.email,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 16),
              ),
              Text(
                randomUser.cell,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 16),
              ),
            ],
          ))
        ],
      ),
    );
  }
}

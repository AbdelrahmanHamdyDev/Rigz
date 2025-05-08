import 'package:flutter/material.dart';
import 'package:rigz/Model/productModel.dart';
import 'package:rigz/View/Products_Screen.dart';
import 'package:rigz/ViewModel/home_ViewModel.dart';

class searchScreen extends StatefulWidget {
  @override
  State<searchScreen> createState() => _SearchpageState();
}

class _SearchpageState extends State<searchScreen> {
  final TextEditingController _controller = TextEditingController();
  String enteredText = "";
  final ScrollController _scrollController = ScrollController();
  bool _showScrollButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 0 && !_showScrollButton) {
        setState(() {
          _showScrollButton = true;
        });
      } else if (_scrollController.offset == 0 && _showScrollButton) {
        setState(() {
          _showScrollButton = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _scrollController.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.decelerate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          (_showScrollButton)
              ? FloatingActionButton(
                onPressed: _scrollToTop,
                child: const Icon(Icons.arrow_upward_outlined),
              )
              : null,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverAppBar(
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: const EdgeInsets.only(
                  left: 50,
                  right: 20,
                  bottom: 10,
                ),
                title: SearchBar(
                  controller: _controller,
                  hintText: " Search...",
                  leading: const Icon(Icons.search),
                  onSubmitted: (userText) {
                    setState(() {
                      enteredText = userText;
                    });
                  },
                  trailing: [
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        setState(() {
                          enteredText = "";
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            if (enteredText.isNotEmpty)
              SliverToBoxAdapter(
                child: FutureBuilder(
                  future: HomeViewmodel().search_ForProduct(enteredText),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error while Feathing the Data"),
                      );
                    }
                    if (snapshot.data!.isEmpty || snapshot.data == null) {
                      return const Center(child: Text("No Data Avaliable"));
                    }
                    List<productModel> snapData = snapshot.data!;
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Products_Screen(
                        title: "SearchResult",
                        products: snapData,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

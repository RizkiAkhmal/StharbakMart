import 'package:flutter/material.dart';
import 'package:stharbak_mart/widgets/AllFood.dart';
import 'package:stharbak_mart/widgets/AppBarWidget.dart';
import 'package:stharbak_mart/widgets/CatagoriesWidget.dart';
import 'package:stharbak_mart/widgets/PopularItemsWidget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<List<dynamic>> fetchData() async {
    final response = await supabase.from('Foodaas').select('*');
    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    //ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AppBar
          Appbarwidget(),

          Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 16,
            ),
            child: Text(
              "Categories",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Kategori
          CategoriesWidget(),

          // All Food Section
          Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 16,
            ),
            child: Text(
              "All food",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          //Supabase
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: fetchData(),
              builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data found'));
                } else {
                  final List<dynamic> data = snapshot.data!;

                  // Responsif menggunakan GridView
                  return GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenWidth < 600 ? 2 : 4, // 2 kolom untuk layar kecil, 4 untuk besar
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.80, // Rasio lebar dan tinggi item
                    ),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Image.asset('assets/burger.jpeg', height: 130),
                              ),
                              SizedBox(height: 8),
                              Text(
                                item['name'] ?? 'No name',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Rp. ${item['price'] ?? '0'}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.add_circle_outline,
                                    color: Color.fromARGB(217, 227, 111, 10),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

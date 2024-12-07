import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stharbak_mart/widgets/AppBarWidgets2.dart';
import 'package:stharbak_mart/widgets/TambahDataWidgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class Addpage extends StatefulWidget {
  const Addpage({super.key});

  @override
  State<Addpage> createState() => _AddpageState();
}

class _AddpageState extends State<Addpage> {
  Future<List<dynamic>> fetchData() async {
    final List<Map<String, dynamic>> response =
        await supabase.from('Foodaas').select('*');
    return response as List<dynamic>;
  }

  Future<void> deleteData(int id) async {
    await supabase.from('Foodaas').delete().eq('id', id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: ListView(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Appbarwidgets2(),

                  // Tombol Tambah Data
                  Row(
                    children: [
                      ElevatedButton(
                        child: Row(
                          children: [
                            Text(
                              'ADD',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.01),
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: screenWidth * 0.05,
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Tambahdatawidgets()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                            vertical: screenHeight * 0.01,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Photo",
                            style: TextStyle(fontSize: screenWidth * 0.04),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "Nama Produk",
                            style: TextStyle(fontSize: screenWidth * 0.04),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Harga",
                            style: TextStyle(fontSize: screenWidth * 0.04),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Aksi",
                            style: TextStyle(fontSize: screenWidth * 0.04),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),

                  // Kotak Produk
                  FutureBuilder<List<dynamic>>(
                    future: fetchData(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No data found');
                      } else {
                        final List<dynamic> data = snapshot.data!;
                        return Column(
                          children: data.map((item) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.01),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.all(screenWidth * 0.02),
                                      child: Image.asset(
                                        'assets/burger.jpeg',
                                      )
                                      
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      item['name'] ?? 'Tidak ada nama',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Rp. ${item['price'] ?? '0'}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      icon: Icon(
                                        CupertinoIcons.trash,
                                        size: screenWidth * 0.06,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        final id = item['id'];
                                        await deleteData(id);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
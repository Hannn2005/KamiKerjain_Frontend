import 'package:flutter/material.dart';
import 'package:kami_kerjain/widgets/bottom_navbar.dart';
import 'package:kami_kerjain/widgets/ai_floating_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<Map<String, dynamic>> dummy = [
    {
      "jasa": "Jasa Kerjain Tugas",
      "harga": "Rp 35.000",
      "seller": "Username1",
      "location": "Medan",
    },
    {
      "jasa": "Jasa Desain Logo",
      "harga": "Rp 50.000",
      "seller": "Username2",
      "location": "Binjai",
    },
    {
      "jasa": "Jasa Edit Video",
      "harga": "Rp 75.000",
      "seller": "Username3",
      "location": "Deli Serdang",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      // =========================
      // APP BAR
      // =========================
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF00246B),
        elevation: 0,
        title: Row(
          children: [
            // SEARCH BAR
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const TextField(
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: 'Cari Jasa',
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFF00246B),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 15),

            // CHAT CUSTOMER
            const Icon(
              Icons.chat_bubble,
              color: Colors.white,
              size: 28,
            ),
          ],
        ),
      ),

      // =========================
      // BODY
      // =========================
      body: Stack(
        children: [
          GridView.builder(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(10),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 260,
            ),
            itemCount: dummy.length,
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 10,
                      offset: const Offset(10, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IMAGE PLACEHOLDER
                    Container(
                      height: 165,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                    ),

                    // SERVICE INFORMATION
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            dummy[index]["jasa"],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          Text(
                            dummy[index]["harga"],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dummy[index]["seller"],
                                style: TextStyle(
                                  color: Colors.grey.withAlpha(150),
                                ),
                              ),

                              Text(
                                dummy[index]["location"],
                                style: TextStyle(
                                  color: Colors.grey.withAlpha(150),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // =========================
          // FLOATING KAMI AI
          // =========================
          const AiFloatingButton(),
        ],
      ),

      // =========================
      // BOTTOM NAVIGATION
      // =========================
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
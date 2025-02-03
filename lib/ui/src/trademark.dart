import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'company_info.dart';

class Trademark extends StatelessWidget {
  const Trademark({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> apps = [
      {
        "Srisoftwarez": {
          "image": "https://i.postimg.cc/Xqj548GW/trademark.png",
          "description": "Innovative software solutions."
        },
      },
      {
        "Connectstaff": {
          "image": "https://i.postimg.cc/SxDxbdSk/connectstaff.png",
          "description": "Seamless payroll management."
        },
      },
      {
        "Billing": {
          "image": "https://i.postimg.cc/tgWvVSsH/billing.png",
          "description": "Smart and efficient invoicing system.",
        },
      },
      {
        "Daybook": {
          "image": "https://i.postimg.cc/ZRLfwWP7/daybook.png",
          "description": "Track daily expenses with ease.",
        },
      },
      {
        "Dolphin": {
          "image": "https://i.postimg.cc/02jtC2zn/dolphin.png",
          "description": "Video streaming application.",
        },
      },
      {
        "Foodie": {
          "image": "https://i.postimg.cc/sDMch6L0/foodie.png",
          "description": "Manage food orders effortlessly.",
        },
      },
      {
        "Scansphere": {
          "image": "https://i.postimg.cc/136rWgsG/scansphere.png",
          "description": "Advanced barcode and QR scanning solution.",
        },
      },
      {
        "Temple": {
          "image": "https://i.postimg.cc/26jd82vG/temple.png",
          "description": "Manage temple activities and donations efficiently.",
        },
      },
      {
        "Shop Maintenance": {
          "image": "https://i.postimg.cc/prpDKrsn/shopmaintenance.png",
          "description": "Simplified store upkeep and inventory tracking.",
        },
      },
      {
        "Srikot": {
          "image": "https://i.postimg.cc/J723M3h3/srikot.png",
          "description": "Streamlined accounting and financial management."
        }
      }
    ];

    return Tooltip(
      message: "View in detail",
      child: GestureDetector(
        onTap: () async {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return const CompanyInfo();
          }));
        },
        child: CarouselSlider(
          items: [
            for (var i in apps)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                height: 120,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Image.network(
                      i.values.first['image'],
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            i.values.first['description'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.grey),
                          ),
                          Text(
                            i.keys.first,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
          ],
          options: CarouselOptions(
            height: 120,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            scrollDirection: Axis.horizontal,
          ),
        ),
      ),
    );
  }
}

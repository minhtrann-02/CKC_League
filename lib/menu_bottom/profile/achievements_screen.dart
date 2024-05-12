import 'package:flutter/material.dart';

class Achievements_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Achievements_screen_state();
}

class Achievements_screen_state extends State<Achievements_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(150),
          child: AppBar(
            elevation :0,
            flexibleSpace: Stack(
              children: [
                Container(
                  height: 190,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/ckcbanner3.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 50,
                  right: 50,
                  child: Center(
                    child:
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(children: [
                            Text(
                          'THÀNH TÍCH CÁ NHÂN',
                          style: TextStyle(
                            fontFamily: 'Bitter',
                            color: Color(0xFA011129),
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                          ]),
                        )
                      
                      
                    
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          // scrollDirection: Axis.horizontal,
          child: Container(
            margin: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('GIẢI ĐẤU',
                          style: TextStyle(
                            fontFamily: 'Bitter',
                            fontSize: 20,
                            color: Colors.black,
                          ))
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset('images/tshirt.png',
                                      width: 50, height: 50),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('0',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Text('Giải tham dự ',style: TextStyle(fontFamily: 'BodoniModa'))
                                      ],
                                    ),
                                  )
                                ]),
                          ),
                          Container(
                            child: Row(children: [
                              Image.asset('images/silver-cup.png',
                                  width: 50, height: 50),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('0',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    Text('Giải nhì ',style: TextStyle(fontFamily: 'BodoniModa'))
                                  ],
                                ),
                              )
                            ]),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Row(children: [
                              Image.asset('images/cup4.png',
                                  width: 50, height: 50),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('0',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    Text('Giải tư ',style: TextStyle(fontFamily: 'BodoniModa'))
                                  ],
                                ),
                              )
                            ]),
                          ),
                        ],
                      ),
                      Column(
                        
                       mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10,),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween, 
                                children: [
                                  Image.asset('images/gold-cup.png',
                                      width: 50, height: 50),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('0',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Text('Vô địch ',style: TextStyle(fontFamily: 'BodoniModa'))
                                      ],
                                    ),
                                  )
                                ]),
                          ),
                          Container(
                             margin: EdgeInsets.only(bottom: 15),
                            child: Row(children: [
                              Image.asset('images/bronze-cup.png',
                                  width: 50, height: 50),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('0',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    Text('Giải ba ',style: TextStyle(fontFamily: 'BodoniModa'),)
                                  ],
                                ),
                              )
                            ]),
                          ),
                          Container(
                            color: Colors.blue,
                            child: SizedBox(
                              height: 50,
                            ),
                          )
                          
                        ],
                      )
                    ],
                  ),
                ),
                 Container(
                  child: Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('TRẬN ĐẤU',
                          style: TextStyle(
                            fontFamily: 'Bitter',
                            fontSize: 20,
                            color: Colors.black,
                          ))
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset('images/flag_grey.png',
                                      width: 50, height: 50),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('0',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Text('Trận tham gia ',style: TextStyle(fontFamily: 'BodoniModa'))
                                      ],
                                    ),
                                  )
                                ]),
                          ),
                          Container(
                            child: Row(children: [
                              Image.asset('images/flag_yellow.png',
                                  width: 50, height: 50),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('0',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    Text('Trận hoà ',style: TextStyle(fontFamily: 'BodoniModa'))
                                  ],
                                ),
                              )
                            ]),
                          ),
                         
                        ],
                      ),
                      Column(
                        
                       mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10,left: 20),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween, 
                                children: [
                                  Image.asset('images/flag_green.png',
                                      width: 50, height: 50),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('0',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Text('Trận thắng ',style: TextStyle(fontFamily: 'BodoniModa'))
                                      ],
                                    ),
                                  )
                                ]),
                          ),
                          Container(
                             margin: EdgeInsets.only(bottom: 15,left:10),
                            child: Row(children: [
                              Image.asset('images/flag_red.png',
                                  width: 50, height: 50),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('0',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    Text('Trận thua ',style: TextStyle(fontFamily: 'BodoniModa'),)
                                  ],
                                ),
                              )
                            ]),
                          ),
                       
                          
                        ],
                      )
                    ],
                  ),
                ),
                  Container(
                  child: Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('GHI BÀN',
                          style: TextStyle(
                            fontFamily: 'Bitter',
                            fontSize: 20,
                            color: Colors.black,
                          ))
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset('images/theball.png',
                                      width: 50, height: 50),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('0',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Text('Bàn thắng ',style: TextStyle(fontFamily: 'BodoniModa'))
                                      ],
                                    ),
                                  )
                                ]),
                          ),
                          Container(
                            child: Row(children: [
                              Image.asset('images/theball_2.png',
                                  width: 50, height: 50),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('0',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    Text('Cú đúp ',style: TextStyle(fontFamily: 'BodoniModa'))
                                  ],
                                ),
                              )
                            ]),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Row(children: [
                              Image.asset('images/theball_4.png',
                                  width: 50, height: 50),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('0',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    Text('Poker ',style: TextStyle(fontFamily: 'BodoniModa'))
                                  ],
                                ),
                              )
                            ]),
                          ),
                        ],
                      ),
                      Column(
                        
                       mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10,left: 50),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween, 
                                children: [
                                  Image.asset('images/the red ball.png',
                                      width: 50, height: 50),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('0',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Text('Phản lưới nhà ',style: TextStyle(fontFamily: 'BodoniModa'))
                                      ],
                                    ),
                                  )
                                ]),
                          ),
                          Container(
                             margin: EdgeInsets.only(bottom: 15,left:10),
                            child: Row(children: [
                              Image.asset('images/theball_3.png',
                                  width: 50, height: 50),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('0',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    Text('Hattrick',style: TextStyle(fontFamily: 'BodoniModa'),)
                                  ],
                                ),
                              )
                            ]),
                          ),
                          Container(
                            color: Colors.blue,
                            child: SizedBox(
                              height: 50,
                            ),
                          )
                          
                        ],
                      )
                    ],
                  ),
                ),
                 Container(
                  child: Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('THẺ PHẠT',
                          style: TextStyle(
                            fontFamily: 'Bitter',
                            fontSize: 20,
                            color: Colors.black,
                          ))
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset('images/yellow_card.png',
                                      width: 50, height: 50),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('0',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Text('Thẻ vàng ',style: TextStyle(fontFamily: 'BodoniModa'))
                                      ],
                                    ),
                                  )
                                ]),
                          ),
                          Container(
                            child: Row(children: [
                              Image.asset('images/thecard.png',
                                  width: 50, height: 50),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('0',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    Text('Thẻ đỏ gián tiếp ',style: TextStyle(fontFamily: 'BodoniModa'))
                                  ],
                                ),
                              )
                            ]),
                          ),
                         
                        ],
                      ),
                      Column(
                        
                       mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10,left: 20),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween, 
                                children: [
                                  Image.asset('images/red_card.png',
                                      width: 50, height: 50),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('0',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        Text('Thẻ đỏ',style: TextStyle(fontFamily: 'BodoniModa'))
                                      ],
                                    ),
                                  )
                                ]),
                          ),
                      
                          Container(
                            color: Colors.blue,
                            child: SizedBox(
                              height: 50,
                            ),
                          )
                          
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            )
          ),
        ));
  }
}

import 'package:ckc_league/menu_bottom/my_team/DoiBong/add_team.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Choice_Image extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Choice_Image_State();
}

class Choice_Image_State extends State<Choice_Image> {
  List<bool> isSelected = List.generate(8, (index) => false);
  String selectedImageName = '';
  late SharedPreferences prefs;

  @override
void initState() {
  super.initState();
  initializeSharedPreferences();
}

Future<void> initializeSharedPreferences() async {
  prefs = await SharedPreferences.getInstance();
}

void saveSelectedImageName(String imageName) {
  if (selectedImageName != imageName) {
    setState(() {
      selectedImageName = imageName;
    });
    print('Tên hình ảnh được lưu: $imageName');
    prefs.setString('selectedImageName', imageName);
  }
}

//  void saveSelectedImageName(String imageName) {
//   if (selectedImageName != imageName) {
//     setState(() {
//       selectedImageName = imageName;
//     });
//     prefs.setString('selectedImageName', imageName);
//   }
// }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Chọn logo đội', style: TextStyle(color: Colors.black)),
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.navigate_before_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Chọn ảnh có sẵn',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  children: [
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 4, // Số cột trong mỗi hàng
                      children: [
                        // Hàng 1
                        buildSelectableImage(0, 'images/logo1.png'),
                        buildSelectableImage(1, 'images/logo2.png'),
                        buildSelectableImage(2, 'images/logo3.png'),
                        buildSelectableImage(3, 'images/logo4.png'),

                        // Hàng 2
                        buildSelectableImage(4, 'images/logo5.png'),
                        buildSelectableImage(5, 'images/logo6.png'),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height:30,
              ),
             FractionallySizedBox(
              widthFactor: 0.99,
              child: SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: (){
                     print(selectedImageName);
                      saveSelectedImageName(selectedImageName); 
                       Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Add_Team()),
    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  child: const Text(
                    'CHỌN',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
            ],
          ),
        ));
  }

  Widget buildSelectableImage(int index, String imagePath) {
  return InkWell(
    onTap: () {
      setState(() {
        for (int i = 0; i < isSelected.length; i++) {
          if (i == index) {
            isSelected[i] = true;
          } else {
            isSelected[i] = false;
          }
        }
      });
      saveSelectedImageName(imagePath); // Gọi saveSelectedImageName sau khi đã cập nhật selectedImageName trong setState
    },
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(imagePath),
        ),
        if (isSelected[index])
          Positioned(
            top: 8,
            left: 8,
            child: Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
          ),
      ],
    ),
  );
}
}

import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchtState();
}

class _SearchtState extends State<Search> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: TextField(
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm giải đấu',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
          ),
          style: const TextStyle(color: Colors.black),
          onChanged: (value) {
            // Thực hiện hành động khi giá trị tìm kiếm thay đổi
          },
          onSubmitted: (value) {
            // Thực hiện hành động khi người dùng nhấn phím Enter trên bàn phím
          },
        ),
      ),
    );
  }
}

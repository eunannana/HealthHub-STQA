/// Widget Flutter `AddCalories` ini bertanggung jawab untuk memungkinkan pengguna
/// untuk menambahkan informasi tentang kalori, termasuk jenis makanan dan jumlah kalori.
/// Widget ini menggunakan paket `dropdown_search` untuk menyediakan dropdown dengan kemampuan pencarian.
///
/// Pada widget ini, pengguna dapat memilih jenis makanan dari dropdown yang telah disediakan.
/// Ketika memilih jenis makanan, widget ini secara otomatis memasukkan nilai kalori yang sesuai
/// ke dalam input kalori. Jika pengguna ingin memasukkan jenis makanan yang tidak terdaftar,
/// mereka dapat memilih opsi "Lainnya" dari dropdown dan memasukkan nilai kalori secara manual.
///
/// Setelah pengguna mengisi informasi yang diperlukan, mereka dapat mengklik tombol "Tambah" untuk
/// mengirimkan data jenis makanan dan jumlah kalori yang telah dipilih kembali ke halaman sebelumnya
/// menggunakan metode `Navigator.pop`.
///
/// Untuk menggunakan widget ini, cukup masukkan widget ini ke dalam pohon widget Flutter
/// aplikasi Anda.

import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:healthhub/model/food_model.dart';

class AddCalories extends StatefulWidget {
  const AddCalories({Key? key}) : super(key: key);

  @override
  State<AddCalories> createState() => _AddCaloriesState();
}

class _AddCaloriesState extends State<AddCalories> {
  final TextEditingController _caloriesController = TextEditingController();
  String? _selectedFood;
  double _calories = 0.0;
  List<Food> _foods = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kalori'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownSearch<String>(
              mode: Mode.MENU, showClearButton: true,
              clearButton: const Icon(Icons.clear, size: Checkbox.width),
              showSelectedItems: true,
              items: _foods.map((food) => food.food).toList(),
              onChanged: _calculateCalories,
              selectedItem: _selectedFood,
              compareFn: (item, selectedItem) => item == selectedItem,
              showSearchBox: true, // Menampilkan kotak pencarian
              dropdownSearchDecoration: const InputDecoration(
                labelText: "Makanan/Minuman",
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _caloriesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Kalori',
                    ),
                    enabled: _selectedFood == 'Lainnya',
                  ),
                ),
                const SizedBox(width: 8.0),
                const Text(
                  'kal',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String? makanan = _selectedFood;
                String kalori = _caloriesController.text;

                // Validasi
                if (makanan != null && makanan.isNotEmpty && kalori.isNotEmpty) {
                  // Kirim data jenis makanan dan kalori yang dipilih kembali ke halaman sebelumnya
                  Navigator.pop(context, '$makanan - $kalori');
                }
              },
              child: const Text('Tambah'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _caloriesController.dispose();
    _foods.clear();
    super.dispose();
  }

  /// Mengambil data makanan dari file JSON dan menginisialisasi daftar `_foods`.
  Future<void> fetchData() async {
    // Memuat data JSON dari aset
    String jsonData = await DefaultAssetBundle.of(context)
        .loadString('assets/foods_n_calories.json');
    List<dynamic> data = jsonDecode(jsonData);

    // Mengurai data JSON menjadi objek FoodItem
    List<Food> foods = data.map((item) => Food.fromJson(item)).toList();

    setState(() {
      _foods = foods;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  /// Menghitung dan memperbarui nilai kalori berdasarkan item makanan yang dipilih.
  void _calculateCalories(String? makanan) {
    setState(() {
      _selectedFood = makanan;

      if (_selectedFood != null) {
        // Temukan makanan yang dipilih dalam daftar dan dapatkan kalorinya
        Food selectedFoodItem =
            _foods.firstWhere((item) => item.food == _selectedFood);
        _calories = selectedFoodItem.calories;
      } else {
        _calories = 0.0;
      }

      _caloriesController.text = _calories.toString();
    });
  }
}

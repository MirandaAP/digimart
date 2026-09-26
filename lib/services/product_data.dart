import '../models/product_model.dart';

class ProductData {
  static final List<ProductModel> products = [
    ProductModel(
      id: 'P001',
      name: 'Instagram Template',
      description:
          'Template Instagram aesthetic dengan desain modern yang cocok untuk konten personal maupun bisnis.',
      price: 15000,
      image: 'assets/images/instagram_template.png',
      category: 'Social Media',
    ),

    ProductModel(
      id: 'P002',
      name: 'CV & Resume Template',
      description:
          'Template CV profesional dengan tampilan clean dan modern untuk membantu membuat CV lebih menarik.',
      price: 20000,
      image: 'assets/images/cv_template.png',
      category: 'CV & Resume',
    ),

    ProductModel(
      id: 'P003',
      name: 'Digital Planner',
      description:
          'Digital planner aesthetic untuk membantu mengatur jadwal, tugas, target, dan aktivitas sehari-hari.',
      price: 18000,
      image: 'assets/images/digital_planner.png',
      category: 'Planner',
    ),

    ProductModel(
      id: 'P004',
      name: 'Presentation Template',
      description:
          'Template presentasi minimalis dan profesional yang cocok untuk kebutuhan kuliah maupun pekerjaan.',
      price: 25000,
      image: 'assets/images/presentation_template.png',
      category: 'Presentation',
    ),

    ProductModel(
      id: 'P005',
      name: 'Business Template',
      description:
          'Kumpulan template untuk kebutuhan bisnis seperti promosi, katalog, dan konten pemasaran.',
      price: 22000,
      image: 'assets/images/business_template.png',
      category: 'Business',
    ),

    ProductModel(
      id: 'P006',
      name: 'Study Planner',
      description:
          'Template planner untuk mahasiswa yang membantu mengatur jadwal kuliah, tugas, dan target belajar.',
      price: 12000,
      image: 'assets/images/study_planner.png',
      category: 'Study',
    ),
  ];
}
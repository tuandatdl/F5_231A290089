import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F5_231A290089',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0468D7)),
      ),
      home: const HomePage(),
    );
  }
}

// ============================================================================
// 1. MODEL – TÁCH DỮ LIỆU RA KHỎI GIAO DIỆN
// ============================================================================
class SanPham {
  final String id;
  final String ten;
  final String moTa;
  final int gia; // Lưu bằng int (đồng) để tránh sai số làm tròn của double
  final String anh; // Đường dẫn asset

  const SanPham({
    required this.id,
    required this.ten,
    required this.moTa,
    required this.gia,
    required this.anh,
  });
}

// Dữ liệu mẫu 6 sản phẩm VHU
final List<SanPham> duLieuMau = [
  const SanPham(
    id: 'sp1',
    ten: 'Áo thun VHU',
    moTa: 'Cotton 100%, in logo trường',
    gia: 180000,
    anh: 'assets/images/p1.jpg',
  ),
  const SanPham(
    id: 'sp2',
    ten: 'Bình giữ nhiệt',
    moTa: 'Inox 500ml, giữ nóng 6 giờ',
    gia: 250000,
    anh: 'assets/images/p2.jpg',
  ),
  const SanPham(
    id: 'sp3',
    ten: 'Sổ tay sinh viên',
    moTa: '200 trang, bìa cứng',
    gia: 75000,
    anh: 'assets/images/p3.jpg',
  ),
  const SanPham(
    id: 'sp4',
    ten: 'Balo laptop',
    moTa: 'Chống nước, ngăn 15.6 inch',
    gia: 420000,
    anh: 'assets/images/p4.jpg',
  ),
  const SanPham(
    id: 'sp5',
    ten: 'Móc khóa gỗ',
    moTa: 'Khắc laser tên trường',
    gia: 35000,
    anh: 'assets/images/p5.jpg',
  ),
  const SanPham(
    id: 'sp6',
    ten: 'Cốc sứ in hình',
    moTa: 'Dung tích 350ml',
    gia: 95000,
    anh: 'assets/images/p6.jpg',
  ),
];

/// Định dạng 180000 -> "180.000 đ" (không cần thư viện ngoài)
String dinhDangGia(int gia) {
  final s = gia.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) {
      buf.write('.');
    }
    buf.write(s[i]);
  }
  return '${buf.toString()} đ';
}

// ============================================================================
// 2. KHUNG CHÍNH – 2 TAB (DANH SÁCH & LƯỚI)
// ============================================================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_tab == 0 ? 'Danh sách sản phẩm' : 'Album ảnh (Lưới)'),
            const Text(
              'Đỗ Lê Tuấn Đạt – MSSV: 231A290089',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: _tab == 0 ? const ProductListTab() : const AlbumTab(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Danh sách'),
          NavigationDestination(icon: Icon(Icons.grid_view), label: 'Lưới'),
        ],
      ),
    );
  }
}

// ============================================================================
// 3. TAB 1 – LISTVIEW.BUILDER + CARD + DISMISSIBLE
// ============================================================================
class ProductListTab extends StatefulWidget {
  const ProductListTab({super.key});

  @override
  State<ProductListTab> createState() => _ProductListTabState();
}

class _ProductListTabState extends State<ProductListTab> {
  // Tạo bản sao để có thể thêm/xóa mà không làm hỏng dữ liệu gốc
  final List<SanPham> _ds = List.of(duLieuMau);
  int _dem = 0;

  void _them() {
    setState(() {
      _dem++;
      _ds.insert(
        0,
        SanPham(
          id: 'moi_$_dem',
          ten: 'Sản phẩm mới #$_dem',
          moTa: 'Vừa thêm lúc ${TimeOfDay.now().format(context)}',
          gia: 50000 * _dem,
          anh: 'assets/images/p1.jpg',
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_ds.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Danh sách trống', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _them,
              icon: const Icon(Icons.add),
              label: const Text('Thêm sản phẩm'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _ds.length,
        itemBuilder: (context, index) {
          final sp = _ds[index];
          debugPrint('itemBuilder đang dựng dòng vị trí: $index - ${sp.ten}');

          return Dismissible(
            // Key PHẢI duy nhất và ổn định theo dữ liệu gốc (id)
            key: ValueKey(sp.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) {
              final daXoa = sp;
              final viTriCu = index;
              setState(() => _ds.removeAt(index));

              // Tích hợp Bài nâng cao NC3: SnackBar kèm nút "Hoàn tác"
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã xóa ${daXoa.ten}'),
                  action: SnackBarAction(
                    label: 'Hoàn tác',
                    onPressed: () {
                      setState(() {
                        final chenVao =
                            viTriCu <= _ds.length ? viTriCu : _ds.length;
                        _ds.insert(chenVao, daXoa);
                      });
                    },
                  ),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: AnhSanPham(duongDan: sp.anh, kichThuoc: 56),
                title: Text(
                  sp.ten,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  sp.moTa,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  dinhDangGia(sp.gia),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Bạn chọn: ${sp.ten}')),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _them,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ============================================================================
// 4. TAB 2 – GRIDVIEW.BUILDER (TÍCH HỢP NC4: ĐỔI CHẾ ĐỘ CO GIÃN CỘT)
// ============================================================================
class AlbumTab extends StatefulWidget {
  const AlbumTab({super.key});

  @override
  State<AlbumTab> createState() => _AlbumTabState();
}

class _AlbumTabState extends State<AlbumTab> {
  // false = Cố định 2 cột (Cơ bản), true = Tự co giãn số cột theo bề rộng (NC4)
  bool _coGian = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _coGian
                    ? 'Chế độ: Tự đổi số cột (NC4)'
                    : 'Chế độ: Cố định 2 cột',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Switch(
                value: _coGian,
                onChanged: (v) => setState(() => _coGian = v),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: _coGian
                ? const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 180,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.78,
                  )
                : const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.78,
                  ),
            itemCount: duLieuMau.length,
            itemBuilder: (context, index) {
              final sp = duLieuMau[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: AnhSanPham(duongDan: sp.anh)),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sp.ten,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            dinhDangGia(sp.gia),
                            style: const TextStyle(color: Colors.blueGrey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// 5. WIDGET ẢNH DÙNG CHUNG (CÓ ERROR BUILDER AN TOÀN)
// ============================================================================
class AnhSanPham extends StatelessWidget {
  final String duongDan;
  final double? kichThuoc;

  const AnhSanPham({super.key, required this.duongDan, this.kichThuoc});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      duongDan,
      width: kichThuoc,
      height: kichThuoc,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: kichThuoc,
        height: kichThuoc,
        color: Colors.grey.shade300,
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      ),
    );
  }
}

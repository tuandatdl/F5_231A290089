# INT4211 - LẬP TRÌNH TRÊN CÁC THIẾT BỊ DI ĐỘNG
## BÁO CÁO THỰC HÀNH LAB F5: DANH SÁCH & LƯỚI TRONG FLUTTER

---

### THÔNG TIN SINH VIÊN
* **Họ và tên:** Đỗ Lê Tuấn Đạt
* **Mã số sinh viên (MSSV):** 231A290089
* **Lớp học phần:** Lập trình thiết bị di động (INT4211)
* **Môi trường thực thi:** Flutter 3.x (Material 3) trên macOS (Apple Silicon)
* **Thiết bị thử nghiệm:** Máy ảo Pixel 8 (Android 17, API 37.1) & Google Chrome
* **Repository GitHub:** `https://github.com/tuandatdl/F5_231A290089` (Private, đã mời giảng viên làm Collaborator)

---

### CÁC MỤC ĐÃ HOÀN THÀNH

#### 1. Danh sách dựng lười với ListView.builder & Model độc lập (Phần 1, 2, 3)
* Thiết kế lớp `SanPham` tách biệt hoàn toàn dữ liệu khỏi giao diện, lưu giá bằng kiểu số nguyên `int` để ngăn ngừa sai số làm tròn của `double`, đồng thời định dạng tiền tệ qua hàm thuần Dart `dinhDangGia(int gia)` (ví dụ: `180000` -> `180.000 đ`) mà không cần nạp thư viện ngoài.
* Sử dụng `ListView.builder` triển khai cơ chế dựng lười (lazy loading): chỉ khởi tạo những dòng widget thực sự nằm trong khung nhìn viewport (hoặc cận viewport) thông qua `itemBuilder`.
* Thiết kế mỗi mục danh sách với `Card` + `ListTile`, bo hẹp văn bản bằng `maxLines: 1` và `overflow: TextOverflow.ellipsis` nhằm chống xô lệch bố cục khi chuỗi mô tả quá dài.
* Xử lý trạng thái rỗng ("Danh sách trống" kèm nút "Thêm sản phẩm") khi toàn bộ danh sách bị xóa hết.

#### 2. Thêm/Xóa với setState & Dismissible có Key duy nhất (Phần 3.3)
* Bọc mỗi mục trong widget `Dismissible` với hướng vuốt từ phải sang trái (`DismissDirection.endToStart`), nền đỏ (`color: Colors.red`) và biểu tượng thùng rác trắng (`Icons.delete`).
* Gán `key: ValueKey(sp.id)` duy nhất và bất biến theo `id` của sản phẩm (thay vì dùng chỉ số `index`), triệt tiêu triệt để hiện tượng xóa nhầm hoặc xung đột trạng thái Widget khi cuộn hoặc xóa mục bất kỳ ở giữa danh sách.
* Nút `FloatingActionButton (+)` chèn sản phẩm mới lên vị trí đầu danh sách (`_ds.insert(0, ...)`), cập nhật tức thì qua `setState`.

#### 3. Lưới ảnh GridView.builder & Quản lý Assets (Phần 2.1, 3.4)
* Khai báo thư mục tài nguyên `assets/images/` trong `pubspec.yaml`, chuẩn bị 6 ảnh mẫu (`p1.jpg` đến `p6.jpg`) với dung lượng tối ưu (< 50KB).
* Xây dựng widget dùng chung `AnhSanPham` bọc `Image.asset` với thuộc tính `fit: BoxFit.cover` và cơ chế phòng thủ `errorBuilder`: tự động hiển thị khung xám kèm icon `Icons.image_not_supported` nếu ảnh chưa tải được hoặc đường dẫn bị sai, không làm gián đoạn hay crash ứng dụng.
* Sử dụng `childAspectRatio: 0.78` kết hợp `Expanded` cho phần hiển thị ảnh trong `Card`, đảm bảo các ô lưới hiển thị vuông vắn, đều đặn và không xuất hiện dải sọc vàng đen cảnh báo tràn pixel (RenderFlex overflow).

#### 4. Bài nâng cao NC3 & NC4
* **NC3 (Hoàn tác sau khi xóa - Undo Dismissible):** 
  * Khi người dùng vuốt xóa một dòng, hệ thống lưu tạm tham chiếu đối tượng bị xóa (`daXoa`) cùng chỉ số ban đầu (`viTriCu`).
  * Gọi `ScaffoldMessenger.of(context).clearSnackBars()` và hiển thị `SnackBar` thông báo kèm hành động `SnackBarAction(label: 'Hoàn tác')`.
  * Khi bấm "Hoàn tác", hàm gọi `_ds.insert(chenVao, daXoa)` khôi phục sản phẩm về đúng vị trí trước khi xóa.
* **NC4 (Lưới co giãn tự động theo độ rộng màn hình):**
  * Tích hợp công tắc chuyển đổi (`Switch`) giữa hai chế độ dựng lưới:
    1. Lưới cố định 2 cột truyền thống: `SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, ...)`
    2. Lưới thích ứng kích thước: `SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 180, ...)`
  * Khi ở chế độ thích ứng, số cột tự động tính toán dựa theo chiều rộng khả dụng: màn hình điện thoại cầm dọc hiển thị 2 cột; khi xoay ngang hoặc chạy trên tablet/desktop, lưới tự động co giãn lên 4–6 cột mà các ô vẫn giữ tỉ lệ hiển thị cân đối.

---

### BẢNG ĐỐI CHIẾU KIẾN TRÚC: ANDROID NATIVE (LAB A9 / A10) ↔ FLUTTER (LAB F5)

| Tiêu chí kỹ thuật | Android Native (Lab A9: ListView & Lab A10: RecyclerView) | Flutter Framework (Lab F5) |
|---|---|---|
| **Cơ chế dựng lười (Lazy Loading)** | Dùng mẫu `ViewHolder` kết hợp tái sử dụng `convertView` (A9) hoặc cơ chế `RecycledViewPool` + `Scrap Views` (A10). | `ListView.builder` và `GridView.builder`: chỉ gọi hàm `itemBuilder` dựng Widget khi phần tử sắp cuộn vào viewport. |
| **Phân tách trách nhiệm** | Chia làm 3 lớp riêng: Adapter (`RecyclerView.Adapter`), ViewHolder (`RecyclerView.ViewHolder`) và LayoutManager (`GridLayoutManager`). | Gom gọn vào thuộc tính hàm tạo của Widget: `itemCount`, `itemBuilder`, `gridDelegate`. Không cần tạo các lớp Adapter trung gian. |
| **Thay đổi số cột lúc Runtime** | Phải can thiệp vào LayoutManager: `gridLayoutManager.setSpanCount(soCot)` kết hợp `notifyDataSetChanged()`. | Thay đổi cấu hình delegate trong hàm build thông qua `setState`: chuyển giữa `SliverGridDelegateWithFixedCrossAxisCount` và `SliverGridDelegateWithMaxCrossAxisExtent`. |
| **Thao tác Vuốt để Xóa (Swipe to Dismiss)** | Phải cài đặt `ItemTouchHelper` kết hợp ghi đè `SimpleCallback(0, ItemTouchHelper.LEFT)` gắn vào `RecyclerView`. | Bọc trực tiếp Widget dòng trong `Dismissible(key: ValueKey(id), direction: DismissDirection.endToStart, ...)`. |
| **Định danh duy nhất (Item Key)** | Sử dụng `getItemId(position)` trong Adapter hoặc công cụ `DiffUtil`. | Thuộc tính bắt buộc `key: ValueKey(sp.id)` của Widget `Dismissible`. |
| **Xử lý trạng thái rỗng (Empty State)** | Dùng `listView.setEmptyView(tvEmpty)` (A9) hoặc đăng ký `AdapterDataObserver` để ẩn/hiện View thông báo (A10). | Kiểm tra trực tiếp trạng thái dữ liệu trong hàm `build()`: `if (_ds.isEmpty) return EmptyWidget(...)`. |
| **Tính năng Hoàn tác (Undo Action)** | Dùng `Snackbar.make(...).setAction("Hoàn tác", v -> { list.add(pos, item); notifyItemInserted(pos); })`. | Dùng `ScaffoldMessenger.showSnackBar(SnackBar(action: SnackBarAction('Hoàn tác', ...)))` kết hợp `_ds.insert(pos, item)`. |
| **Quản lý & Phòng vệ ảnh** | Nạp ảnh qua Glide/Picasso, xử lý lỗi bằng `.placeholder()` và `.error(R.drawable.error)`. | Nạp qua `Image.asset`, tự động bắt lỗi và vẽ giao diện thay thế qua callback `errorBuilder`. |

---

### KẾT QUẢ NGHIỆM THU 2 CHECKPOINT & BẢNG 7 KỊCH BẢN KIỂM THỬ

#### Nghiệm thu 2 Checkpoint:
1. **Checkpoint 1 (Tab Danh sách & Tương tác):** 
   - Danh sách hiển thị đủ 6 sản phẩm mẫu với ảnh, tên, mô tả và giá định dạng có dấu chấm chuẩn (`180.000 đ`).
   - Bấm `+` (FAB) sản phẩm mới chèn ngay lên đầu.
   - Vuốt mục sang trái xuất hiện nền đỏ icon thùng rác, xóa thành công và cho phép bấm "Hoàn tác" để lấy lại mục về đúng chỉ số cũ.
2. **Checkpoint 2 (Tab Lưới Album & Co giãn NC4):** 
   - Tab Lưới hiển thị 2 cột đều đặn với tỉ lệ `childAspectRatio: 0.78`.
   - Bật chuyển đổi sang chế độ tự co giãn (NC4), xoay ngang màn hình số cột tự động nhảy từ 2 cột lên 4–5 cột không gây lỗi tràn khung.

#### Bảng kiểm thử 7 kịch bản chi tiết:

| STT | Kịch bản kiểm thử | Thao tác thực hiện | Kết quả kỳ vọng | Kết quả thực tế | Đánh giá |
|:---:|:---|:---|:---|:---|:---:|
| 1 | Khởi động ứng dụng | Mở app lần đầu | Tab Danh sách hiện đủ 6 sản phẩm VHU, giá tiền có dấu chấm phân cách | Hiển thị chính xác 6 sản phẩm, không giật lag | **ĐẠT** |
| 2 | Chứng minh dựng lười | Xem log khi cuộn danh sách | Log `itemBuilder đang dựng dòng...` chỉ kích hoạt cho các dòng hiển thị | Chỉ log các dòng nằm trong khung nhìn viewport | **ĐẠT** |
| 3 | Chèn sản phẩm mới | Bấm FloatingActionButton (+) | Sản phẩm mới chèn vào vị trí đầu tiên (`index = 0`) | Mục mới xuất hiện ngay đỉnh danh sách mượt mà | **ĐẠT** |
| 4 | Vuốt xóa & Hoàn tác | Vuốt mục sang trái, bấm "Hoàn tác" | Nền đỏ thùng rác hiện ra; xóa xong bấm Hoàn tác mục quay lại đúng vị trí cũ | Hoàn tác chính xác vị trí, SnackBar tự ẩn sau khi hoàn tất | **ĐẠT** |
| 5 | Trạng thái danh sách rỗng | Vuốt xóa toàn bộ sản phẩm | Màn hình hiển thị "Danh sách trống" kèm nút TextButton "Thêm sản phẩm" | Giao diện rỗng chuẩn Material 3, bấm thêm hoạt động tốt | **ĐẠT** |
| 6 | Hiển thị Album lưới | Chuyển sang Tab "Lưới" | Ảnh hiển thị dạng lưới 2 cột đều nhau, tỉ lệ cân đối | Không méo hình, không tràn dải vàng đen (overflow) | **ĐẠT** |
| 7 | Co giãn cột linh hoạt | Bật công tắc NC4 & xoay ngang máy | Lưới chuyển sang `maxCrossAxisExtent: 180`, tự tăng số cột khi xoay ngang | Lưới tự co giãn từ 2 lên 4–5 cột khi xoay ngang thiết bị | **ĐẠT** |

---

### TRẢ LỜI CÂU HỎI PHÂN TÍCH

* **Câu 1: Cơ chế dựng lười (lazy loading) của `ListView.builder` hoạt động ra sao và chứng minh bằng log như thế nào?**
  * *Trả lời:* Khác với `ListView(children: [...])` sẽ tạo toàn bộ Widget con cùng một lúc vào bộ nhớ, `ListView.builder` chỉ gọi hàm `itemBuilder` cho những phần tử đang xuất hiện trên màn hình cộng thêm một khoảng đệm nhỏ (`cacheExtent`). Dòng log `debugPrint('itemBuilder đang dựng dòng vị trí: $index - ${sp.ten}')` trong mã nguồn chứng minh khi vừa mở màn hình, Flutter chỉ dựng các dòng từ vị trí 0 đến 5. Khi người dùng cuộn xuống dưới, các hàm builder tiếp theo mới được kích hoạt, giúp tối ưu tối đa dung lượng RAM và giữ vững tốc độ khung hình 60–120 FPS.

* **Câu 2: Vì sao thuộc tính `key` trong `Dismissible` bắt buộc phải dùng `ValueKey(sp.id)` thay vì `ValueKey(index)`?**
  * *Trả lời:* Trong Flutter, danh sách Widget sử dụng Key để ánh xạ giữa Widget Tree và Element Tree. Nếu sử dụng `ValueKey(index)`, khi xóa một phần tử ở giữa danh sách (ví dụ vị trí số 2), phần tử số 3 sẽ bị đẩy lên vị trí số 2 và kế thừa nguyên vẹn `ValueKey(2)`. Flutter sẽ nhầm lẫn trạng thái giao diện của phần tử mới với phần tử cũ vừa bị xóa, dẫn đến lỗi xóa sai dòng hoặc xuất hiện lỗi "A Dismissible widget is still part of the tree". Dùng `ValueKey(sp.id)` định danh duy nhất theo bản ghi dữ liệu gốc đảm bảo tính toàn vẹn trạng thái tuyệt đối.

* **Câu 3: So sánh ưu - nhược điểm giữa `SliverGridDelegateWithFixedCrossAxisCount` và `SliverGridDelegateWithMaxCrossAxisExtent`?**
  * *Trả lời:*
    * `SliverGridDelegateWithFixedCrossAxisCount`: Cố định cứng số cột (`crossAxisCount`). Thích hợp khi thiết kế giao diện đòi hỏi số cột bất biến trên mọi màn hình điện thoại (ví dụ: luôn luôn 2 cột). Nhược điểm là khi chạy trên máy tính bảng hoặc xoay ngang điện thoại, các ô sẽ bị kéo dãn quá to làm mất cân đối thẩm mỹ.
    * `SliverGridDelegateWithMaxCrossAxisExtent`: Định nghĩa độ rộng tối đa cho mỗi ô (`maxCrossAxisExtent`). Hệ thống sẽ tự động lấy bề rộng màn hình chia cho độ rộng này để tính toán ra số lượng cột tối ưu nhất lúc runtime. Phương pháp này mang lại thiết kế Responsive tự nhiên, tự động chuyển từ 2 cột (màn hình hẹp) lên 4–6 cột (màn hình rộng/xoay ngang) mà không cần viết các câu lệnh `if/else` kiểm tra kích thước màn hình phức tạp.

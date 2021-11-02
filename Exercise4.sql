-- Danh sách vật tư bán ra lọc điều kiện
select ChiTietHoaDon.MaVT, VatTu.TenVT, KhachHang.TenKH, HoaDon.Ngay, ChiTietHoaDon.SL
from HoaDon
join ChiTietHoaDon on HoaDon.MaHD = ChiTietHoaDon.MaHD
join VatTu on ChiTietHoaDon.MaVT = VatTu.MaVT
join KhachHang on HoaDon.MaKH = KhachHang.MaKH
where HoaDon.Ngay between '2000/01/01' and '2000/07/01';

-- Danh sách vật tư bán ra lọc điều kiện
select VatTu.MaVT, TenVT, TenKH, Ngay, SL
from ChiTietHoaDon
join VatTu on ChiTietHoaDon.MaVT = VatTu.MaVT
join HoaDon on ChiTietHoaDon.MaHD = HoaDon.MaHD
join KhachHang on HoaDon.MaKH = KhachHang.MaKH
where DiaChi = 'TAN BINH' 
and Ngay between '2000/1/1' and '2000/12/31';

-- Vật tư mua ở TAN BINH
select VatTu.MaVT, TenVT
from VatTu
join ChiTietHoaDon on VatTu.MaVT = ChiTietHoaDon.MaVT
join HoaDon on HoaDon.MaHD = ChiTietHoaDon.MaHD
join KhachHang on HoaDon.MaKH = KhachHang.MaKH
where DiaChi = 'TAN BINH'
group by VatTu.MaVT, TenVT;

-- Khách hàng không mua trong tháng 6
select TenKH, DiaChi, DienThoai
from KhachHang
right join HoaDon on KhachHang.MaKH = HoaDon.MaKH
where HoaDon.Ngay not between '2000/06/01' and '2000/06/30'
group by TenKH, DiaChi, DienThoai;
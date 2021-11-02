-- 1. Hiển danh sách các khách hàng có điện thoại là 8457895 gồm mã khách hàng, tên khách hàng, địa chỉ, điện thoại, và địa chỉ E-mail.

select MaKH, TenKH, DiaChi, DienThoai, Email
from KhachHang
where DienThoai in(8457895);

-- 2. Hiển danh sách các vật tư là “DA” (bao gồm các loại đá) có giá mua dưới 30000 gồm mã vật tư, tên vật tư, đơn vị tính và giá mua .

select MaVT, TenVT, DVT, GiaMua
from VatTu
where TenVT like 'DA%' 
and GiaMua < 30000;

-- 3. Tạo query để lấy ra các thông tin gồm Mã hoá đơn, ngày lập hoá đơn, tên khách hàng, địa chỉ khách hàng và số điện thoại, sắp xếp theo thứ tự ngày tạo hóa đơn giảm dần

select H.MaHD, H.Ngay, K.TenKH, K.DiaChi, K.DienThoai
from HoaDon as H
join KhachHang as K on K.MaKH = H.MaKH
order by H.Ngay desc;

-- 4. Lấy ra danh sách những khách hàng mua hàng trong tháng 6/2000 gồm các thông tin tên khách hàng, địa chỉ, số điện thoại.

select TenKH, DiaChi, DienThoai
from KhachHang
where MaKH = any 
    (select MaKH from HoaDon where Ngay between '2000/06/01' and '2000/06/30')
order by TenKH;

-- 5. Tạo query để lấy ra các chi tiết hoá đơn gồm các thông tin mã hóa đơn, ,mã vật tư, tên vật tư, giá bán, giá mua, số lượng , trị giá mua (giá mua * số lượng), trị giá bán (giá bán * số lượng), tiền lời (trị giá bán – trị giá mua) mà có giá bán lớn hơn hoặc bằng giá mua.

select MaHD, ChiTietHoaDon.MaVT, TenVT, GiaBan, GiaMua, SL, 
       (GiaMua * SL) as TriGiaMua, (GiaBan * SL) as TriGiaBan,
       (GiaBan - GiaMua) * SL as TienLoi
from ChiTietHoaDon, VatTu
where ChiTietHoaDon.MaVT = VatTu.MaVT and Giaban >= GiaMua;

-- 6. Lấy ra hoá đơn có tổng trị giá nhỏ nhất trong số các hóa đơn năm 2000, gồm các thông tin: Số hoá đơn, ngày, tên khách hàng, địa chỉ khách hàng, tổng trị giá của hoá đơn.

select HoaDon.MaHD, Ngay, TenKH, DiaChi, TongTG
from HoaDon
join ChiTietHoaDon on HoaDon.MaHD = ChiTietHoaDon.MaHD
join KhachHang on HoaDon.MaKH = KhachHang.MaKH
where TongTG = (select min(TongTG) from HoaDon)
and Ngay between '2000/01/01' and '2000/12/31'

-- 7. Lấy ra các thông tin về các khách hàng [có hóa đơn] mua ít loại vật tư nhất.

with ThongKeHoaDon as (
    select c.MaHD, count(MaVT) as LoaiVT
    from ChiTietHoaDon as c
    group by c.MaHD
)
select distinct h.MaKH, k.TenKH
from ThongKeHoaDon t
join HoaDon h on t.MaHD = h.MaHD
join KhachHang k on h.MaKH = k.MaKH
where LoaiVT = (select min(LoaiVT) from ThongKeHoaDon)
order by MaKH

-- 8. Lấy ra vật tư có giá mua thấp nhất

select TenVT as GiaMuaThapNhat
from VatTu
where GiaMua = (select min(GiaMua) from VatTu)

-- 9. Lấy ra vật tư có giá bán cao nhất trong số các vật tư được bán trong năm 2000.

select TenVT as GiaBanCaoNhat
from VatTu as v
join (
    select * 
    from ChiTietHoaDon
    where GiaBan = (select max(GiaBan) from ChiTietHoaDon)
) as c on v.MaVT = c.MaVT
join HoaDon as h on h.MaHD = c.MaHD
where Ngay between '2000/01/01' and '2000/12/31';
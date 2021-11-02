-- 1. Xoá dữ liệu khách hàng có mã KH02
begin tran

alter table HoaDon nocheck constraint all
delete from KhachHang
output deleted.*
where MaKH = 'KH02'
alter table HoaDon check constraint all

rollback tran
-- 2. Xoá tất cả khách hàng ở quận TAN BINH
begin tran

alter table HoaDon nocheck constraint all
delete from KhachHang
output deleted.*
where DiaChi = 'TAN BINH'
alter table HoaDon check constraint all

rollback tran
-- 3. Xóa tất cả vật tư có giá mua < 1000
begin tran

alter table ChiTietHoaDon nocheck constraint all
delete from VatTu
output deleted.*
where GiaMua < 1000
alter table ChiTietHoaDon check constraint all

rollback tran
-- 4. Cập nhật giá bán vật tư có mã VT05 tăng thêm 10%
begin tran

update ChiTietHoaDon
set GiaBan = GiaBan * 1.1
output deleted.*, inserted.*
where MaVT = 'VT05'

rollback tran
-- 5. Cập nhật giá bán của tất cả các vật tư trong mục chi tiết hoá đơn tăng thêm 10% của hoá đơn HD001
begin tran

update ChiTietHoaDon
set GiaBan = GiaBan * 1.1
output deleted.*, inserted.*
where MaHD = 'HD001'

rollback tran

-- Trên CSDL đã tạo trong bài tập Exercise 1, hãy tạo các transaction, mỗi transaction thực hiện một nhóm các công việc như yêu cầu dưới đây

use QLBanHang;
select top 1 * from HoaDon;
select top 1 * from ChiTietHoaDon;

-- 1. Transaction thực hiện:
-- Chèn thông tin hóa đơn có nội dung như sau:
-- (MaHD, Ngay, MaKH) có giá trị ('HD20', '2 Dec 2019', 'KH01') và hóa đơn này bao gồm các sản phẩm:
-- - VT01, 10 đơn vị, giá bán 55000
-- - VT02, 2 đơn vị, giá bán 47000

begin tran

declare 
    @MaHD nvarchar(10) = 'HD20',
    @MaKH nvarchar(5) = 'KH01',
    @Ngay datetime = '2019-12-02',
    @VT01_SL int = 10, 
    @VT01_GiaBan money = 50000,
    @VT02_SL int = 2, 
    @VT02_GiaBan money = 50000,
    @TongTG money

set @TongTG = (@VT01_GiaBan * @VT01_SL) + (@VT02_GiaBan * @VT02_SL)

insert into HoaDon
values (@MaHD, @Ngay, @MaKH, @TongTG)

insert into ChiTietHoaDon
values (@MaHD, 'VT01', @VT01_SL, null, @VT01_GiaBan)

insert into ChiTietHoaDon
values (@MaHD, 'VT02', @VT02_SL, null, @VT02_GiaBan)

select * from ChiTietHoaDon where MaHD = @MaHD
select * from HoaDon where MaHD = @MaHD

rollback tran

-- 2. Transaction thực hiện xóa thông tin về hóa đơn HD008 trong CSDL

begin tran

declare @XoaHD nvarchar(10) = 'HD008'

alter table ChiTietHoaDon nocheck constraint all 
delete from ChiTietHoaDon where MaHD = @XoaHD
alter table ChiTietHoaDon check constraint all 

alter table HoaDon nocheck constraint all 
delete from HoaDon where MaHD = @XoaHD
alter table HoaDon check constraint all 

rollback tran
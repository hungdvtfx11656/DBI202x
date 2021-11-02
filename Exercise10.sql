-- Trên CSDL đã tạo trong bài tập Exercise 1, hãy tạo các Stored procedure sau:

-- 1. Viết procedure sp_Cau1 cập nhật thông tin TONGTG trong bảng hóa đơn theo dữ liệu thực tế của bảng CHITIETHOADON

if object_id('sp_cau1', 'P') is not null
drop proc sp_cau1
go

create proc sp_cau1(@MaHD nvarchar(10)) as
begin
    if exists(select * from HoaDon where MaHD = @MaHD)
    begin
        update HoaDon
        set TongTG = (
            select sum(SL * GiaBan)
            from ChiTietHoaDon
            where MaHD = @MaHD
            group by MaHD
        )
        where MaHD = @MaHD
        select * from HoaDon where MaHD = @MaHD
        return 0
    end
    else return 1
end
go

declare @return int
exec sp_cau1 'HD008'
exec @return = sp_cau1 'HD004'
select @return as ReturnStatus

-- 2. Viết procedure sp_Cau2 có đầu vào là số điện thoại, kiểm tra xem đã có khách hàng có số điện thoại này trong CSDL chưa? Hiện thông báo (bằng lệnh print) để nêu rõ đã có/ chưa có khách hàng này.

if object_id('sp_cau2', 'P') is not null
drop proc sp_cau2
go
create proc sp_cau2(@DienThoai varchar(10), @ResultCount int output) as
begin
    if exists(select * from KhachHang where DienThoai = @DienThoai)
    begin
        select * from KhachHang where DienThoai = @DienThoai
    end
    set @ResultCount =  @@rowcount
end
go

declare @Result int
exec sp_cau2 '08457895', @Result output
select @Result as NumberOfCustomer

if object_id('sp_cau2', 'P') is not null
drop proc sp_cau2
go
create proc sp_cau2(@DienThoai nvarchar(10)) as
begin
    if exists(select * from KhachHang where DienThoai = @DienThoai)
    begin
        select 'Da co'
        return 0
    end
    else 
    begin
        select 'Chua co'
        return 1
    end
end
go

exec sp_cau2 '90000009'

-- 3. Viết procedure sp_Cau3 có đầu vào là mã khách hàng, hãy tính tổng số tiền mà khách hàng này đã mua trong toàn hệ thống, kết quả trả về trong một tham số kiểu output.

if object_id('sp_cau3', 'P') is not null
drop proc sp_cau3
go
create proc sp_cau3(@MaKH nvarchar(5), @KetQua money output) as
begin
    if exists(select * from HoaDon where MaKH = @MaKH)
        begin
            set @KetQua = (
                select sum(TongTG) as KetQua
                from HoaDon
                where MaKH = @MaKH
            )
            return 0
        end
    else return 1
end
go

declare @KetQua money
exec sp_cau3 'KH01', @KetQua output
select @KetQua

-- 4. Viết procedure sp_Cau4 có hai tham số kiểu output là @mavt nvarchar(5) và @tenvt nvarchar(30) để trả về mã và tên của vật tư đã bán được nhiều nhất (được tổng tiền nhiều nhất).

if object_id('sp_cau4', 'P') is not null
drop proc sp_cau4
go
create proc sp_cau4(@MaVT nvarchar(5) output, @TenVT nvarchar(30) output) as
begin
    set @MaVT = (
        select MaVT from ChiTietHoaDon 
        where SL * GiaBan = (select max(SL * GiaBan) from ChiTietHoaDon)
    )
    set @TenVT = (
        select TenVT from VatTu
        where MaVT = @MaVT
    )
end

declare @KQMaVT nvarchar(5), @KQTenVT nvarchar(30)
exec sp_cau4 @KQMaVT output, @KQTenVT output
select @KQMaVT as MaVTLonNhat, @KQTenVT as TenVTLonNhat
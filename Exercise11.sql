-- 1. Viết hàm fc_Cau1 có kiểu dữ liệu trả về là int, nhập vào 1 mã vật tư, tìm xem giá mua của vật tư này là bao nhiêu. Kết quả trả về cho hàm là giá mua tìm được.

if object_id('fc_cau1', 'FN') is not null
drop function fc_cau1
go
create function fc_cau1(@MaVT nvarchar(5)) 
returns int as
begin
    return (select GiaMua from VatTu where MaVT = @MaVT)
end
go

select dbo.fc_cau1('VT03') GiaMua
go

-- 2. Viết hàm fc_Cau2 có kiểu dữ liệu trả về là nvarchar(30), nhập vào 1 mã khách hàng, tìm xem khách hàng này có tên là gì. Kết quả trả về cho hàm là tên khách hàng tìm được.

if object_id('fc_cau2', 'FN') is not null
drop function fc_cau2
go
create function fc_cau2(@MaKH nvarchar(5))
returns nvarchar(30) as
begin
    return (select TenKH from KhachHang where MaKH = @MaKH)
end
go

select dbo.fc_cau2('KH01') KhachHang
go

-- 3. Viết hàm fc_Cau3 có kiểu dữ liệu trả về là int, nhập vào 1 mã khách hàng rồi đếm xem khách hàng này đã mua tổng cộng bao nhiêu tiền. Kết quả trả về cho hàm là tổng số tiền mà khách hàng đã mua.

if object_id('fc_cau3', 'FN') is not null
drop function fc_cau3
go
create function fc_cau3(@MaKH nvarchar(5))
returns money as
begin
    return (select sum(TongTG) from HoaDon where MaKH = @MaKH)
end
go

select dbo.fc_cau3('KH04') TongTien
go

-- 4. Viết hàm fc_Cau4 có kiểu dữ liệu trả về là nvarchar(5), tìm xem vật tư nào là vật tư bán được nhiều nhất (nhiều tiền nhất). Kết quả trả về cho hàm là mã của vật tư này (trường hợp có nhiều vật tư cùng bán được nhiều nhất, chỉ cần trả về 1 mã bất kỳ trong số đó).

if object_id('fc_cau4', 'FN') is not null
drop function fc_cau4
go
create function fc_cau4()
returns nvarchar(5) as
begin
    return (
        select top 1 MaVT from ChiTietHoaDon
        group by MaVT
        order by sum(SL * GiaBan) desc
    )
end
go

select dbo.fc_cau4() KetQua
go
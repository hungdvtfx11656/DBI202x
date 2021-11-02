-- Trên CSDL đã tạo trong Bài tập Exercise 1, hãy tạo các trigger để đảm bảo các ràng buộc sau:
select * from sys.objects

-- 1. Giá bán của một vật tư bất kỳ cần lớn hơn hoặc bằng giá mua của nó. Ràng buộc này cần được đảm bảo khi insert vật tư hoặc update giá bán.

if object_id('TR_Cau1', 'TR') is not null
drop trigger TR_Cau1
go
create trigger TR_Cau1 on ChiTietHoaDon after insert, update as
begin
    if (select GiaBan from inserted) < (
        select GiaMua from VatTu v
        join inserted on v.MaVT = inserted.MaVT
    )
    update ChiTietHoaDon
    set GiaBan = (
        select GiaMua from VatTu v
        join inserted on v.MaVT = inserted.MaVT
        )
    from ChiTietHoaDon c
    join inserted i on c.MaVT = i.MaVT
    join inserted i2 on i2.MaHD = c.MaHD
end
go

begin tran
    alter table ChiTietHoaDon nocheck constraint all 
    insert into ChiTietHoaDon
    values('HD013', 'VT01', 10, null, 40000)
    select * from ChiTietHoaDon
    -- expect GiaBan 50000
rollback tran
go

-- 2. Mỗi khi một vật tư được bán ra với một số lượng nào đó, thì thuộc tính SLTon trong bảng VATTU cần giảm đi tương ứng.

if object_id('TRG_CapNhatSLTon', 'TR') is not null
drop trigger TRG_CapNhatSLTon
go
create trigger TRG_CapNhatSLTon on ChiTietHoaDon after update as 
begin 
    update VatTu
    set SLTon = 
        SLTon -
        (select SL from inserted where MaVT = VatTu.MaVT) + 
        (select SL from deleted where MaVT = VatTu.MaVT)
    from VatTu
    join deleted on VatTu.MaVT = deleted.MaVT
    -- https://viblo.asia/p/su-dung-trigger-trong-sql-qua-vi-du-co-ban-aWj538APK6m
end   
go

begin tran
    select * from ChiTietHoaDon
    select * from VatTu
    update ChiTietHoaDon
    set SL = 10 where MaHD = 'HD001' and MaVT = 'VT01'
    select * from ChiTietHoaDon
    select * from VatTu
rollback tran
go

-- 3. Đảm bảo giá bán của một sản phẩm bất kỳ, chỉ có thể cập nhật tăng, không thể cập nhật giảm.

if object_id('TR_CapNhatGiaBan', 'TR') is not null
drop trigger TR_CapNhatGiaBan
go
create trigger TR_CapNhatGiaBan on ChiTietHoaDon after update as
begin
    if (select GiaBan from inserted) < (select GiaBan from deleted)
    update ChiTietHoaDon
    set GiaBan = (select GiaBan from deleted)
    from ChiTietHoaDon
    join deleted on ChiTietHoaDon.MaHD = deleted.MaHD
    and ChiTietHoaDon.MaVT = deleted.MaVT
end
go

begin tran
    select * from ChiTietHoaDon
    update ChiTietHoaDon
    set GiaBan = 2
    where MaHD = 'HD001'
    and MaVT = 'VT01'
    select * from ChiTietHoaDon
    -- expected GiaBan row 1 = 52000
rollback tran

-- 4. Mỗi khi có sự thay đổi về vật tư được bán trong một hóa đơn nào đó, thuộc tính TONGTG trong bảng HOADON được cập nhật tương ứng.

if object_id('TR_Cau4', 'TR') is not null
drop trigger TR_Cau4
go
create trigger TR_Cau4 on ChiTietHoaDon after insert, delete, update as
begin
    if ((select count(*) from inserted) is not null)
    begin
        update HoaDon
        set TongTG = (
            select sum(SL * GiaBan) 
            from ChiTietHoaDon c
            where c.MaHD = inserted.MaHD
        )
        from HoaDon
        join inserted on inserted.MaHD = HoaDon.MaHD
    end
    -- else
    -- begin
    --     update HoaDon
    --     set TongTG = TongTG - (
    --         select sum(SL * GiaBan)
    --         from deleted
    --     )
    -- end
end
go

begin tran
    select * from HoaDon where MaHD = 'HD001'
    
    -- insert into ChiTietHoaDon
    -- values ('HD001', 'VT03', 1, null, 150)

    -- delete from ChiTietHoaDon
    -- where MaHD = 'HD001' and MaVT = 'VT01'

    update ChiTietHoaDon
    set SL = 1
    where MaHD = 'HD001' and MaVT = 'VT05'

    select * from ChiTietHoaDon
    select * from HoaDon where MaHD = 'HD001'
rollback tran
go

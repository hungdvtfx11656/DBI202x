-- 1. Trường GiaMua trong bảng VATTU.

create nonclustered index NCI_VatTu_GiaMua
on VatTu(GiaMua);

drop index VatTu.NCI_VatTu_GiaMua;

-- 2. Trường SLTon trong bảng VATTU.

create nonclustered index NCI_VatTu_SLTon
on VatTu(SLTon);

drop index VatTu.NCI_VatTu_SLTon;

-- 3. Trường Ngay trong bảng HOADON.

create nonclustered index NCI_HoaDon_Ngay
on HoaDon(Ngay);

drop index HoaDon.NCI_HoaDon_Ngay;

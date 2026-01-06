use KTPM 
go

-- =============================================
-- Procedures cho bảng DonVi
-- =============================================
if exists (select * from sys.objects where type = 'P' and name = 'updateDonVi')
    drop proc updateDonVi
go
create proc updateDonVi
( @action int
, @Id int output
, @Ten nvarchar(50) = NULL
, @HanhChinhId int = NULL
, @TenHanhChinh nvarchar(50) = NULL
, @TrucThuocId int = NULL
) as
BEGIN
    if @action = -1
    begin
        -- Xóa tất cả các bản ghi liên quan
        -- 1. Xóa các cơ sở thuộc đơn vị này
        delete from ThongKeCoSoGiong where CoSoId in (select Id from CoSo where DonViId = @Id)
        delete from CoSoGiongLoaiGiong where CoSoId in (select Id from CoSo where DonViId = @Id)
        delete from ThongKeCoSoGo where CoSoId in (select Id from CoSo where DonViId = @Id)
        delete from CoSoCheBienGo where CoSoId in (select Id from CoSo where DonViId = @Id)
        delete from ThongKeSoLuongDongVat where CoSoDongVatLoaiDongVatId in 
            (select Id from CoSoDongVatLoaiDongVat where CoSoId in (select Id from CoSo where DonViId = @Id))
        delete from CoSoDongVatLoaiDongVat where CoSoId in (select Id from CoSo where DonViId = @Id)
        delete from CoSo where DonViId = @Id
        
        -- 2. Xóa tài khoản thuộc đơn vị
        delete from NguoiDungTrongNhom where UserName in (select TenDangNhap from TaiKhoan where MaDonViId = @Id)
        delete from TaiKhoan where MaDonViId = @Id
        
        -- 3. Xóa nhóm người dùng thuộc đơn vị
        delete from QuyenNhom where GroupId in (select Id from NhomNguoiDung where MaDonViId = @Id)
        delete from NguoiDungTrongNhom where GroupId in (select Id from NhomNguoiDung where MaDonViId = @Id)
        delete from NhomNguoiDung where MaDonViId = @Id
        
        -- 4. Xóa các đơn vị con trực thuộc (đệ quy)
        delete from DonVi where TrucThuocId = @Id
        
        -- 5. Cuối cùng xóa đơn vị
        delete from DonVi where Id = @Id
        return
    end
    if @action = 0
    begin
        update DonVi set
            Ten = @Ten,
            HanhChinhId = @HanhChinhId,
            TenHanhChinh = @TenHanhChinh,
            TrucThuocId = @TrucThuocId
            where Id = @Id
        return
    end
    insert into DonVi values (
        @Ten,@HanhChinhId,@TenHanhChinh,@TrucThuocId
    )
    set @Id = @@IDENTITY
END
go

-- =============================================
-- Procedures cho bảng HoSo
-- =============================================
if exists (select * from sys.objects where type = 'P' and name = 'updateHoSo')
    drop proc updateHoSo
go
create proc updateHoSo
( @action int
, @Id int output
, @TenDangNhap varchar(50)
, @Ten nvarchar(50) = NULL
, @SDT varchar(50) = NULL
, @Email varchar(50) = NULL
, @Ext text = NULL
, @MatKhau varchar(255) = NULL
, @QuyenId int = NULL
) as
BEGIN
    if @action = -1
    begin
        -- Xóa người dùng trong nhóm trước
        delete from NguoiDungTrongNhom where UserName in (select TenDangNhap from TaiKhoan where HoSoId = @Id)
        -- Xóa tài khoản
        delete from TaiKhoan where HoSoId = @Id
        -- Cuối cùng xóa hồ sơ
        delete from HoSo where Id = @Id
        return
    end
    if @action = 0
    begin
        update HoSo set
            Ten = @Ten,
            SDT = @SDT,
            Email = @Email,
            Ext = @Ext
            where Id = @Id
        return
    end

    declare @fk int
    set @fk = (select HoSoId from TaiKhoan where TenDangNhap = @TenDangNhap)
    if @fk is null
    begin
        insert into HoSo values (@Ten,@SDT,@Email,@Ext)
        set @Id = @@IDENTITY
        insert into TaiKhoan values (@TenDangNhap,@MatKhau,@QuyenId,@Id,NULL,NULL)
    end
END
go

if exists (select * from sys.objects where type = 'P' and name = 'changePass')
    drop proc changePass
go
create proc changePass
( @action int
, @Ten varchar(50)
, @MatKhau varchar(255)
) as
BEGIN
    update TaiKhoan set MatKhau = @MatKhau
    where TenDangNhap = @Ten
END
go

-- =============================================
-- Procedures cho bảng TaiKhoan
-- =============================================
if exists (select * from sys.objects where type = 'P' and name = 'updateTaiKhoan')
    drop proc updateTaiKhoan
go
create proc updateTaiKhoan
( @action int
, @TenDangNhap varchar(50)
, @MatKhau varchar(255) = NULL
, @QuyenId int = NULL
, @HoSoId int = NULL
, @MaDonViId int = NULL
) as
BEGIN
    if @action = -1
    begin
        -- Xóa người dùng trong nhóm trước
        delete from NguoiDungTrongNhom where UserName = @TenDangNhap
        -- Sau đó xóa tài khoản
        delete from TaiKhoan where TenDangNhap = @TenDangNhap
        return
    end
    if @action = 0
    begin
        update TaiKhoan set
            MatKhau = @MatKhau,
            QuyenId = @QuyenId,
            HoSoId = @HoSoId,
            MaDonViId = @MaDonViId
            where TenDangNhap = @TenDangNhap
        return
    end
    insert into TaiKhoan values (
        @TenDangNhap,@MatKhau,@QuyenId,@HoSoId,NULL,@MaDonViId
    )
END
go

if exists (select * from sys.objects where type = 'P' and name = 'updateTrangThaiTaiKhoan')
    drop proc updateTrangThaiTaiKhoan
go
create proc updateTrangThaiTaiKhoan
( @Ten varchar(50)
, @TrangThai nvarchar(20)
) as
BEGIN
    update TaiKhoan set 
        LanCuoiHoatDong = GETDATE()
    where TenDangNhap = @Ten
END
go

-- =============================================
-- Procedures cho bảng CoSo
-- =============================================
if exists (select * from sys.objects where type = 'P' and name = 'updateCoSo')
    drop proc updateCoSo
go
create proc updateCoSo
( @action int
, @Id int output
, @DonViId int = NULL
, @LoaiCoSoId int = NULL
, @Ten nvarchar(150) = NULL
, @DiaChi nvarchar(200) = NULL
, @SDT varchar(20) = NULL
, @NguoiDaiDien nvarchar(100) = NULL
) as
BEGIN
    if @action = -1
    begin
        -- Xóa các bảng thống kê và quan hệ trước
        delete from ThongKeCoSoGiong where CoSoId = @Id
        delete from CoSoGiongLoaiGiong where CoSoId = @Id
        delete from ThongKeCoSoGo where CoSoId = @Id
        delete from CoSoCheBienGo where CoSoId = @Id
        delete from ThongKeSoLuongDongVat where CoSoDongVatLoaiDongVatId in 
            (select Id from CoSoDongVatLoaiDongVat where CoSoId = @Id)
        delete from CoSoDongVatLoaiDongVat where CoSoId = @Id
        -- Cuối cùng xóa cơ sở
        delete from CoSo where Id = @Id
        return
    end
    if @action = 0
    begin
        update CoSo set
            DonViId = @DonViId,
            LoaiCoSoId = @LoaiCoSoId,
            Ten = @Ten,
            DiaChi = @DiaChi,
            SDT = @SDT,
            NguoiDaiDien = @NguoiDaiDien
            where Id = @Id
        return
    end
    insert into CoSo values (
        @DonViId,@LoaiCoSoId,@Ten,@DiaChi,@SDT,@NguoiDaiDien
    )
    set @Id = @@IDENTITY
END
go

-- =============================================
-- Procedures cho bảng GiongCay
-- =============================================
if exists (select * from sys.objects where type = 'P' and name = 'updateGiongCay')
    drop proc updateGiongCay
go
create proc updateGiongCay
( @action int
, @Id int output
, @Ten nvarchar(50) = NULL
, @Nguon nvarchar(255) = NULL
, @MoTa nvarchar(200) = NULL
) as
BEGIN
    if @action = -1
    begin
        -- Xóa quan hệ với cơ sở trước
        delete from CoSoGiongLoaiGiong where LoaiGiongId = @Id
        -- Sau đó xóa giống cây
        delete from GiongCay where Id = @Id
        return
    end
    if @action = 0
    begin
        update GiongCay set
            Ten = @Ten,
            Nguon = @Nguon,
            MoTa = @MoTa
            where Id = @Id
        return
    end
    insert into GiongCay values (@Ten,@Nguon,@MoTa)
    set @Id = @@IDENTITY
END
go

-- =============================================
-- Procedures cho bảng LoaiGiongCayTrong (không dùng nữa - đã có GiongCay)
-- =============================================
if exists (select * from sys.objects where type = 'P' and name = 'updateLoaiGiongCayTrong')
    drop proc updateLoaiGiongCayTrong
go
create proc updateLoaiGiongCayTrong
( @action int
, @Id int output
, @Ten nvarchar(100) = NULL
, @MoTa nvarchar(200) = NULL
) as
BEGIN
    if @action = -1
    begin
        delete from LoaiGiongCayTrong where Id = @Id
        return
    end
    if @action = 0
    begin
        update LoaiGiongCayTrong set
            Ten = @Ten,
            MoTa = @MoTa
            where Id = @Id
        return
    end
    insert into LoaiGiongCayTrong values (@Ten,@MoTa)
    set @Id = @@IDENTITY
END
go

-- =============================================
-- Procedures cho bảng CoSoGiongLoaiGiong
-- =============================================
if exists (select * from sys.objects where type = 'P' and name = 'updateCoSoGiongLoaiGiong')
    drop proc updateCoSoGiongLoaiGiong
go
create proc updateCoSoGiongLoaiGiong
( @action int
, @Id int output
, @CoSoId int = NULL
, @LoaiGiongId int = NULL
, @GhiChu nvarchar(200) = NULL
) as
BEGIN
    if @action = -1
    begin
        delete from CoSoGiongLoaiGiong where Id = @Id
        return
    end
    if @action = 0
    begin
        update CoSoGiongLoaiGiong set
            CoSoId = @CoSoId,
            LoaiGiongId = @LoaiGiongId,
            GhiChu = @GhiChu
            where Id = @Id
        return
    end
    insert into CoSoGiongLoaiGiong values (@CoSoId,@LoaiGiongId,@GhiChu)
    set @Id = @@IDENTITY
END
go

-- =============================================
-- Procedures cho bảng ThongKeCoSoGiong
-- =============================================
if exists (select * from sys.objects where type = 'P' and name = 'updateThongKeCoSoGiong')
    drop proc updateThongKeCoSoGiong
go
create proc updateThongKeCoSoGiong
( @action int
, @Id int output
, @CoSoId int = NULL
, @LoaiKyBaoCaoId int = NULL
, @Nam int = NULL
, @KySo int = NULL
, @GiaTriKy decimal(18,2) = NULL
, @DienTich decimal(18,2) = NULL
, @SanLuong decimal(18,2) = NULL
, @GhiChu nvarchar(200) = NULL
) as
BEGIN
    if @action = -1
    begin
        delete from ThongKeCoSoGiong where Id = @Id
        return
    end
    if @action = 0
    begin
        update ThongKeCoSoGiong set
            CoSoId = @CoSoId,
            LoaiKyBaoCaoId = @LoaiKyBaoCaoId,
            Nam = @Nam,
            KySo = @KySo,
            GiaTriKy = @GiaTriKy,
            DienTich = @DienTich,
            SanLuong = @SanLuong,
            GhiChu = @GhiChu
            where Id = @Id
        return
    end
    insert into ThongKeCoSoGiong values (
        @CoSoId,@LoaiKyBaoCaoId,@Nam,@KySo,@GiaTriKy,@DienTich,@SanLuong,@GhiChu
    )
    set @Id = @@IDENTITY
END
go

-- =============================================
-- Procedures cho bảng LoaiHinhSanXuatGo
-- =============================================
if exists (select * from sys.objects where type = 'P' and name = 'updateLoaiHinhSanXuatGo')
    drop proc updateLoaiHinhSanXuatGo
go
create proc updateLoaiHinhSanXuatGo
( @action int
, @Id int output
, @Ten nvarchar(100) = NULL
, @MoTa nvarchar(200) = NULL
) as
BEGIN
    if @action = -1
    begin
        -- Xóa quan hệ với cơ sở trước
        delete from CoSoCheBienGo where LoaiHinhSanXuatGoId = @Id
        -- Sau đó xóa loại hình
        delete from LoaiHinhSanXuatGo where Id = @Id
        return
    end
    if @action = 0
    begin
        update LoaiHinhSanXuatGo set
            Ten = @Ten,
            MoTa = @MoTa
            where Id = @Id
        return
    end
    insert into LoaiHinhSanXuatGo values (@Ten,@MoTa)
    set @Id = @@IDENTITY
END
go

-- =============================================
-- Procedures cho bảng HinhThucHoatDongGo
-- =============================================
if exists (select * from sys.objects where type = 'P' and name = 'updateHinhThucHoatDongGo')
    drop proc updateHinhThucHoatDongGo
go
create proc updateHinhThucHoatDongGo
( @action int
, @Id int output
, @Ten nvarchar(100) = NULL
, @MoTa nvarchar(200) = NULL
) as
BEGIN
    if @action = -1
    begin
        -- Xóa quan hệ với cơ sở trước
        delete from CoSoCheBienGo where HinhThucHoatDongGoId = @Id
        -- Sau đó xóa hình thức
        delete from HinhThucHoatDongGo where Id = @Id
        return
    end
    if @action = 0
    begin
        update HinhThucHoatDongGo set
            Ten = @Ten,
            MoTa = @MoTa
            where Id = @Id
        return
    end
    insert into HinhThucHoatDongGo values (@Ten,@MoTa)
    set @Id = @@IDENTITY
END
go

-- =============================================
-- Procedures cho bảng CoSoCheBienGo
-- =============================================
if exists (select * from sys.objects where type = 'P' and name = 'updateCoSoCheBienGo')
    drop proc updateCoSoCheBienGo
go
create proc updateCoSoCheBienGo
( @action int
, @CoSoId int
, @LoaiHinhSanXuatGoId int = NULL
, @HinhThucHoatDongGoId int = NULL
) as
BEGIN
    if @action = -1
    begin
        delete from CoSoCheBienGo where CoSoId = @CoSoId
        return
    end
    if @action = 0
    begin
        update CoSoCheBienGo set
            LoaiHinhSanXuatGoId = @LoaiHinhSanXuatGoId,
            HinhThucHoatDongGoId = @HinhThucHoatDongGoId
            where CoSoId = @CoSoId
        return
    end
    insert into CoSoCheBienGo values (
        @CoSoId,@LoaiHinhSanXuatGoId,@HinhThucHoatDongGoId
    )
END
go

-- =============================================
-- Procedures cho bảng ThongKeCoSoGo
-- =============================================
if exists (select * from sys.objects where type = 'P' and name = 'updateThongKeCoSoGo')
    drop proc updateThongKeCoSoGo
go
create proc updateThongKeCoSoGo
( @action int
, @Id int output
, @CoSoId int = NULL
, @LoaiKyBaoCaoId int = NULL
, @Nam int = NULL
, @KySo int = NULL
, @GiaTriKy decimal(18,2) = NULL
, @DienTich decimal(18,2) = NULL
, @SanLuong decimal(18,2) = NULL
, @GhiChu nvarchar(200) = NULL
) as
BEGIN
    if @action = -1
    begin
        delete from ThongKeCoSoGo where Id = @Id
        return
    end
    if @action = 0
    begin
        update ThongKeCoSoGo set
            CoSoId = @CoSoId,
            LoaiKyBaoCaoId = @LoaiKyBaoCaoId,
            Nam = @Nam,
            KySo = @KySo,
            GiaTriKy = @GiaTriKy,
            DienTich = @DienTich,
            SanLuong = @SanLuong,
            GhiChu = @GhiChu
            where Id = @Id
        return
    end
    insert into ThongKeCoSoGo values (
        @CoSoId,@LoaiKyBaoCaoId,@Nam,@KySo,@GiaTriKy,@DienTich,@SanLuong,@GhiChu
    )
    set @Id = @@IDENTITY
END
go

-- =============================================
-- Procedures cho bảng LoaiDongVat
-- =============================================
if exists (select * from sys.objects where type = 'P' and name = 'updateLoaiDongVat')
    drop proc updateLoaiDongVat
go
create proc updateLoaiDongVat
( @action int
, @Id int output
, @TenKhoaHoc nvarchar(150) = NULL
, @TenTiengViet nvarchar(150) = NULL
, @NhomLoai nvarchar(100) = NULL
, @MucBaoTon nvarchar(100) = NULL
) as
BEGIN
    if @action = -1
    begin
        -- Xóa thống kê số lượng động vật trước
        delete from ThongKeSoLuongDongVat where CoSoDongVatLoaiDongVatId in 
            (select Id from CoSoDongVatLoaiDongVat where LoaiDongVatId = @Id)
        -- Xóa quan hệ với cơ sở
        delete from CoSoDongVatLoaiDongVat where LoaiDongVatId = @Id
        -- Cuối cùng xóa loại động vật
        delete from LoaiDongVat where Id = @Id
        return
    end
    if @action = 0
    begin
        update LoaiDongVat set
            TenKhoaHoc = @TenKhoaHoc,
            TenTiengViet = @TenTiengViet,
            NhomLoai = @NhomLoai,
            MucBaoTon = @MucBaoTon
            where Id = @Id
        return
    end
    insert into LoaiDongVat values (
        @TenKhoaHoc,@TenTiengViet,@NhomLoai,@MucBaoTon
    )
    set @Id = @@IDENTITY
END
go

-- =============================================
-- Procedures cho bảng CoSoDongVatLoaiDongVat
-- =============================================
if exists (select * from sys.objects where type = 'P' and name = 'updateCoSoDongVatLoaiDongVat')
    drop proc updateCoSoDongVatLoaiDongVat
go
create proc updateCoSoDongVatLoaiDongVat
( @action int
, @Id int output
, @CoSoId int = NULL
, @LoaiDongVatId int = NULL
, @GhiChu nvarchar(200) = NULL
) as
BEGIN
    if @action = -1
    begin
        -- Xóa thống kê số lượng trước
        delete from ThongKeSoLuongDongVat where CoSoDongVatLoaiDongVatId = @Id
        -- Sau đó xóa quan hệ
        delete from CoSoDongVatLoaiDongVat where Id = @Id
        return
    end
    if @action = 0
    begin
        update CoSoDongVatLoaiDongVat set
            CoSoId = @CoSoId,
            LoaiDongVatId = @LoaiDongVatId,
            GhiChu = @GhiChu
            where Id = @Id
        return
    end
    insert into CoSoDongVatLoaiDongVat values (@CoSoId,@LoaiDongVatId,@GhiChu)
    set @Id = @@IDENTITY
END
go

-- =============================================
-- Procedures cho bảng ThongKeSoLuongDongVat
-- =============================================
if exists (select * from sys.objects where type = 'P' and name = 'updateThongKeSoLuongDongVat')
    drop proc updateThongKeSoLuongDongVat
go
create proc updateThongKeSoLuongDongVat
( @action int
, @Id int output
, @CoSoDongVatLoaiDongVatId int = NULL
, @LoaiKyBaoCaoId int = NULL
, @Nam int = NULL
, @KySo int = NULL
, @SoLuongLoai int = NULL
, @GhiChu nvarchar(200) = NULL
, @TenLoai nvarchar(150) = NULL
) as
BEGIN
    if @action = -1
    begin
        delete from ThongKeSoLuongDongVat where Id = @Id
        return
    end
    if @action = 0
    begin
        update ThongKeSoLuongDongVat set
            CoSoDongVatLoaiDongVatId = @CoSoDongVatLoaiDongVatId,
            LoaiKyBaoCaoId = @LoaiKyBaoCaoId,
            Nam = @Nam,
            KySo = @KySo,
            SoLuongLoai = @SoLuongLoai,
            GhiChu = @GhiChu,
            TenLoai = @TenLoai
            where Id = @Id
        return
    end
    insert into ThongKeSoLuongDongVat values (
        @CoSoDongVatLoaiDongVatId,@LoaiKyBaoCaoId,@Nam,@KySo,@SoLuongLoai,@GhiChu,@TenLoai
    )
    set @Id = @@IDENTITY
END
go

-- =============================================
-- Procedures cho bảng NhomNguoiDung
-- =============================================
if exists (select * from sys.objects where type = 'P' and name = 'updateNhomNguoiDung')
    drop proc updateNhomNguoiDung
go
create proc updateNhomNguoiDung
( @action int
, @Id int output
, @MaDonViId int = NULL
, @TenNhom nvarchar(100) = NULL
) as
BEGIN
    if @action = -1
    begin
        -- Xóa quyền nhóm trước
        delete from QuyenNhom where GroupId = @Id
        -- Xóa người dùng trong nhóm
        delete from NguoiDungTrongNhom where GroupId = @Id
        -- Cuối cùng xóa nhóm
        delete from NhomNguoiDung where Id = @Id
        return
    end
    if @action = 0
    begin
        update NhomNguoiDung set
            MaDonViId = @MaDonViId,
            TenNhom = @TenNhom
            where Id = @Id
        return
    end
    insert into NhomNguoiDung values (@MaDonViId,@TenNhom)
    set @Id = @@IDENTITY
END
go

-- =============================================
-- Procedures cho bảng NguoiDungTrongNhom
-- =============================================
if exists (select * from sys.objects where type = 'P' and name = 'updateNguoiDungTrongNhom')
    drop proc updateNguoiDungTrongNhom
go
create proc updateNguoiDungTrongNhom
( @action int
, @UserName varchar(50)
, @GroupId int = NULL
) as
BEGIN
    if @action = -1
    begin
        delete from NguoiDungTrongNhom where UserName = @UserName
        return
    end
    if @action = 0
    begin
        update NguoiDungTrongNhom set
            GroupId = @GroupId
            where UserName = @UserName
        return
    end
    insert into NguoiDungTrongNhom values (@UserName,@GroupId)
END
go

-- =============================================
-- Procedures cho bảng QuyenNhom
-- =============================================
if exists (select * from sys.objects where type = 'P' and name = 'updateQuyenNhom')
    drop proc updateQuyenNhom
go
create proc updateQuyenNhom
( @action int
, @GroupId int
, @TacDongId int = NULL
) as
BEGIN
    if @action = -1
    begin
        delete from QuyenNhom where GroupId = @GroupId and TacDongId = @TacDongId
        return
    end
    if @action = 0
    begin
        return
    end
    insert into QuyenNhom values (@GroupId,@TacDongId)
END
go

-- =============================================
-- Procedures hỗ trợ
-- =============================================
if exists (select * from sys.objects where type = 'P' and name = 'getCoSoByDonVi')
    drop proc getCoSoByDonVi
go
create proc getCoSoByDonVi
( @DonViId int
) as
BEGIN
    select * from ViewCoSo where DonViId = @DonViId
END
go

if exists (select * from sys.objects where type = 'P' and name = 'getQuyenByUserName')
    drop proc getQuyenByUserName
go
create proc getQuyenByUserName
( @UserName varchar(50)
) as
BEGIN
    select distinct T.Id, T.Ten
    from TacDong T
    inner join QuyenNhom QN on T.Id = QN
    inner join NguoiDungTrongNhom ND on QN.GroupId = ND.GroupId
    where ND.UserName = @UserName
END
go

-- =============================================
-- Procedures cho bảng LichSuTacDong (Phần 8)
-- =============================================
if exists (select * from sys.objects where type = 'P' and name = 'updateLichSuTacDong')
    drop proc updateLichSuTacDong
go
create proc updateLichSuTacDong
( @action int
, @Id int output
, @TenTaiKhoan varchar(50) = NULL
, @TacDongId int = NULL
, @ThoiGian datetime = NULL
, @MoTa nvarchar(300) = NULL
) as
BEGIN
    if @action = -1
    begin
        -- Xóa lịch sử tác động
        delete from LichSuTacDong where Id = @Id
        return
    end
    if @action = 0
    begin
        -- Cập nhật lịch sử tác động
        update LichSuTacDong set
            TenTaiKhoan = @TenTaiKhoan,
            TacDongId = @TacDongId,
            ThoiGian = @ThoiGian,
            MoTa = @MoTa
            where Id = @Id
        return
    end
    -- Thêm mới lịch sử tác động
    -- Nếu không truyền ThoiGian, dùng GETDATE()
    if @ThoiGian is null
        set @ThoiGian = GETDATE()
    
    insert into LichSuTacDong values (
        @TenTaiKhoan, @TacDongId, @ThoiGian, @MoTa
    )
    set @Id = @@IDENTITY
END
go
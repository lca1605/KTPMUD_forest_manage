USE KTPM
GO

/* =========================
   1) updateDonVi
   ========================= */
IF OBJECT_ID('updateDonVi') IS NOT NULL
    DROP PROC updateDonVi
GO

CREATE PROC updateDonVi
(
    @action INT,              -- -1: delete | 0: update | 1: insert
    @Id INT OUTPUT,
    @Ten NVARCHAR(50) = NULL,
    @HanhChinhId INT = NULL,
    @TenHanhChinh NVARCHAR(50) = NULL,
    @TrucThuocId INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        -- DELETE
        IF @action = -1
        BEGIN
            DELETE FROM DonVi WHERE Id = @Id
            COMMIT
            RETURN
        END

        -- UPDATE
        IF @action = 0
        BEGIN
            UPDATE DonVi
            SET Ten = @Ten,
                HanhChinhId = @HanhChinhId,
                TenHanhChinh = @TenHanhChinh,
                TrucThuocId = @TrucThuocId
            WHERE Id = @Id

            COMMIT
            RETURN
        END

        -- INSERT
        INSERT INTO DonVi (Ten, HanhChinhId, TenHanhChinh, TrucThuocId)
        VALUES (@Ten, @HanhChinhId, @TenHanhChinh, @TrucThuocId)

        SET @Id = SCOPE_IDENTITY()

        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

/* =========================
   2) updateHoSo
   ========================= */
IF OBJECT_ID('updateHoSo') IS NOT NULL
    DROP PROC updateHoSo
GO

CREATE PROC updateHoSo
(
    @action INT,                  -- -1: delete | 0: update | 1: insert
    @Id INT OUTPUT,               -- HoSo.Id
    @TenDangNhap VARCHAR(50),
    @Ten NVARCHAR(50) = NULL,
    @SDT VARCHAR(50) = NULL,
    @Email VARCHAR(50) = NULL,
    @Ext TEXT = NULL,
    @MatKhau VARCHAR(255) = NULL,
    @QuyenId INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        -- DELETE
        IF @action = -1
        BEGIN
            DELETE FROM TaiKhoan WHERE Ten = @TenDangNhap
            DELETE FROM HoSo WHERE Id = @Id
            COMMIT
            RETURN
        END

        -- UPDATE HoSo
        IF @action = 0
        BEGIN
            UPDATE HoSo
            SET Ten = @Ten,
                SDT = @SDT,
                Email = @Email,
                Ext = @Ext
            WHERE Id = @Id

            COMMIT
            RETURN
        END

        -- INSERT
        IF EXISTS (SELECT 1 FROM TaiKhoan WHERE Ten = @TenDangNhap)
        BEGIN
            RAISERROR (N'Tài khoản đã tồn tại', 16, 1)
        END

        INSERT INTO HoSo (Ten, SDT, Email, Ext)
        VALUES (@Ten, @SDT, @Email, @Ext)

        SET @Id = SCOPE_IDENTITY()

        INSERT INTO TaiKhoan (Ten, MatKhau, QuyenId, HoSoId)
        VALUES (@TenDangNhap, @MatKhau, @QuyenId, @Id)

        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

/* =========================
   3) changePass
   ========================= */
IF OBJECT_ID('changePass') IS NOT NULL
    DROP PROC changePass
GO

CREATE PROC changePass
(
    @Ten VARCHAR(50),
    @MatKhau VARCHAR(255)
)
AS
BEGIN
    UPDATE TaiKhoan
    SET MatKhau = @MatKhau
    WHERE Ten = @Ten
END
GO

/* =========================
   4) updateGiongCay
   ========================= */
IF OBJECT_ID('updateGiongCay') IS NOT NULL
    DROP PROC updateGiongCay
GO

CREATE PROC updateGiongCay
(
    @action INT,
    @Id INT OUTPUT,
    @Ten NVARCHAR(50) = NULL,
    @Nguon NVARCHAR(255) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @action = -1
        BEGIN
            DELETE FROM GiongCay WHERE Id = @Id
            COMMIT
            RETURN
        END

        IF @action = 0
        BEGIN
            UPDATE GiongCay
            SET Ten = @Ten,
                Nguon = @Nguon
            WHERE Id = @Id
            COMMIT
            RETURN
        END

        INSERT INTO GiongCay (Ten, Nguon)
        VALUES (@Ten, @Nguon)

        SET @Id = SCOPE_IDENTITY()
        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

/* =========================
   5) updateCoSo
   ========================= */
IF OBJECT_ID('updateCoSo') IS NOT NULL
    DROP PROC updateCoSo
GO

CREATE PROC updateCoSo
(
    @action INT,
    @Id INT OUTPUT,
    @DonViId INT = NULL,
    @LoaiCoSoId INT = NULL,
    @Ten NVARCHAR(150) = NULL,
    @DiaChi NVARCHAR(200) = NULL,
    @SDT VARCHAR(20) = NULL,
    @NguoiDaiDien NVARCHAR(100) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @action = -1
        BEGIN
            DELETE FROM CoSo WHERE Id = @Id
            COMMIT
            RETURN
        END

        IF @action = 0
        BEGIN
            UPDATE CoSo
            SET DonViId = @DonViId,
                LoaiCoSoId = @LoaiCoSoId,
                Ten = @Ten,
                DiaChi = @DiaChi,
                SDT = @SDT,
                NguoiDaiDien = @NguoiDaiDien
            WHERE Id = @Id
            COMMIT
            RETURN
        END

        INSERT INTO CoSo (DonViId, LoaiCoSoId, Ten, DiaChi, SDT, NguoiDaiDien)
        VALUES (@DonViId, @LoaiCoSoId, @Ten, @DiaChi, @SDT, @NguoiDaiDien)

        SET @Id = SCOPE_IDENTITY()
        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

/* =========================
   6) updateLoaiGiongCayTrong
   ========================= */
IF OBJECT_ID('updateLoaiGiongCayTrong') IS NOT NULL
    DROP PROC updateLoaiGiongCayTrong
GO

CREATE PROC updateLoaiGiongCayTrong
(
    @action INT,
    @Id INT OUTPUT,
    @Ten NVARCHAR(100) = NULL,
    @MoTa NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @action = -1
        BEGIN
            DELETE FROM LoaiGiongCayTrong WHERE Id = @Id
            COMMIT
            RETURN
        END

        IF @action = 0
        BEGIN
            UPDATE LoaiGiongCayTrong
            SET Ten = @Ten,
                MoTa = @MoTa
            WHERE Id = @Id
            COMMIT
            RETURN
        END

        INSERT INTO LoaiGiongCayTrong (Ten, MoTa)
        VALUES (@Ten, @MoTa)

        SET @Id = SCOPE_IDENTITY()
        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

/* =========================
   7) updateThongKeCoSoGiong
   ========================= */
IF OBJECT_ID('updateThongKeCoSoGiong') IS NOT NULL
    DROP PROC updateThongKeCoSoGiong
GO

CREATE PROC updateThongKeCoSoGiong
(
    @action INT,
    @Id INT OUTPUT,
    @CoSoId INT = NULL,
    @LoaiKyBaoCaoId INT = NULL,
    @Nam INT = NULL,
    @KySo INT = NULL,
    @GiaTriKy DECIMAL(18,2) = NULL,
    @DienTich DECIMAL(18,2) = NULL,
    @SanLuong DECIMAL(18,2) = NULL,
    @GhiChu NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @action = -1
        BEGIN
            DELETE FROM ThongKeCoSoGiong WHERE Id = @Id
            COMMIT
            RETURN
        END

        IF @action = 0
        BEGIN
            UPDATE ThongKeCoSoGiong
            SET CoSoId = @CoSoId,
                LoaiKyBaoCaoId = @LoaiKyBaoCaoId,
                Nam = @Nam,
                KySo = @KySo,
                GiaTriKy = @GiaTriKy,
                DienTich = @DienTich,
                SanLuong = @SanLuong,
                GhiChu = @GhiChu
            WHERE Id = @Id
            COMMIT
            RETURN
        END

        INSERT INTO ThongKeCoSoGiong (CoSoId, LoaiKyBaoCaoId, Nam, KySo, GiaTriKy, DienTich, SanLuong, GhiChu)
        VALUES (@CoSoId, @LoaiKyBaoCaoId, @Nam, @KySo, @GiaTriKy, @DienTich, @SanLuong, @GhiChu)

        SET @Id = SCOPE_IDENTITY()
        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

/* =========================
   8) updateThongKeCoSoGo
   ========================= */
IF OBJECT_ID('updateThongKeCoSoGo') IS NOT NULL
    DROP PROC updateThongKeCoSoGo
GO

CREATE PROC updateThongKeCoSoGo
(
    @action INT,
    @Id INT OUTPUT,
    @CoSoId INT = NULL,
    @LoaiKyBaoCaoId INT = NULL,
    @Nam INT = NULL,
    @KySo INT = NULL,
    @GiaTriKy DECIMAL(18,2) = NULL,
    @DienTich DECIMAL(18,2) = NULL,
    @SanLuong DECIMAL(18,2) = NULL,
    @GhiChu NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @action = -1
        BEGIN
            DELETE FROM ThongKeCoSoGo WHERE Id = @Id
            COMMIT
            RETURN
        END

        IF @action = 0
        BEGIN
            UPDATE ThongKeCoSoGo
            SET CoSoId = @CoSoId,
                LoaiKyBaoCaoId = @LoaiKyBaoCaoId,
                Nam = @Nam,
                KySo = @KySo,
                GiaTriKy = @GiaTriKy,
                DienTich = @DienTich,
                SanLuong = @SanLuong,
                GhiChu = @GhiChu
            WHERE Id = @Id
            COMMIT
            RETURN
        END

        INSERT INTO ThongKeCoSoGo (CoSoId, LoaiKyBaoCaoId, Nam, KySo, GiaTriKy, DienTich, SanLuong, GhiChu)
        VALUES (@CoSoId, @LoaiKyBaoCaoId, @Nam, @KySo, @GiaTriKy, @DienTich, @SanLuong, @GhiChu)

        SET @Id = SCOPE_IDENTITY()
        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

/* =========================
   9) updateLoaiDongVat
   ========================= */
IF OBJECT_ID('updateLoaiDongVat') IS NOT NULL
    DROP PROC updateLoaiDongVat
GO

CREATE PROC updateLoaiDongVat
(
    @action INT,
    @Id INT OUTPUT,
    @TenKhoaHoc NVARCHAR(150) = NULL,
    @TenTiengViet NVARCHAR(150) = NULL,
    @NhomLoai NVARCHAR(100) = NULL,
    @MucBaoTon NVARCHAR(100) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @action = -1
        BEGIN
            DELETE FROM LoaiDongVat WHERE Id = @Id
            COMMIT
            RETURN
        END

        IF @action = 0
        BEGIN
            UPDATE LoaiDongVat
            SET TenKhoaHoc = @TenKhoaHoc,
                TenTiengViet = @TenTiengViet,
                NhomLoai = @NhomLoai,
                MucBaoTon = @MucBaoTon
            WHERE Id = @Id
            COMMIT
            RETURN
        END

        INSERT INTO LoaiDongVat (TenKhoaHoc, TenTiengViet, NhomLoai, MucBaoTon)
        VALUES (@TenKhoaHoc, @TenTiengViet, @NhomLoai, @MucBaoTon)

        SET @Id = SCOPE_IDENTITY()
        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

/* =========================
   10) updateThongKeSoLuongDongVat
   ========================= */
IF OBJECT_ID('updateThongKeSoLuongDongVat') IS NOT NULL
    DROP PROC updateThongKeSoLuongDongVat
GO

CREATE PROC updateThongKeSoLuongDongVat
(
    @action INT,
    @Id INT OUTPUT,
    @CoSoId INT = NULL,
    @LoaiDongVatId INT = NULL,
    @LoaiKyBaoCaoId INT = NULL,
    @Nam INT = NULL,
    @KySo INT = NULL,
    @GiaTriKy DECIMAL(18,2) = NULL,
    @SoDauKy DECIMAL(18,2) = NULL,
    @SoCuoiKy DECIMAL(18,2) = NULL,
    @GhiChu NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @action = -1
        BEGIN
            DELETE FROM ThongKeSoLuongDongVat WHERE Id = @Id
            COMMIT
            RETURN
        END

        IF @action = 0
        BEGIN
            UPDATE ThongKeSoLuongDongVat
            SET CoSoId = @CoSoId,
                LoaiDongVatId = @LoaiDongVatId,
                LoaiKyBaoCaoId = @LoaiKyBaoCaoId,
                Nam = @Nam,
                KySo = @KySo,
                GiaTriKy = @GiaTriKy,
                SoDauKy = @SoDauKy,
                SoCuoiKy = @SoCuoiKy,
                GhiChu = @GhiChu
            WHERE Id = @Id
            COMMIT
            RETURN
        END

        INSERT INTO ThongKeSoLuongDongVat (CoSoId, LoaiDongVatId, LoaiKyBaoCaoId, Nam, KySo, GiaTriKy, SoDauKy, SoCuoiKy, GhiChu)
        VALUES (@CoSoId, @LoaiDongVatId, @LoaiKyBaoCaoId, @Nam, @KySo, @GiaTriKy, @SoDauKy, @SoCuoiKy, @GhiChu)

        SET @Id = SCOPE_IDENTITY()
        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

/* =========================
   11) updateBienDongSoLuongDongVat
   ========================= */
IF OBJECT_ID('updateBienDongSoLuongDongVat') IS NOT NULL
    DROP PROC updateBienDongSoLuongDongVat
GO

CREATE PROC updateBienDongSoLuongDongVat
(
    @action INT,
    @Id INT OUTPUT,
    @CoSoId INT = NULL,
    @LoaiDongVatId INT = NULL,
    @LoaiBienDongId INT = NULL,
    @NgayBienDong DATE = NULL,
    @SoLuong DECIMAL(18,2) = NULL,
    @GhiChu NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @action = -1
        BEGIN
            DELETE FROM BienDongSoLuongDongVat WHERE Id = @Id
            COMMIT
            RETURN
        END

        IF @action = 0
        BEGIN
            UPDATE BienDongSoLuongDongVat
            SET CoSoId = @CoSoId,
                LoaiDongVatId = @LoaiDongVatId,
                LoaiBienDongId = @LoaiBienDongId,
                NgayBienDong = @NgayBienDong,
                SoLuong = @SoLuong,
                GhiChu = @GhiChu
            WHERE Id = @Id
            COMMIT
            RETURN
        END

        INSERT INTO BienDongSoLuongDongVat (CoSoId, LoaiDongVatId, LoaiBienDongId, NgayBienDong, SoLuong, GhiChu)
        VALUES (@CoSoId, @LoaiDongVatId, @LoaiBienDongId, @NgayBienDong, @SoLuong, @GhiChu)

        SET @Id = SCOPE_IDENTITY()
        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

/* =========================
   12) updateNhomNguoiDung
   ========================= */
IF OBJECT_ID('updateNhomNguoiDung') IS NOT NULL
    DROP PROC updateNhomNguoiDung
GO

CREATE PROC updateNhomNguoiDung
(
    @action INT,
    @Id INT OUTPUT,
    @MaDonViId INT = NULL,
    @TenNhom NVARCHAR(100) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @action = -1
        BEGIN
            DELETE FROM NhomNguoiDung WHERE Id = @Id
            COMMIT
            RETURN
        END

        IF @action = 0
        BEGIN
            UPDATE NhomNguoiDung
            SET MaDonViId = @MaDonViId,
                TenNhom = @TenNhom
            WHERE Id = @Id
            COMMIT
            RETURN
        END

        INSERT INTO NhomNguoiDung (MaDonViId, TenNhom)
        VALUES (@MaDonViId, @TenNhom)

        SET @Id = SCOPE_IDENTITY()
        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO
/* =========================
   13) updateQuyen
   ========================= */
IF OBJECT_ID('updateQuyen') IS NOT NULL
    DROP PROC updateQuyen
GO

CREATE PROC updateQuyen
(
    @action INT,
    @Id INT OUTPUT,
    @Ten NVARCHAR(50) = NULL,
    @Ext VARCHAR(50) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @action = -1
        BEGIN
            DELETE FROM Quyen WHERE Id = @Id
            COMMIT
            RETURN
        END

        IF @action = 0
        BEGIN
            UPDATE Quyen
            SET Ten = @Ten,
                Ext = @Ext
            WHERE Id = @Id
            COMMIT
            RETURN
        END

        INSERT INTO Quyen (Ten, Ext)
        VALUES (@Ten, @Ext)

        SET @Id = SCOPE_IDENTITY()
        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

/* =========================
   14) updateHanhChinh
   ========================= */
IF OBJECT_ID('updateHanhChinh') IS NOT NULL
    DROP PROC updateHanhChinh
GO

CREATE PROC updateHanhChinh
(
    @action INT,
    @Id INT OUTPUT,
    @Ten NVARCHAR(50) = NULL,
    @TrucThuocId INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @action = -1
        BEGIN
            DELETE FROM HanhChinh WHERE Id = @Id
            COMMIT
            RETURN
        END

        IF @action = 0
        BEGIN
            UPDATE HanhChinh
            SET Ten = @Ten,
                TrucThuocId = @TrucThuocId
            WHERE Id = @Id
            COMMIT
            RETURN
        END

        INSERT INTO HanhChinh (Ten, TrucThuocId)
        VALUES (@Ten, @TrucThuocId)

        SET @Id = SCOPE_IDENTITY()
        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

/* =========================
   15) updateTaiKhoan
   ========================= */
IF OBJECT_ID('updateTaiKhoan') IS NOT NULL
    DROP PROC updateTaiKhoan
GO

CREATE PROC updateTaiKhoan
(
    @action INT,
    @Ten VARCHAR(50) OUTPUT,
    @MatKhau VARCHAR(255) = NULL,
    @QuyenId INT = NULL,
    @HoSoId INT = NULL,
    @TrangThai NVARCHAR(20) = NULL,
    @MaDonViId INT = NULL,
    @HoTen NVARCHAR(100) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @action = -1
        BEGIN
            DELETE FROM TaiKhoan WHERE Ten = @Ten
            COMMIT
            RETURN
        END

        IF @action = 0
        BEGIN
            UPDATE TaiKhoan
            SET MatKhau = @MatKhau,
                QuyenId = @QuyenId,
                HoSoId = @HoSoId,
                TrangThai = @TrangThai,
                MaDonViId = @MaDonViId,
                HoTen = @HoTen
            WHERE Ten = @Ten
            COMMIT
            RETURN
        END

        INSERT INTO TaiKhoan (Ten, MatKhau, QuyenId, HoSoId, TrangThai, MaDonViId, HoTen)
        VALUES (@Ten, @MatKhau, @QuyenId, @HoSoId, @TrangThai, @MaDonViId, @HoTen)

        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

/* =========================
   16) updateLoaiKyBaoCao
   ========================= */
IF OBJECT_ID('updateLoaiKyBaoCao') IS NOT NULL
    DROP PROC updateLoaiKyBaoCao
GO

CREATE PROC updateLoaiKyBaoCao
(
    @action INT,
    @Id INT OUTPUT,
    @Ten NVARCHAR(20) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @action = -1
        BEGIN
            DELETE FROM LoaiKyBaoCao WHERE Id = @Id
            COMMIT
            RETURN
        END

        IF @action = 0
        BEGIN
            UPDATE LoaiKyBaoCao
            SET Ten = @Ten
            WHERE Id = @Id
            COMMIT
            RETURN
        END

        INSERT INTO LoaiKyBaoCao (Ten)
        VALUES (@Ten)

        SET @Id = SCOPE_IDENTITY()
        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

/* =========================
   17) updateLoaiCoSo
   ========================= */
IF OBJECT_ID('updateLoaiCoSo') IS NOT NULL
    DROP PROC updateLoaiCoSo
GO

CREATE PROC updateLoaiCoSo
(
    @action INT,
    @Id INT OUTPUT,
    @Ten NVARCHAR(100) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @action = -1
        BEGIN
            DELETE FROM LoaiCoSo WHERE Id = @Id
            COMMIT
            RETURN
        END

        IF @action = 0
        BEGIN
            UPDATE LoaiCoSo
            SET Ten = @Ten
            WHERE Id = @Id
            COMMIT
            RETURN
        END

        INSERT INTO LoaiCoSo (Ten)
        VALUES (@Ten)

        SET @Id = SCOPE_IDENTITY()
        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

/* =========================
   18) updateCoSoGiong_LoaiGiong
   ========================= */
IF OBJECT_ID('updateCoSoGiong_LoaiGiong') IS NOT NULL
    DROP PROC updateCoSoGiong_LoaiGiong
GO

CREATE PROC updateCoSoGiong_LoaiGiong
(
    @action INT,
    @Id INT OUTPUT,
    @CoSoId INT = NULL,
    @LoaiGiongId INT = NULL,
    @GhiChu NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @action = -1
        BEGIN
            DELETE FROM CoSoGiong_LoaiGiong WHERE Id = @Id
            COMMIT
            RETURN
        END

        IF @action = 0
        BEGIN
            UPDATE CoSoGiong_LoaiGiong
            SET CoSoId = @CoSoId,
                LoaiGiongId = @LoaiGiongId,
                GhiChu = @GhiChu
            WHERE Id = @Id
            COMMIT
            RETURN
        END

        INSERT INTO CoSoGiong_LoaiGiong (CoSoId, LoaiGiongId, GhiChu)
        VALUES (@CoSoId, @LoaiGiongId, @GhiChu)

        SET @Id = SCOPE_IDENTITY()
        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

/* =========================
   19) updateLoaiHinhSanXuatGo
   ========================= */
IF OBJECT_ID('updateLoaiHinhSanXuatGo') IS NOT NULL
    DROP PROC updateLoaiHinhSanXuatGo
GO

CREATE PROC updateLoaiHinhSanXuatGo
(
    @action INT,
    @Id INT OUTPUT,
    @Ten NVARCHAR(100) = NULL,
    @MoTa NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @action = -1
        BEGIN
            DELETE FROM LoaiHinhSanXuatGo WHERE Id = @Id
            COMMIT
            RETURN
        END

        IF @action = 0
        BEGIN
            UPDATE LoaiHinhSanXuatGo
            SET Ten = @Ten,
                MoTa = @MoTa
            WHERE Id = @Id
            COMMIT
            RETURN
        END

        INSERT INTO LoaiHinhSanXuatGo (Ten, MoTa)
        VALUES (@Ten, @MoTa)

        SET @Id = SCOPE_IDENTITY()
        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

/* =========================
   20) updateHinhThucHoatDongGo
   ========================= */
IF OBJECT_ID('updateHinhThucHoatDongGo') IS NOT NULL
    DROP PROC updateHinhThucHoatDongGo
GO

CREATE PROC updateHinhThucHoatDongGo
(
    @action INT,
    @Id INT OUTPUT,
    @Ten NVARCHAR(100) = NULL,
    @MoTa NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @action = -1
        BEGIN
            DELETE FROM HinhThucHoatDongGo WHERE Id = @Id
            COMMIT
            RETURN
        END

        IF @action = 0
        BEGIN
            UPDATE HinhThucHoatDongGo
            SET Ten = @Ten,
                MoTa = @MoTa
            WHERE Id = @Id
            COMMIT
            RETURN
        END

        INSERT INTO HinhThucHoatDongGo (Ten, MoTa)
        VALUES (@Ten, @MoTa)

        SET @Id = SCOPE_IDENTITY()
        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

/* =========================
   21) updateCoSoCheBienGo
   ========================= */
IF OBJECT_ID('updateCoSoCheBienGo') IS NOT NULL
    DROP PROC updateCoSoCheBienGo
GO

CREATE PROC updateCoSoCheBienGo
(
    @action INT,
    @CoSoId INT OUTPUT,
    @LoaiHinhSanXuatGoId INT = NULL,
    @HinhThucHoatDongGoId INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @action = -1
        BEGIN
            DELETE FROM CoSoCheBienGo WHERE CoSoId = @CoSoId
            COMMIT
            RETURN
        END

        IF @action = 0
        BEGIN
            UPDATE CoSoCheBienGo
            SET LoaiHinhSanXuatGoId = @LoaiHinhSanXuatGoId,
                HinhThucHoatDongGoId = @HinhThucHoatDongGoId
            WHERE CoSoId = @CoSoId
            COMMIT
            RETURN
        END

        INSERT INTO CoSoCheBienGo (CoSoId, LoaiHinhSanXuatGoId, HinhThucHoatDongGoId)
        VALUES (@CoSoId, @LoaiHinhSanXuatGoId, @HinhThucHoatDongGoId)

        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

/* =========================
   22) updateCoSoGiongCayTrong
   ========================= */
IF OBJECT_ID('updateCoSoGiongCayTrong') IS NOT NULL
    DROP PROC updateCoSoGiongCayTrong
GO

CREATE PROC updateCoSoGiongCayTrong
(
    @action INT,
    @CoSoId INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @action = -1
        BEGIN
            DELETE FROM CoSoGiongCayTrong WHERE CoSoId = @CoSoId
            COMMIT
            RETURN
        END

        IF @action = 1
        BEGIN
            INSERT INTO CoSoGiongCayTrong (CoSoId)
            VALUES (@CoSoId)
            COMMIT
            RETURN
        END

        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

/* =========================
   23) updateCoSoLuuGiuDongVat
   ========================= */
IF OBJECT_ID('updateCoSoLuuGiuDongVat') IS NOT NULL
    DROP PROC updateCoSoLuuGiuDongVat
GO

CREATE PROC updateCoSoLuuGiuDongVat
(
    @action INT,
    @CoSoId INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @action = -1
        BEGIN
            DELETE FROM CoSoLuuGiuDongVat WHERE CoSoId = @CoSoId
            COMMIT
            RETURN
        END

        IF @action = 1
        BEGIN
            INSERT INTO CoSoLuuGiuDongVat (CoSoId)
            VALUES (@CoSoId)
            COMMIT
            RETURN
        END

        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

/* =========================
   24) updateLoaiBienDong
   ========================= */
IF OBJECT_ID('updateLoaiBienDong') IS NOT NULL
    DROP PROC updateLoaiBienDong
GO

CREATE PROC updateLoaiBienDong
(
    @action INT,
    @Id INT OUTPUT,
    @Ten NVARCHAR(50) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @action = -1
        BEGIN
            DELETE FROM LoaiBienDong WHERE Id = @Id
            COMMIT
            RETURN
        END

        IF @action = 0
        BEGIN
            UPDATE LoaiBienDong
            SET Ten = @Ten
            WHERE Id = @Id
            COMMIT
            RETURN
        END

        INSERT INTO LoaiBienDong (Ten)
        VALUES (@Ten)

        SET @Id = SCOPE_IDENTITY()
        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

/* =========================
   25) updateTacDong
   ========================= */
IF OBJECT_ID('updateTacDong') IS NOT NULL
    DROP PROC updateTacDong
GO

CREATE PROC updateTacDong
(
    @action INT,
    @Id INT OUTPUT,
    @Ten NVARCHAR(50) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @action = -1
        BEGIN
            DELETE FROM TacDong WHERE Id = @Id
            COMMIT
            RETURN
        END

        IF @action = 0
        BEGIN
            UPDATE TacDong
            SET Ten = @Ten
            WHERE Id = @Id
            COMMIT
            RETURN
        END

        INSERT INTO TacDong (Ten)
        VALUES (@Ten)

        SET @Id = SCOPE_IDENTITY()
        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

/* =========================
   26) updateQuyenNhom
   ========================= */
IF OBJECT_ID('updateQuyenNhom') IS NOT NULL
    DROP PROC updateQuyenNhom
GO

CREATE PROC updateQuyenNhom
(
    @action INT,
    @GroupId INT = NULL,
    @TacDongId INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @action = -1
        BEGIN
            DELETE FROM QuyenNhom WHERE GroupId = @GroupId AND TacDongId = @TacDongId
            COMMIT
            RETURN
        END

        IF @action = 1
        BEGIN
            INSERT INTO QuyenNhom (GroupId, TacDongId)
            VALUES (@GroupId, @TacDongId)
            COMMIT
            RETURN
        END

        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

/* =========================
   27) updateNguoiDungTrongNhom
   ========================= */
IF OBJECT_ID('updateNguoiDungTrongNhom') IS NOT NULL
    DROP PROC updateNguoiDungTrongNhom
GO

CREATE PROC updateNguoiDungTrongNhom
(
    @action INT,
    @UserName VARCHAR(50) = NULL,
    @GroupId INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN

        IF @action = -1
        BEGIN
            DELETE FROM NguoiDungTrongNhom WHERE UserName = @UserName
            COMMIT
            RETURN
        END

        IF @action = 1
        BEGIN
            INSERT INTO NguoiDungTrongNhom (UserName, GroupId)
            VALUES (@UserName, @GroupId)
            COMMIT
            RETURN
        END

        COMMIT
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK
        THROW
    END CATCH
END
GO

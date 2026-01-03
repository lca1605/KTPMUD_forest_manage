USE KTPM;
GO

/* =========================
   1) HanhChinh (4 cấp)
   ========================= */
CREATE TABLE HanhChinh
( Id INT PRIMARY KEY IDENTITY
, Ten NVARCHAR(50) NOT NULL
, TrucThuocId INT NULL FOREIGN KEY REFERENCES HanhChinh(Id)
)
GO

-- Bật IDENTITY_INSERT để ép Id = 0 cho Việt Nam
SET IDENTITY_INSERT HanhChinh ON;
INSERT INTO HanhChinh (Id, Ten, TrucThuocId) VALUES (0, N'Việt Nam', NULL);
SET IDENTITY_INSERT HanhChinh OFF;
GO

-- Chèn các cấp hành chính (Identity tự tăng 1, 2, 3...)
INSERT INTO HanhChinh (Ten, TrucThuocId) VALUES
    (N'Tỉnh/Thành phố', 0),  -- Id 1: Trực thuộc Việt Nam (Id 0)
    (N'Quận/Huyện', 1),       -- Id 2: Trực thuộc Tỉnh (Id 1)
    (N'Phường/Xã', 2),        -- Id 3: Trực thuộc Huyện (Id 2)
    (N'Tổ/Thôn/Ấp', 3)        -- Id 4: Trực thuộc Xã (Id 3)
GO

CREATE TABLE TenHanhChinh (
    Ten NVARCHAR(50),
    HanhChinhId INT
);
GO

INSERT INTO TenHanhChinh VALUES 
(N'Tỉnh', 1), (N'Thành phố trực thuộc TW', 1),
(N'Quận', 2), (N'Huyện', 2), (N'Thị xã', 2), (N'Thành phố thuộc tỉnh', 2),
(N'Phường', 3), (N'Xã', 3), (N'Thị trấn', 3),
(N'Thôn', 4), (N'Tổ dân phố', 4), (N'Ấp', 4), (N'Bản', 4);
GO

CREATE TABLE DonVi
( Id INT PRIMARY KEY IDENTITY
, Ten NVARCHAR(50) NOT NULL
, HanhChinhId INT NOT NULL FOREIGN KEY REFERENCES HanhChinh(Id)
, TenHanhChinh NVARCHAR(50) NOT NULL
, TrucThuocId INT NULL FOREIGN KEY REFERENCES DonVi(Id)
)
GO

INSERT INTO DonVi VALUES
    (N'Hà Nội', 1, N'Thành phố', NULL),      -- Id = 1
    (N'Hai Bà Trưng', 2, N'Quận', 1),        -- Id = 2
    (N'Bách Khoa', 3, N'Phường', 2),         -- Id = 3
    (N'Đồng Tâm', 3, N'Phường', 2),          -- Id = 4
    (N'Thái Bình', 1, N'Tỉnh', NULL),        -- Id = 5
    (N'Thái Thụy', 2, N'Huyện', 5),          -- Id = 6
    (N'Thụy Hải', 3, N'Xã', 6),              -- Id = 7
    (N'Thụy Xuân', 3, N'Xã', 6)              -- Id = 8
GO

CREATE VIEW ViewDonVi AS
    SELECT T.*, DonVi.Ten AS TrucThuoc FROM
        (SELECT DonVi.*, HanhChinh.Ten AS Cap FROM DonVi 
        INNER JOIN HanhChinh ON HanhChinhId = HanhChinh.Id) AS T
    LEFT JOIN DonVi ON T.TrucThuocId = DonVi.Id
GO

/* =========================
   2) User
   ========================= */
CREATE TABLE HoSo
( Id INT PRIMARY KEY IDENTITY
, Ten NVARCHAR(50)
, SDT VARCHAR(50)
, Email VARCHAR(50)
, Ext TEXT
)
GO

INSERT INTO HoSo VALUES
    (N'Vũ Song Tùng', '0989154248', 'tung.vusong@hust.edu.vn', NULL),
    (N'Đào Lê Thu Thảo', '0989708960', 'thao.daolethu@hust.edu.vn', NULL)
GO

CREATE TABLE Quyen
( Id INT PRIMARY KEY IDENTITY
, Ten NVARCHAR(50)
, Ext VARCHAR(50)
)
GO

INSERT INTO Quyen VALUES
    (N'Lập trình viên', 'Developer'),
    (N'Quản trị hệ thống', 'Admin'),
    (N'Cán bộ nghiệp vụ', 'Staff')
GO

CREATE TABLE TaiKhoan
( TenDangNhap VARCHAR(50) PRIMARY KEY
, MatKhau VARCHAR(255) NOT NULL
, QuyenId INT NOT NULL FOREIGN KEY REFERENCES Quyen(Id)
, HoSoId INT NULL FOREIGN KEY REFERENCES HoSo(Id)
, LanCuoiHoatDong DATETIME NULL
, MaDonViId INT NULL FOREIGN KEY REFERENCES DonVi(Id)
)
GO

INSERT INTO TaiKhoan VALUES
    ('dev', '1234', 1, NULL, NULL, NULL),
    ('admin', '1234', 2, NULL, NULL, NULL),
    ('0989154248', '1234', 3, 1, NULL, NULL),
    ('0989708960', '1234', 3, 2, NULL, NULL),
    ('cb_hanoi', '123', 3, NULL, NULL, 1),
    ('cb_thaibinh', '123', 3, NULL, NULL, 5),
    ('cb_hbt_01', '123', 3, NULL, NULL, 2),
    ('cb_thaithuy', '123', 3, NULL, NULL, 6),
    ('cb_bk_01', '123', 3, NULL, NULL, 3),
    ('cb_bk_02', '123', 3, NULL, NULL, 3),
    ('cb_thuyhai', '123', 3, NULL, NULL, 7)
GO

CREATE VIEW ViewHoSo AS
    SELECT HoSo.*, TaiKhoan.TenDangNhap AS TenDangNhap, MatKhau, QuyenId, 
           Quyen.Ten AS Quyen, TaiKhoan.LanCuoiHoatDong 
    FROM TaiKhoan
    INNER JOIN Quyen ON QuyenId = Quyen.Id
    INNER JOIN HoSo ON HoSoId = HoSo.Id
GO

/* =========================
   3) NhomNguoiDung
   ========================= */
CREATE TABLE NhomNguoiDung
( Id INT PRIMARY KEY IDENTITY
, MaDonViId INT NOT NULL FOREIGN KEY REFERENCES DonVi(Id)
, TenNhom NVARCHAR(100) NOT NULL
)
GO

INSERT INTO NhomNguoiDung VALUES
    (1, N'Nhóm Thành phố Hà Nội'),
    (2, N'Nhóm Quận Hai Bà Trưng'),
    (3, N'Nhóm Phường Bách Khoa'),
    (5, N'Nhóm Tỉnh Thái Bình'),
    (6, N'Nhóm Huyện Thái Thụy'),
    (7, N'Nhóm Xã Thụy Hải')
GO

ALTER TABLE NhomNguoiDung
ADD CONSTRAINT UQ_NhomNguoiDung_MaDonVi UNIQUE (MaDonViId)
GO

CREATE TABLE NguoiDungTrongNhom
( UserName VARCHAR(50) NOT NULL FOREIGN KEY REFERENCES TaiKhoan(Ten)
, GroupId INT NOT NULL FOREIGN KEY REFERENCES NhomNguoiDung(Id)
, PRIMARY KEY (UserName, GroupId)
)
GO

ALTER TABLE NguoiDungTrongNhom
ADD CONSTRAINT UQ_NguoiDungTrongNhom_User UNIQUE (UserName)
GO

INSERT INTO NguoiDungTrongNhom VALUES
    ('cb_hanoi', 1),
    ('cb_hbt_01', 2),
    ('cb_bk_01', 3),
    ('cb_bk_02', 3),
    ('cb_thaibinh', 4),
    ('cb_thaithuy', 5),
    ('cb_thuyhai', 6)
GO

CREATE TABLE TacDong
( Id INT PRIMARY KEY IDENTITY
, Ten NVARCHAR(50) NOT NULL
)
GO

INSERT INTO TacDong VALUES
    (N'Xem'),
    (N'Thêm'),
    (N'Sửa'),
    (N'Xóa'),
    (N'Duyệt')
GO

CREATE TABLE QuyenNhom
( GroupId INT NOT NULL FOREIGN KEY REFERENCES NhomNguoiDung(Id)
, TacDongId INT NOT NULL FOREIGN KEY REFERENCES TacDong(Id)
, PRIMARY KEY (GroupId, TacDongId)
)
GO

-- Nhóm Tỉnh/Thành: full 1..5
INSERT INTO QuyenNhom VALUES
    (1,1),(1,2),(1,3),(1,4),(1,5),   -- Hà Nội
    (4,1),(4,2),(4,3),(4,4),(4,5)    -- Thái Bình
GO

-- Nhóm Huyện/Quận: full 1..5
INSERT INTO QuyenNhom VALUES
    (2,1),(2,2),(2,3),(2,4),(2,5),   -- Hai Bà Trưng
    (5,1),(5,2),(5,3),(5,4),(5,5)    -- Thái Thụy
GO

-- Nhóm Xã/Phường: 1..4 (không duyệt)
INSERT INTO QuyenNhom VALUES
    (3,1),(3,2),(3,3),(3,4),         -- Bách Khoa
    (6,1),(6,2),(6,3),(6,4)          -- Thụy Hải
GO

/* =========================
   LoaiKyBaoCao
   ========================= */
CREATE TABLE LoaiKyBaoCao
( Id INT PRIMARY KEY IDENTITY
, Ten NVARCHAR(20) NOT NULL
)
GO

INSERT INTO LoaiKyBaoCao VALUES
    (N'Tháng'),
    (N'Quý'),
    (N'Năm')
GO

/* =========================
   4) CoSo
   ========================= */
CREATE TABLE LoaiCoSo
( Id INT PRIMARY KEY IDENTITY
, Ten NVARCHAR(100) NOT NULL
)
GO

INSERT INTO LoaiCoSo VALUES
    (N'Cơ sở sản xuất giống cây trồng'),
    (N'Cơ sở chế biến gỗ'),
    (N'Cơ sở lưu giữ động vật')
GO

CREATE TABLE CoSo
( Id INT PRIMARY KEY IDENTITY
, DonViId INT NOT NULL FOREIGN KEY REFERENCES DonVi(Id)
, LoaiCoSoId INT NOT NULL FOREIGN KEY REFERENCES LoaiCoSo(Id)
, Ten NVARCHAR(150) NOT NULL
, DiaChi NVARCHAR(200) NULL
, SDT VARCHAR(20) NULL
, NguoiDaiDien NVARCHAR(100) NULL
)
GO

INSERT INTO CoSo VALUES
    (3, 1, N'Cơ sở Giống Bách Khoa 01', N'Bách Khoa, Hai Bà Trưng, Hà Nội', '0901000001', N'Đào Minh Phúc'),
    (4, 1, N'Cơ sở Giống Đồng Tâm 01', N'Đồng Tâm, Hai Bà Trưng, Hà Nội', '0901000002', N'Lê Quốc Anh'),
    (3, 2, N'Cơ sở Gỗ Bách Khoa 01', N'Bách Khoa, Hai Bà Trưng, Hà Nội', '0902000001', N'Nguyễn Văn Hùng'),
    (4, 2, N'Cơ sở Gỗ Đồng Tâm 01', N'Đồng Tâm, Hai Bà Trưng, Hà Nội', '0902000002', N'Trần Minh Đức'),
    (7, 3, N'Trạm Lưu Giữ Thụy Hải 01', N'Thụy Hải, Thái Thụy, Thái Bình', '0903000001', N'Phạm Thị Lan'),
    (4, 3, N'Điểm Lưu Giữ Đồng Tâm 01', N'Đồng Tâm, Hai Bà Trưng, Hà Nội', '0903000002', N'Hoàng Đức Long')
GO

CREATE VIEW ViewCoSo AS
    SELECT 
        CoSo.*,
        DonVi.Ten AS TenDonVi,
        LoaiCoSo.Ten AS TenLoaiCoSo
    FROM CoSo
    INNER JOIN DonVi ON CoSo.DonViId = DonVi.Id
    INNER JOIN LoaiCoSo ON CoSo.LoaiCoSoId = LoaiCoSo.Id
GO

/* =========================
   5) CoSoGiongCayTrong
   ========================= */

CREATE TABLE GiongCay
( Id INT PRIMARY KEY IDENTITY
, Ten NVARCHAR(50)
, Nguon NVARCHAR(255)
, MoTa NVARCHAR(200) NULL
)
GO

INSERT INTO GiongCay VALUES
    (N'Vải', N'Hải Dương'),
    (N'Nhãn', N'Hưng Yên'),
    (N'Mít', N'Nam Định'),
    (N'Dừa', N'Phú Xuyên'),
    (N'Keo lai', N'Giống keo phục vụ trồng rừng'),
    (N'Thong ma', N'Giống thông'),
    (N'Bach dan', N'Giống bạch đàn')
GO

CREATE TABLE CoSoGiong_LoaiGiong
( Id INT PRIMARY KEY IDENTITY
, CoSoId INT NOT NULL FOREIGN KEY REFERENCES CoSo(Id)
, LoaiGiongId INT NOT NULL FOREIGN KEY REFERENCES LoaiGiongCayTrong(Id)
, GhiChu NVARCHAR(200) NULL
)
GO

CREATE TABLE ThongKeCoSoGiong
( Id INT PRIMARY KEY IDENTITY
, CoSoId INT NOT NULL FOREIGN KEY REFERENCES CoSo(Id)
, LoaiKyBaoCaoId INT NOT NULL FOREIGN KEY REFERENCES LoaiKyBaoCao(Id)
, Nam INT NOT NULL
, KySo INT NULL
, GiaTriKy DECIMAL(18,2) NULL
, DienTich DECIMAL(18,2) NULL
, SanLuong DECIMAL(18,2) NULL
, GhiChu NVARCHAR(200) NULL
)
GO

INSERT INTO CoSoGiong_LoaiGiong VALUES
    (1, 1, N'Sản xuất theo mùa'),
    (1, 2, N'Ưu tiên dự án trồng rừng'),
    (2, 1, N'Keo lai là chủ lực'),
    (2, 3, N'Bổ sung bạch đàn')
GO

INSERT INTO ThongKeCoSoGiong VALUES
    (1, 1, 2025, 1, 50000000, 3.50, 20000, N'Tháng 1/2025'),
    (1, 1, 2025, 2, 55000000, 3.60, 22000, N'Tháng 2/2025'),
    (1, 1, 2025, 3, 60000000, 3.70, 24000, N'Tháng 3/2025'),
    (2, 1, 2025, 1, 40000000, 2.80, 16000, N'Tháng 1/2025'),
    (2, 1, 2025, 2, 42000000, 2.90, 17000, N'Tháng 2/2025'),
    (2, 1, 2025, 3, 45000000, 3.00, 18000, N'Tháng 3/2025'),
    (1, 2, 2025, 1, 165000000, 10.80, 66000, N'Tổng Q1/2025'),
    (2, 2, 2025, 1, 127000000, 8.70, 51000, N'Tổng Q1/2025'),
    (1, 3, 2024, NULL, 500000000, 40.00, 260000, N'Năm 2024'),
    (2, 3, 2024, NULL, 380000000, 32.00, 210000, N'Năm 2024')
GO

/* =========================
   6) CoSoGo
   ========================= */
   CREATE TABLE LoaiHinhSanXuatGo
( Id INT PRIMARY KEY IDENTITY
, Ten NVARCHAR(100) NOT NULL
, MoTa NVARCHAR(200) NULL
)
GO

CREATE TABLE HinhThucHoatDongGo
( Id INT PRIMARY KEY IDENTITY
, Ten NVARCHAR(100) NOT NULL
, MoTa NVARCHAR(200) NULL
)
GO

INSERT INTO LoaiHinhSanXuatGo VALUES
    (N'Cưa xẻ', N'Sản xuất/cưa xẻ gỗ nguyên liệu'),
    (N'Sản xuất đồ mộc', N'Gia công đồ mộc/nội thất'),
    (N'Ván ép', N'Sản xuất ván ép/ván công nghiệp')
GO

INSERT INTO HinhThucHoatDongGo VALUES
    (N'Hộ kinh doanh', N'Quy mô nhỏ'),
    (N'Doanh nghiệp', N'Quy mô doanh nghiệp'),
    (N'HTX', N'Hợp tác xã')
GO

CREATE TABLE CoSoCheBienGo
( CoSoId INT PRIMARY KEY FOREIGN KEY REFERENCES CoSo(Id)
, LoaiHinhSanXuatGoId INT NOT NULL FOREIGN KEY REFERENCES LoaiHinhSanXuatGo(Id)
, HinhThucHoatDongGoId INT NOT NULL FOREIGN KEY REFERENCES HinhThucHoatDongGo(Id)
)
GO

INSERT INTO CoSoCheBienGo VALUES
    (3, 2, 2),
    (4, 1, 1)
GO

CREATE TABLE ThongKeCoSoGo
( Id INT PRIMARY KEY IDENTITY
, CoSoId INT NOT NULL FOREIGN KEY REFERENCES CoSo(Id)
, LoaiKyBaoCaoId INT NOT NULL FOREIGN KEY REFERENCES LoaiKyBaoCao(Id)
, Nam INT NOT NULL
, KySo INT NULL
, GiaTriKy DECIMAL(18,2) NULL
, DienTich DECIMAL(18,2) NULL
, SanLuong DECIMAL(18,2) NULL
, GhiChu NVARCHAR(200) NULL
)
GO

INSERT INTO ThongKeCoSoGo VALUES
    (3, 1, 2025, 1, 70000000, 1.20, 35.00, N'Tháng 1/2025'),
    (3, 1, 2025, 2, 75000000, 1.20, 38.00, N'Tháng 2/2025'),
    (3, 1, 2025, 3, 80000000, 1.20, 40.00, N'Tháng 3/2025'),
    (4, 1, 2025, 1, 50000000, 0.80, 22.00, N'Tháng 1/2025'),
    (4, 1, 2025, 2, 52000000, 0.80, 23.00, N'Tháng 2/2025'),
    (4, 1, 2025, 3, 54000000, 0.80, 24.00, N'Tháng 3/2025'),
    (3, 2, 2025, 1, 225000000, 3.60, 113.00, N'Tổng Q1/2025'),
    (4, 2, 2025, 1, 156000000, 2.40, 69.00, N'Tổng Q1/2025'),
    (3, 3, 2024, NULL, 900000000, 12.00, 520.00, N'Năm 2024'),
    (4, 3, 2024, NULL, 650000000, 9.00, 410.00, N'Năm 2024')
GO

/* =========================
   7) CoSoDongVat
   ========================= */
CREATE TABLE LoaiDongVat
( Id INT PRIMARY KEY IDENTITY
, TenKhoaHoc NVARCHAR(150) NULL
, TenTiengViet NVARCHAR(150) NOT NULL
, NhomLoai NVARCHAR(100) NULL
, MucBaoTon NVARCHAR(100) NULL
)
GO

INSERT INTO LoaiDongVat VALUES
    (N'Nycticebus bengalensis', N'Cu li lon', N'Thu', N'Nguy cap'),
    (N'Macaca mulatta', N'Khi vang', N'Thu', N'It quan tam'),
    (N'Python molurus', N'Tran dat', N'Bo sat', N'Sap nguy cap')
GO

CREATE TABLE LoaiBienDong
( Id INT PRIMARY KEY IDENTITY
, Ten NVARCHAR(50) NOT NULL
)
GO

INSERT INTO LoaiBienDong VALUES
    (N'Tăng'),
    (N'Giảm'),
    (N'Tiếp nhận'),
    (N'Bàn giao')
GO

CREATE TABLE ThongKeSoLuongDongVat
( Id INT PRIMARY KEY IDENTITY
, CoSoId INT NOT NULL FOREIGN KEY REFERENCES CoSo(Id)
, LoaiDongVatId INT NOT NULL FOREIGN KEY REFERENCES LoaiDongVat(Id)
, LoaiKyBaoCaoId INT NOT NULL FOREIGN KEY REFERENCES LoaiKyBaoCao(Id)
, Nam INT NOT NULL
, KySo INT NULL
, GiaTriKy DECIMAL(18,2) NULL
, SoDauKy DECIMAL(18,2) NULL
, SoCuoiKy DECIMAL(18,2) NULL
, GhiChu NVARCHAR(200) NULL
)
GO

CREATE TABLE BienDongSoLuongDongVat
( Id INT PRIMARY KEY IDENTITY
, CoSoId INT NOT NULL FOREIGN KEY REFERENCES CoSo(Id)
, LoaiDongVatId INT NOT NULL FOREIGN KEY REFERENCES LoaiDongVat(Id)
, LoaiBienDongId INT NOT NULL FOREIGN KEY REFERENCES LoaiBienDong(Id)
, NgayBienDong DATE NOT NULL
, SoLuong DECIMAL(18,2) NOT NULL
, GhiChu NVARCHAR(200) NULL
)
GO

INSERT INTO ThongKeSoLuongDongVat VALUES
    (5, 1, 2, 2025, 1, NULL, 5, 6, N'Q1/2025 - Cu li (Thụy Hải)'),
    (5, 2, 2, 2025, 1, NULL, 10, 9, N'Q1/2025 - Khi vàng (Thụy Hải)'),
    (6, 3, 2, 2025, 1, NULL, 3, 4, N'Q1/2025 - Trăn đất (Đồng Tâm)')
GO

INSERT INTO BienDongSoLuongDongVat VALUES
    (5, 1, 3, '2025-02-10', 1, N'Tiếp nhận thêm 1 cá thể cu li'),
    (5, 2, 4, '2025-03-01', 1, N'Bàn giao/thả tự nhiên 1 cá thể'),
    (6, 3, 3, '2025-01-15', 2, N'Tiếp nhận 2 cá thể trăn đất')
GO
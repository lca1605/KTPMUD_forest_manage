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
( UserName VARCHAR(50) NOT NULL FOREIGN KEY REFERENCES TaiKhoan(TenDangNhap)
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
    (4, 3, N'Điểm Lưu Giữ Đồng Tâm 01', N'Đồng Tâm, Hai Bà Trưng, Hà Nội', '0903000002', N'Hoàng Đức Long'),
    (7, 1, N'Cơ sở Giống Thụy Hải 01', N'Thụy Hải, Thái Thụy, Thái Bình', '0901000003', N'Nguyễn Thị Mai'),
    (8, 1, N'Cơ sở Giống Thụy Xuân 01', N'Thụy Xuân, Thái Thụy, Thái Bình', '0901000004', N'Trần Văn Nam'),
    (3, 1, N'Cơ sở Giống Bách Khoa 02', N'Bách Khoa, Hai Bà Trưng, Hà Nội', '0901000005', N'Phạm Minh Tuấn'),
    (7, 2, N'Cơ sở Gỗ Thụy Hải 01', N'Thụy Hải, Thái Thụy, Thái Bình', '0902000003', N'Lê Văn Hải')
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
    (N'Bach dan', N'Giống bạch đàn'),
    (N'Sầu riêng', N'Đắk Lắk', N'Giống sầu riêng Monthong'),
    (N'Cam', N'Nghệ An', N'Giống cam Vinh'),
    (N'Xoài', N'Đồng Tháp', N'Giống xoài cát Hòa Lộc'),
    (N'Chôm chôm', N'Bến Tre', N'Giống chôm chôm nhập nội'),
    (N'Măng cụt', N'Cần Thơ', N'Giống măng cụt Thái Lan'),
    (N'Thanh long', N'Bình Thuận', N'Giống thanh long ruột đỏ'),
    (N'Ổi', N'Tiền Giang', N'Giống ổi Đài Loan'),
    (N'Mận', N'Lâm Đồng', N'Giống mận Hà Nội')
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
    (2, 3, N'Bổ sung bạch đàn'),
    (1, 3, N'Mít Thái cho năng suất cao'),
    (1, 4, N'Dừa xiêm ưa chuộng'),
    (2, 6, N'Thông mã vĩ cho vùng đồi núi'),
    (7, 1, N'Vải thiều xuất khẩu'),
    (7, 2, N'Nhãn lồng chất lượng'),
    (7, 8, N'Sầu riêng Monthong thử nghiệm'),
    (8, 9, N'Cam Vinh đặc sản'),
    (8, 10, N'Xoài Hòa Lộc'),
    (9, 11, N'Chôm chôm nhập nội'),
    (9, 12, N'Măng cụt Thái Lan')
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
    (2, 3, 2024, NULL, 380000000, 32.00, 210000, N'Năm 2024'),
    (1, 1, 2025, 1, 50000000, 3.50, 20000, N'Tháng 1/2025'),
    (1, 1, 2025, 2, 55000000, 3.60, 22000, N'Tháng 2/2025'),
    (1, 1, 2025, 3, 60000000, 3.70, 24000, N'Tháng 3/2025'),
    (1, 1, 2025, 4, 62000000, 3.75, 25000, N'Tháng 4/2025'),
    (1, 1, 2025, 5, 58000000, 3.65, 23000, N'Tháng 5/2025'),
    (1, 1, 2025, 6, 65000000, 3.80, 26000, N'Tháng 6/2025'),
    (1, 1, 2024, 1, 48000000, 3.40, 19000, N'Tháng 1/2024'),
    (1, 1, 2024, 2, 52000000, 3.50, 21000, N'Tháng 2/2024'),
    (1, 1, 2024, 3, 55000000, 3.60, 22500, N'Tháng 3/2024'),
    (1, 1, 2024, 4, 57000000, 3.65, 23500, N'Tháng 4/2024'),
    (1, 1, 2024, 5, 54000000, 3.55, 22000, N'Tháng 5/2024'),
    (1, 1, 2024, 6, 60000000, 3.70, 24500, N'Tháng 6/2024'),
    (1, 1, 2024, 7, 63000000, 3.75, 25500, N'Tháng 7/2024'),
    (1, 1, 2024, 8, 61000000, 3.72, 25000, N'Tháng 8/2024'),
    (1, 1, 2024, 9, 59000000, 3.68, 24000, N'Tháng 9/2024'),
    (1, 1, 2024, 10, 64000000, 3.78, 26000, N'Tháng 10/2024'),
    (1, 1, 2024, 11, 62000000, 3.74, 25500, N'Tháng 11/2024'),
    (1, 1, 2024, 12, 66000000, 3.82, 27000, N'Tháng 12/2024'),
    -- Cơ sở 2 - Tháng  
    (2, 1, 2025, 1, 40000000, 2.80, 16000, N'Tháng 1/2025'),
    (2, 1, 2025, 2, 42000000, 2.90, 17000, N'Tháng 2/2025'),
    (2, 1, 2025, 3, 45000000, 3.00, 18000, N'Tháng 3/2025'),
    (2, 1, 2025, 4, 46000000, 3.05, 18500, N'Tháng 4/2025'),
    (2, 1, 2025, 5, 44000000, 2.95, 17500, N'Tháng 5/2025'),
    (2, 1, 2025, 6, 48000000, 3.10, 19000, N'Tháng 6/2025'),
    (2, 1, 2024, 1, 38000000, 2.70, 15500, N'Tháng 1/2024'),
    (2, 1, 2024, 2, 40000000, 2.80, 16500, N'Tháng 2/2024'),
    (2, 1, 2024, 3, 42000000, 2.85, 17000, N'Tháng 3/2024'),
    (2, 1, 2024, 4, 43000000, 2.90, 17500, N'Tháng 4/2024'),
    (2, 1, 2024, 5, 41000000, 2.82, 16800, N'Tháng 5/2024'),
    (2, 1, 2024, 6, 45000000, 2.95, 18200, N'Tháng 6/2024'),
    (2, 1, 2024, 7, 46000000, 2.98, 18500, N'Tháng 7/2024'),
    (2, 1, 2024, 8, 44000000, 2.92, 18000, N'Tháng 8/2024'),
    (2, 1, 2024, 9, 43000000, 2.88, 17500, N'Tháng 9/2024'),
    (2, 1, 2024, 10, 47000000, 3.02, 19000, N'Tháng 10/2024'),
    (2, 1, 2024, 11, 45000000, 2.96, 18500, N'Tháng 11/2024'),
    (2, 1, 2024, 12, 49000000, 3.08, 19500, N'Tháng 12/2024'),
    -- Quý
    (1, 2, 2025, 1, 165000000, 10.80, 66000, N'Tổng Q1/2025'),
    (1, 2, 2025, 2, 185000000, 11.20, 74000, N'Tổng Q2/2025'),
    (1, 2, 2024, 1, 155000000, 10.50, 62500, N'Tổng Q1/2024'),
    (1, 2, 2024, 2, 171000000, 10.90, 70000, N'Tổng Q2/2024'),
    (1, 2, 2024, 3, 183000000, 11.15, 74500, N'Tổng Q3/2024'),
    (1, 2, 2024, 4, 192000000, 11.34, 78500, N'Tổng Q4/2024'),
    (2, 2, 2025, 1, 127000000, 8.70, 51000, N'Tổng Q1/2025'),
    (2, 2, 2025, 2, 138000000, 9.10, 55000, N'Tổng Q2/2025'),
    (2, 2, 2024, 1, 120000000, 8.35, 49000, N'Tổng Q1/2024'),
    (2, 2, 2024, 2, 129000000, 8.67, 52700, N'Tổng Q2/2024'),
    (2, 2, 2024, 3, 133000000, 8.78, 54000, N'Tổng Q3/2024'),
    (2, 2, 2024, 4, 141000000, 9.06, 57000, N'Tổng Q4/2024'),
    -- Năm
    (1, 3, 2024, NULL, 701000000, 43.89, 285500, N'Năm 2024'),
    (2, 3, 2024, NULL, 523000000, 34.86, 212700, N'Năm 2024'),
    (1, 3, 2023, NULL, 680000000, 42.50, 275000, N'Năm 2023'),
    (2, 3, 2023, NULL, 500000000, 33.50, 205000, N'Năm 2023'),
    -- Cơ sở 7 - THÊM MỚI
    (7, 1, 2025, 1, 35000000, 2.50, 14000, N'Tháng 1/2025'),
    (7, 1, 2025, 2, 38000000, 2.60, 15000, N'Tháng 2/2025'),
    (7, 1, 2025, 3, 40000000, 2.70, 16000, N'Tháng 3/2025'),
    (7, 2, 2025, 1, 113000000, 7.80, 45000, N'Tổng Q1/2025'),
    (7, 3, 2024, NULL, 420000000, 30.00, 170000, N'Năm 2024'),
    -- Cơ sở 8 - THÊM MỚI
    (8, 1, 2025, 1, 30000000, 2.20, 12000, N'Tháng 1/2025'),
    (8, 1, 2025, 2, 32000000, 2.30, 13000, N'Tháng 2/2025'),
    (8, 1, 2025, 3, 35000000, 2.40, 14000, N'Tháng 3/2025'),
    (8, 2, 2025, 1, 97000000, 6.90, 39000, N'Tổng Q1/2025'),
    (8, 3, 2024, NULL, 380000000, 28.00, 155000, N'Năm 2024')
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

/* =========================
   8) User Activity History (Lịch sử hoạt động)
   ========================= */
CREATE TABLE UserActivityLog
( Id INT PRIMARY KEY IDENTITY
, TenDangNhap VARCHAR(50) NOT NULL FOREIGN KEY REFERENCES TaiKhoan(TenDangNhap)
, HanhDong NVARCHAR(100) NOT NULL
, ChucNang NVARCHAR(100) NULL
, ThoiGian DATETIME NOT NULL DEFAULT GETDATE()
, DiaChi NVARCHAR(200) NULL
, GhiChu NVARCHAR(500) NULL
)
GO

CREATE VIEW ViewUserActivityLog AS
    SELECT 
        UserActivityLog.*,
        HoSo.Ten AS TenNguoiDung,
        Quyen.Ten AS LoaiQuyen
    FROM UserActivityLog
    INNER JOIN TaiKhoan ON UserActivityLog.TenDangNhap = TaiKhoan.TenDangNhap
    LEFT JOIN HoSo ON TaiKhoan.HoSoId = HoSo.Id
    INNER JOIN Quyen ON TaiKhoan.QuyenId = Quyen.Id
GO

-- Thêm dữ liệu mẫu
INSERT INTO UserActivityLog (TenDangNhap, HanhDong, ChucNang, ThoiGian, GhiChu) VALUES
    ('admin', N'Đăng nhập', N'Hệ thống', '2025-01-04 08:00:00', N'Đăng nhập thành công'),
    ('admin', N'Xem danh sách', N'Quản lý cơ sở', '2025-01-04 08:05:00', N'Xem danh sách cơ sở giống'),
    ('cb_bk_01', N'Đăng nhập', N'Hệ thống', '2025-01-04 09:00:00', N'Đăng nhập thành công'),
    ('cb_bk_01', N'Thêm mới', N'Quản lý cơ sở', '2025-01-04 09:10:00', N'Thêm cơ sở mới'),
    ('cb_bk_02', N'Sửa', N'Quản lý cơ sở', '2025-01-04 10:00:00', N'Cập nhật thông tin cơ sở')
GO

/* =========================
   9) User Groups - Bổ sung View
   ========================= */
CREATE VIEW ViewNhomNguoiDung AS
    SELECT 
        NhomNguoiDung.*,
        DonVi.Ten AS TenDonVi,
        DonVi.TenHanhChinh AS CapDonVi
    FROM NhomNguoiDung
    INNER JOIN DonVi ON NhomNguoiDung.MaDonViId = DonVi.Id
GO

CREATE VIEW ViewNguoiDungTrongNhom AS
    SELECT 
        NguoiDungTrongNhom.*,
        NhomNguoiDung.TenNhom,
        HoSo.Ten AS TenNguoiDung,
        TaiKhoan.QuyenId,
        Quyen.Ten AS TenQuyen
    FROM NguoiDungTrongNhom
    INNER JOIN NhomNguoiDung ON NguoiDungTrongNhom.GroupId = NhomNguoiDung.Id
    INNER JOIN TaiKhoan ON NguoiDungTrongNhom.UserName = TaiKhoan.TenDangNhap
    LEFT JOIN HoSo ON TaiKhoan.HoSoId = HoSo.Id
    INNER JOIN Quyen ON TaiKhoan.QuyenId = Quyen.Id
GO

/* =========================
   Lịch sử đăng nhập
   ========================= */
CREATE TABLE LichSuDangNhap
( Id INT PRIMARY KEY IDENTITY
, Ten VARCHAR(50) NOT NULL
, ThoiGian DATETIME NOT NULL DEFAULT GETDATE()
, TrangThai NVARCHAR(50) NULL
, GhiChu NVARCHAR(500) NULL
)
GO

INSERT INTO LichSuDangNhap (Ten, ThoiGian, TrangThai, GhiChu) VALUES
    ('admin', '2025-01-04 08:00:00', N'Thành công', NULL),
    ('cb_bk_01', '2025-01-04 09:00:00', N'Thành công', NULL),
    ('cb_bk_02', '2025-01-04 09:30:00', N'Thất bại', N'Sai mật khẩu')
GO

CREATE VIEW ViewLichSuDangNhap AS
    SELECT LichSuDangNhap.*, HoSo.Ten AS TenNguoiDung
    FROM LichSuDangNhap
    LEFT JOIN HoSo ON LichSuDangNhap.Ten = HoSo.SDT
GO

/* =========================
   Lịch sử tác động
   ========================= */
CREATE TABLE LichSuTacDong
( Id INT PRIMARY KEY IDENTITY
, Ten VARCHAR(50) NOT NULL
, HanhDong NVARCHAR(100) NOT NULL
, ChucNang NVARCHAR(100) NULL
, ThoiGian DATETIME NOT NULL DEFAULT GETDATE()
, GhiChu NVARCHAR(500) NULL
)
GO

INSERT INTO LichSuTacDong (Ten, HanhDong, ChucNang, ThoiGian, GhiChu) VALUES
    ('admin', N'Xem', N'Quản lý cơ sở', '2025-01-04 08:05:00', NULL),
    ('cb_bk_01', N'Thêm', N'Quản lý cơ sở', '2025-01-04 09:10:00', N'Thêm cơ sở mới'),
    ('cb_bk_02', N'Sửa', N'Quản lý cơ sở', '2025-01-04 10:00:00', NULL)
GO

CREATE VIEW ViewLichSuTacDong AS
    SELECT LichSuTacDong.*, HoSo.Ten AS TenNguoiDung
    FROM LichSuTacDong
    LEFT JOIN HoSo ON LichSuTacDong.Ten = HoSo.SDT
GO
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

CREATE TABLE DiaChi
( Id INT PRIMARY KEY IDENTITY
, DiaChiDayDu NVARCHAR(200) NULL
, Lat DECIMAL(9,6) NULL
, Lng DECIMAL(9,6) NULL
, CONSTRAINT CK_DiaChi_Lat CHECK (Lat IS NULL OR (Lat BETWEEN -90 AND 90))
, CONSTRAINT CK_DiaChi_Lng CHECK (Lng IS NULL OR (Lng BETWEEN -180 AND 180))
)
GO

CREATE TABLE CoSo
( Id INT PRIMARY KEY IDENTITY
, DonViId INT NOT NULL FOREIGN KEY REFERENCES DonVi(Id)
, LoaiCoSoId INT NOT NULL FOREIGN KEY REFERENCES LoaiCoSo(Id)
, Ten NVARCHAR(150) NOT NULL
, DiaChiId INT NULL FOREIGN KEY REFERENCES DiaChi(Id)
, SDT VARCHAR(20) NULL
, NguoiDaiDien NVARCHAR(100) NULL
)
GO

/* Seed: tạo DiaChi trước rồi gán FK cho CoSo */
INSERT INTO DiaChi (DiaChiDayDu, Lat, Lng) VALUES
    (N'Bách Khoa, Hai Bà Trưng, Hà Nội', NULL, NULL),
    (N'Đồng Tâm, Hai Bà Trưng, Hà Nội', NULL, NULL),
    (N'Thụy Hải, Thái Thụy, Thái Bình', NULL, NULL),
    (N'Thụy Xuân, Thái Thụy, Thái Bình', NULL, NULL)
GO

INSERT INTO CoSo (DonViId, LoaiCoSoId, Ten, DiaChiId, SDT, NguoiDaiDien)
SELECT 3, 1, N'Cơ sở Giống Bách Khoa 01', d.Id, '0901000001', N'Đào Minh Phúc' FROM DiaChi d WHERE d.DiaChiDayDu = N'Bách Khoa, Hai Bà Trưng, Hà Nội'
UNION ALL SELECT 4, 1, N'Cơ sở Giống Đồng Tâm 01', d.Id, '0901000002', N'Lê Quốc Anh' FROM DiaChi d WHERE d.DiaChiDayDu = N'Đồng Tâm, Hai Bà Trưng, Hà Nội'
UNION ALL SELECT 3, 2, N'Cơ sở Gỗ Bách Khoa 01', d.Id, '0902000001', N'Nguyễn Văn Hùng' FROM DiaChi d WHERE d.DiaChiDayDu = N'Bách Khoa, Hai Bà Trưng, Hà Nội'
UNION ALL SELECT 4, 2, N'Cơ sở Gỗ Đồng Tâm 01', d.Id, '0902000002', N'Trần Minh Đức' FROM DiaChi d WHERE d.DiaChiDayDu = N'Đồng Tâm, Hai Bà Trưng, Hà Nội'
UNION ALL SELECT 7, 3, N'Trạm Lưu Giữ Thụy Hải 01', d.Id, '0903000001', N'Phạm Thị Lan' FROM DiaChi d WHERE d.DiaChiDayDu = N'Thụy Hải, Thái Thụy, Thái Bình'
UNION ALL SELECT 4, 3, N'Điểm Lưu Giữ Đồng Tâm 01', d.Id, '0903000002', N'Hoàng Đức Long' FROM DiaChi d WHERE d.DiaChiDayDu = N'Đồng Tâm, Hai Bà Trưng, Hà Nội'
UNION ALL SELECT 7, 1, N'Cơ sở Giống Thụy Hải 01', d.Id, '0901000003', N'Nguyễn Thị Mai' FROM DiaChi d WHERE d.DiaChiDayDu = N'Thụy Hải, Thái Thụy, Thái Bình'
UNION ALL SELECT 8, 1, N'Cơ sở Giống Thụy Xuân 01', d.Id, '0901000004', N'Trần Văn Nam' FROM DiaChi d WHERE d.DiaChiDayDu = N'Thụy Xuân, Thái Thụy, Thái Bình'
UNION ALL SELECT 3, 1, N'Cơ sở Giống Bách Khoa 02', d.Id, '0901000005', N'Phạm Minh Tuấn' FROM DiaChi d WHERE d.DiaChiDayDu = N'Bách Khoa, Hai Bà Trưng, Hà Nội'
UNION ALL SELECT 7, 2, N'Cơ sở Gỗ Thụy Hải 01', d.Id, '0902000003', N'Lê Văn Hải' FROM DiaChi d WHERE d.DiaChiDayDu = N'Thụy Hải, Thái Thụy, Thái Bình'
GO

CREATE VIEW ViewCoSo AS
    SELECT 
        CoSo.Id,
        CoSo.DonViId,
        CoSo.LoaiCoSoId,
        CoSo.Ten,
        CoSo.DiaChiId,
        DiaChi.DiaChiDayDu AS DiaChi,
        CAST(DiaChi.Lat AS FLOAT) AS Lat,
        CAST(DiaChi.Lng AS FLOAT) AS Lng,
        CoSo.SDT,
        CoSo.NguoiDaiDien,
        DonVi.Ten AS TenDonVi,
        LoaiCoSo.Ten AS TenLoaiCoSo
    FROM CoSo
    INNER JOIN DonVi ON CoSo.DonViId = DonVi.Id
    INNER JOIN LoaiCoSo ON CoSo.LoaiCoSoId = LoaiCoSo.Id
    LEFT JOIN DiaChi ON CoSo.DiaChiId = DiaChi.Id
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
    (N'Vải', N'Hải Dương', N'Giống vải thiều chất lượng cao'),
    (N'Nhãn', N'Hưng Yên', N'Giống nhãn lồng'),
    (N'Mít', N'Nam Định', N'Giống mít Thái'),
    (N'Dừa', N'Phú Xuyên', N'Giống dừa xiêm'),
    (N'Keo lai', N'Giống keo phục vụ trồng rừng', N'Năng suất cao'),
    (N'Thông mã vĩ', N'Giống thông', N'Thích hợp vùng núi'),
    (N'Bạch đàn', N'Giống bạch đàn', N'Phát triển nhanh'),
    -- THÊM DỮ LIỆU MỚI
    (N'Sầu riêng', N'Đắk Lắk', N'Giống sầu riêng Monthong'),
    (N'Cam', N'Nghệ An', N'Giống cam Vinh'),
    (N'Xoài', N'Đồng Tháp', N'Giống xoài cát Hòa Lộc'),
    (N'Chôm chôm', N'Bến Tre', N'Giống chôm chôm nhập nội'),
    (N'Măng cụt', N'Cần Thơ', N'Giống măng cụt Thái Lan'),
    (N'Thanh long', N'Bình Thuận', N'Giống thanh long ruột đỏ'),
    (N'Ổi', N'Tiền Giang', N'Giống ổi Đài Loan'),
    (N'Mận', N'Lâm Đồng', N'Giống mận Hà Nội')
GO

CREATE TABLE CoSoGiongLoaiGiong
( Id INT PRIMARY KEY IDENTITY
, CoSoId INT NOT NULL FOREIGN KEY REFERENCES CoSo(Id) ON DELETE CASCADE
, LoaiGiongId INT NOT NULL FOREIGN KEY REFERENCES GiongCay(Id)
, GhiChu NVARCHAR(200) NULL
)
GO

INSERT INTO CoSoGiongLoaiGiong VALUES
    (1, 1, N'Sản xuất theo mùa'),
    (1, 2, N'Ưu tiên dự án trồng rừng'),
    (2, 5, N'Keo lai là chủ lực'),
    (2, 7, N'Bổ sung bạch đàn'),
    -- THÊM DỮ LIỆU MỚI
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

CREATE TABLE ThongKeCoSoGiong
( Id INT PRIMARY KEY IDENTITY
, CoSoId INT NOT NULL FOREIGN KEY REFERENCES CoSo(Id) ON DELETE CASCADE
, LoaiKyBaoCaoId INT NOT NULL FOREIGN KEY REFERENCES LoaiKyBaoCao(Id)
, Nam INT NOT NULL
, KySo INT NULL
, GiaTriKy DECIMAL(18,2) NULL
, DienTich DECIMAL(18,2) NULL
, SanLuong DECIMAL(18,2) NULL
, GhiChu NVARCHAR(200) NULL
)
GO

INSERT INTO ThongKeCoSoGiong VALUES
    -- Cơ sở 1 - Tháng
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
    (8, 3, 2024, NULL, 380000000, 28.00, 155000, N'Năm 2024'),
    -- Cơ sở 9 - THÊM MỚI
    (9, 1, 2025, 1, 45000000, 3.20, 18000, N'Tháng 1/2025'),
    (9, 1, 2025, 2, 48000000, 3.30, 19000, N'Tháng 2/2025'),
    (9, 1, 2025, 3, 50000000, 3.40, 20000, N'Tháng 3/2025'),
    (9, 2, 2025, 1, 143000000, 9.90, 57000, N'Tổng Q1/2025'),
    (9, 3, 2024, NULL, 550000000, 38.00, 220000, N'Năm 2024')
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
( CoSoId INT PRIMARY KEY FOREIGN KEY REFERENCES CoSo(Id) ON DELETE CASCADE
, LoaiHinhSanXuatGoId INT NOT NULL FOREIGN KEY REFERENCES LoaiHinhSanXuatGo(Id)
, HinhThucHoatDongGoId INT NOT NULL FOREIGN KEY REFERENCES HinhThucHoatDongGo(Id)
)
GO

INSERT INTO CoSoCheBienGo VALUES
    (3, 2, 2),
    (4, 1, 1),
    (10, 2, 2) -- THÊM MỚI
GO

CREATE TABLE ThongKeCoSoGo
( Id INT PRIMARY KEY IDENTITY
, CoSoId INT NOT NULL FOREIGN KEY REFERENCES CoSo(Id) ON DELETE CASCADE
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
    -- Cơ sở 3 - Tháng
    (3, 1, 2025, 1, 70000000, 1.20, 35.00, N'Tháng 1/2025'),
    (3, 1, 2025, 2, 75000000, 1.20, 38.00, N'Tháng 2/2025'),
    (3, 1, 2025, 3, 80000000, 1.20, 40.00, N'Tháng 3/2025'),
    (3, 1, 2025, 4, 78000000, 1.20, 39.00, N'Tháng 4/2025'),
    (3, 1, 2025, 5, 82000000, 1.20, 41.00, N'Tháng 5/2025'),
    (3, 1, 2025, 6, 85000000, 1.20, 43.00, N'Tháng 6/2025'),
    (3, 1, 2024, 1, 68000000, 1.20, 34.00, N'Tháng 1/2024'),
    (3, 1, 2024, 2, 72000000, 1.20, 36.00, N'Tháng 2/2024'),
    (3, 1, 2024, 3, 75000000, 1.20, 37.50, N'Tháng 3/2024'),
    (3, 1, 2024, 4, 74000000, 1.20, 37.00, N'Tháng 4/2024'),
    (3, 1, 2024, 5, 78000000, 1.20, 39.00, N'Tháng 5/2024'),
    (3, 1, 2024, 6, 80000000, 1.20, 40.00, N'Tháng 6/2024'),
    (3, 1, 2024, 7, 82000000, 1.20, 41.00, N'Tháng 7/2024'),
    (3, 1, 2024, 8, 79000000, 1.20, 39.50, N'Tháng 8/2024'),
    (3, 1, 2024, 9, 77000000, 1.20, 38.50, N'Tháng 9/2024'),
    (3, 1, 2024, 10, 83000000, 1.20, 41.50, N'Tháng 10/2024'),
    (3, 1, 2024, 11, 81000000, 1.20, 40.50, N'Tháng 11/2024'),
    (3, 1, 2024, 12, 86000000, 1.20, 43.00, N'Tháng 12/2024'),
    -- Cơ sở 4 - Tháng
    (4, 1, 2025, 1, 50000000, 0.80, 22.00, N'Tháng 1/2025'),
    (4, 1, 2025, 2, 52000000, 0.80, 23.00, N'Tháng 2/2025'),
    (4, 1, 2025, 3, 54000000, 0.80, 24.00, N'Tháng 3/2025'),
    (4, 1, 2025, 4, 53000000, 0.80, 23.50, N'Tháng 4/2025'),
    (4, 1, 2025, 5, 56000000, 0.80, 25.00, N'Tháng 5/2025'),
    (4, 1, 2025, 6, 58000000, 0.80, 26.00, N'Tháng 6/2025'),
    (4, 1, 2024, 1, 48000000, 0.80, 21.00, N'Tháng 1/2024'),
    (4, 1, 2024, 2, 50000000, 0.80, 22.00, N'Tháng 2/2024'),
    (4, 1, 2024, 3, 52000000, 0.80, 23.00, N'Tháng 3/2024'),
    (4, 1, 2024, 4, 51000000, 0.80, 22.50, N'Tháng 4/2024'),
    (4, 1, 2024, 5, 54000000, 0.80, 24.00, N'Tháng 5/2024'),
    (4, 1, 2024, 6, 56000000, 0.80, 25.00, N'Tháng 6/2024'),
    (4, 1, 2024, 7, 57000000, 0.80, 25.50, N'Tháng 7/2024'),
    (4, 1, 2024, 8, 55000000, 0.80, 24.50, N'Tháng 8/2024'),
    (4, 1, 2024, 9, 53000000, 0.80, 23.50, N'Tháng 9/2024'),
    (4, 1, 2024, 10, 58000000, 0.80, 26.00, N'Tháng 10/2024'),
    (4, 1, 2024, 11, 56000000, 0.80, 25.00, N'Tháng 11/2024'),
    (4, 1, 2024, 12, 60000000, 0.80, 27.00, N'Tháng 12/2024'),
    -- Quý
    (3, 2, 2025, 1, 225000000, 3.60, 113.00, N'Tổng Q1/2025'),
    (3, 2, 2025, 2, 245000000, 3.60, 123.00, N'Tổng Q2/2025'),
    (3, 2, 2024, 1, 215000000, 3.60, 107.50, N'Tổng Q1/2024'),
    (3, 2, 2024, 2, 232000000, 3.60, 116.00, N'Tổng Q2/2024'),
    (3, 2, 2024, 3, 238000000, 3.60, 119.00, N'Tổng Q3/2024'),
    (3, 2, 2024, 4, 250000000, 3.60, 125.00, N'Tổng Q4/2024'),
    (4, 2, 2025, 1, 156000000, 2.40, 69.00, N'Tổng Q1/2025'),
    (4, 2, 2025, 2, 167000000, 2.40, 74.50, N'Tổng Q2/2025'),
    (4, 2, 2024, 1, 150000000, 2.40, 66.00, N'Tổng Q1/2024'),
    (4, 2, 2024, 2, 161000000, 2.40, 71.50, N'Tổng Q2/2024'),
    (4, 2, 2024, 3, 165000000, 2.40, 73.50, N'Tổng Q3/2024'),
    (4, 2, 2024, 4, 174000000, 2.40, 78.00, N'Tổng Q4/2024'),
    -- Năm
    (3, 3, 2024, NULL, 935000000, 14.40, 467.50, N'Năm 2024'),
    (4, 3, 2024, NULL, 650000000, 9.60, 289.00, N'Năm 2024'),
    (3, 3, 2023, NULL, 880000000, 14.40, 440.00, N'Năm 2023'),
    (4, 3, 2023, NULL, 610000000, 9.60, 270.00, N'Năm 2023'),
    -- Cơ sở 10 - THÊM MỚI
    (10, 1, 2025, 1, 60000000, 1.00, 28.00, N'Tháng 1/2025'),
    (10, 1, 2025, 2, 63000000, 1.00, 30.00, N'Tháng 2/2025'),
    (10, 1, 2025, 3, 65000000, 1.00, 31.00, N'Tháng 3/2025'),
    (10, 2, 2025, 1, 188000000, 3.00, 89.00, N'Tổng Q1/2025'),
    (10, 3, 2024, NULL, 720000000, 12.00, 340.00, N'Năm 2024')
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

CREATE TABLE CoSoDongVatLoaiDongVat
( Id INT PRIMARY KEY IDENTITY
, CoSoId INT NOT NULL FOREIGN KEY REFERENCES CoSo(Id) ON DELETE CASCADE
, LoaiDongVatId INT NOT NULL FOREIGN KEY REFERENCES LoaiDongVat(Id)
, GhiChu NVARCHAR(200) NULL
)
GO

CREATE TABLE ThongKeSoLuongDongVat
( Id INT PRIMARY KEY IDENTITY
, CoSoDongVatLoaiDongVatId INT NOT NULL FOREIGN KEY REFERENCES CoSoDongVatLoaiDongVat(Id)
, LoaiKyBaoCaoId INT NOT NULL FOREIGN KEY REFERENCES LoaiKyBaoCao(Id)
, Nam INT NOT NULL
, KySo INT NULL
, SoLuongLoai INT NULL
, GhiChu NVARCHAR(200) NULL
, TenLoai NVARCHAR(150) NULL
)
GO

INSERT INTO LoaiDongVat VALUES
    (N'Nycticebus bengalensis', N'Culi lớn', N'Thú', N'Nguy cấp'),
    (N'Macaca mulatta', N'Khỉ vàng', N'Thú', N'Ít quan tâm'),
    (N'Python molurus', N'Trăn đất', N'Bò sát', N'Sắp nguy cấp'),
    (N'Panthera tigris', N'Hổ', N'Thú', N'Cực kỳ nguy cấp'),
    (N'Ursus thibetanus', N'Gấu ngựa', N'Thú', N'Nguy cấp'),
    (N'Elephas maximus', N'Voi châu Á', N'Thú', N'Nguy cấp'),
    (N'Nomascus gabriellae', N'Vượn má vàng', N'Thú', N'Nguy cấp'),
    (N'Varanus salvator', N'Kỳ đà nước', N'Bò sát', N'Ít quan tâm'),
    (N'Crocodylus siamensis', N'Cá sấu Xiêm', N'Bò sát', N'Cực kỳ nguy cấp'),
    (N'Cuora galbinifrons', N'Rùa núi vàng', N'Bò sát', N'Cực kỳ nguy cấp'),
    (N'Manis javanica', N'Tê tê vảy', N'Thú', N'Cực kỳ nguy cấp'),
    (N'Pseudoryx nghetinhensis', N'Sao la', N'Thú', N'Cực kỳ nguy cấp')
GO

INSERT INTO CoSoDongVatLoaiDongVat VALUES
    (5, 1, Null),
    (5, 2, Null),
    (5, 4, Null),
    (5, 5, Null),
    (6, 3, Null),
    (6, 8, Null),
    (6, 9, Null),
    (6, 10, Null)
GO

-- DỮ LIỆU THỐNG KÊ (CoSoId, LoaiDongVatId, LoaiKyBaoCaoId, Nam, KySo, SoLuongLoai, GhiChu)
INSERT INTO ThongKeSoLuongDongVat VALUES
    -- === CƠ SỞ 5 (Trạm Lưu Giữ Thụy Hải) ===
    -- Culi lớn (LoaiDongVatId: 1)
    (1, 1, 2024, 1, 20, N'Tháng 1/2024', 'Culi lớn'),
    (1, 1, 2024, 2, 30, N'Tháng 2/2024', 'Culi lớn'),
    (1, 1, 2024, 3, 30, N'Tháng 3/2024', 'Culi lớn'),
    (1, 1, 2024, 4, 32, N'Tháng 4/2024', 'Culi lớn'),
    (1, 1, 2024, 5, 30, N'Tháng 5/2024', 'Culi lớn'),
    (1, 1, 2024, 6, 29, N'Tháng 6/2024', 'Culi lớn'),
    (1, 1, 2024, 7, 30, N'Tháng 7/2024', 'Culi lớn'),
    (1, 1, 2024, 8, 31, N'Tháng 8/2024', 'Culi lớn'),
    (1, 1, 2024, 9, 22, N'Tháng 9/2024', 'Culi lớn'),
    (1, 1, 2024, 10, 25, N'Tháng 10/2024', 'Culi lớn'),
    (1, 1, 2024, 11, 25, N'Tháng 11/2024', 'Culi lớn'),
    (1, 1, 2024, 12, 25, N'Tháng 12/2024', 'Culi lớn'),

    -- Khỉ vàng (LoaiDongVatId: 2)
    (2, 1, 2024, 1, 10, N'Tháng 1/2024', 'Khỉ vàng'),
    (2, 1, 2024, 2, 10, N'Tháng 2/2024', 'Khỉ vàng'),
    (2, 1, 2024, 3, 11, N'Tháng 3/2024', 'Khỉ vàng'),
    (2, 1, 2024, 4, 11, N'Tháng 4/2024', 'Khỉ vàng'),
    (2, 1, 2024, 5, 11, N'Tháng 5/2024', 'Khỉ vàng'),
    (2, 1, 2024, 6, 11, N'Tháng 6/2024', 'Khỉ vàng'),
    (2, 1, 2024, 7, 11, N'Tháng 7/2024', 'Khỉ vàng'),
    (2, 1, 2024, 8, 11, N'Tháng 8/2024', 'Khỉ vàng'),
    (2, 1, 2024, 9, 11, N'Tháng 9/2024', 'Khỉ vàng'),
    (2, 1, 2024, 10, 11, N'Tháng 10/2024', 'Khỉ vàng'),
    (2, 1, 2024, 11, 10, N'Tháng 11/2024', 'Khỉ vàng'),
    (2, 1, 2024, 12, 10, N'Tháng 12/2024', 'Khỉ vàng'),

    -- Hổ (LoaiDongVatId: 4)
    (3, 1, 2024, 1, 2, N'Tháng 1/2024', 'Hổ'),
    (3, 1, 2024, 6, 3, N'Tháng 6/2024', 'Hổ'),
    (3, 1, 2024, 12, 3, N'Tháng 12/2024', 'Hổ'),

    -- Gấu ngựa (LoaiDongVatId: 5)
    (4, 1, 2024, 1, 5, N'Tháng 1/2024', 'Gấu ngựa'),
    (4, 1, 2024, 6, 5, N'Tháng 6/2024', 'Gấu ngựa'),
    (4, 1, 2024, 12, 4, N'Tháng 12/2024', 'Gấu ngựa'),

    -- === CƠ SỞ 6 (Điểm Lưu Giữ Đồng Tâm) ===
    -- Trăn đất (LoaiDongVatId: 3)
    (5, 1, 2024, 1, 15, N'Tháng 1/2024', 'Trăn đất'),
    (5, 1, 2024, 6, 18, N'Tháng 6/2024', 'Trăn đất'),
    (5, 1, 2024, 12, 20, N'Tháng 12/2024', 'Trăn đất'),

    -- Kỳ đà nước (LoaiDongVatId: 8)
    (6, 1, 2024, 1, 40, N'Tháng 1/2024', 'Kỳ đà nước'),
    (6, 1, 2024, 6, 45, N'Tháng 6/2024', 'Kỳ đà nước'),
    (6, 1, 2024, 12, 42, N'Tháng 12/2024', 'Kỳ đà nước'),

    -- Cá sấu Xiêm (LoaiDongVatId: 9)
    (7, 1, 2024, 1, 12, N'Tháng 1/2024', 'Cá sấu Xiêm'),
    (7, 1, 2024, 6, 12, N'Tháng 6/2024', 'Cá sấu Xiêm'),
    (7, 1, 2024, 12, 15, N'Tháng 12/2024', 'Cá sấu Xiêm'),

    -- Rùa núi vàng (LoaiDongVatId: 10)
    (8, 1, 2024, 1, 50, N'Tháng 1/2024', 'Rùa núi vàng'),
    (8, 1, 2024, 6, 55, N'Tháng 6/2024', 'Rùa núi vàng'),
    (8, 1, 2024, 12, 60, N'Tháng 12/2024', 'Rùa núi vàng')
GO

/* =========================
   8) Lich Su Thao Tac Nguoi Dung
   ========================= */
CREATE TABLE TacDong
( Id INT PRIMARY KEY IDENTITY
, Ma NVARCHAR(50) NOT NULL
)
GO

INSERT INTO TacDong VALUES
    (N'INSERT'),
    (N'DELETE'),
    (N'UPDATE')
GO

CREATE TABLE LichSuTacDong
( Id INT PRIMARY KEY IDENTITY
, TenTaiKhoan NVARCHAR(100) NOT NULL
, TacDongId INT NOT NULL FOREIGN KEY REFERENCES TacDong(Id)
, ThoiGian DATETIME NOT NULL DEFAULT GETDATE()
, MoTa NVARCHAR(300) NULL
)
GO
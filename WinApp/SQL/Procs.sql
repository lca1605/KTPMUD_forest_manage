use KTPM
go

if object_id('updateDonVi') is not null
    drop proc updateDonVi
go

create proc updateDonVi
(
    @action int,              -- -1: delete | 0: update | 1: insert
    @Id int output,
    @Ten nvarchar(50) = null,
    @HanhChinhId int = null,
    @TenHanhChinh nvarchar(50) = null,
    @TrucThuocId int = null
)
as
begin
    set nocount on;

    begin try
        begin tran

        -- DELETE
        if @action = -1
        begin
            delete from DonVi where Id = @Id
            commit
            return
        end

        -- UPDATE
        if @action = 0
        begin
            update DonVi
            set Ten = @Ten,
                HanhChinhId = @HanhChinhId,
                TenHanhChinh = @TenHanhChinh,
                TrucThuocId = @TrucThuocId
            where Id = @Id

            commit
            return
        end

        -- INSERT
        insert into DonVi (Ten, HanhChinhId, TenHanhChinh, TrucThuocId)
        values (@Ten, @HanhChinhId, @TenHanhChinh, @TrucThuocId)

        set @Id = scope_identity()

        commit
    end try
    begin catch
        if @@trancount > 0 rollback
        throw
    end catch
end
go


if object_id('updateHoSo') is not null
    drop proc updateHoSo
go

create proc updateHoSo
(
    @action int,                  -- -1: delete | 0: update | 1: insert
    @Id int output,               -- HoSo.Id
    @TenDangNhap varchar(50),
    @Ten nvarchar(50) = null,
    @SDT varchar(50) = null,
    @Email varchar(50) = null,
    @Ext text = null,
    @MatKhau varchar(255) = null,
    @QuyenId int = null
)
as
begin
    set nocount on;

    begin try
        begin tran

        -- DELETE
        if @action = -1
        begin
            delete from TaiKhoan where Ten = @TenDangNhap
            delete from HoSo where Id = @Id
            commit
            return
        end

        -- UPDATE HoSo
        if @action = 0
        begin
            update HoSo
            set Ten = @Ten,
                SDT = @SDT,
                Email = @Email,
                Ext = @Ext
            where Id = @Id

            commit
            return
        end

        -- INSERT
        if exists (select 1 from TaiKhoan where Ten = @TenDangNhap)
        begin
            raiserror (N'Tài khoản đã tồn tại', 16, 1)
        end

        insert into HoSo (Ten, SDT, Email, Ext)
        values (@Ten, @SDT, @Email, @Ext)

        set @Id = scope_identity()

        insert into TaiKhoan (Ten, MatKhau, QuyenId, HoSoId)
        values (@TenDangNhap, @MatKhau, @QuyenId, @Id)

        commit
    end try
    begin catch
        if @@trancount > 0 rollback
        throw
    end catch
end
go


if object_id('changePass') is not null
    drop proc changePass
go

create proc changePass
(
    @Ten varchar(50),
    @MatKhau varchar(255)
)
as
begin
    update TaiKhoan
    set MatKhau = @MatKhau
    where Ten = @Ten
end
go

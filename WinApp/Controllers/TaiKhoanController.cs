using Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WinApp.Controllers
{
    partial class TaiKhoanController
    {
        protected override ViewHoSo CreateEntity()
        {
            return new ViewHoSo { QuyenId = 3 };
        }

        protected override void UpdateCore(ViewHoSo e)
        {
            if (string.IsNullOrWhiteSpace(e.TenDangNhap))
                e.TenDangNhap = e.SDT;

            base.UpdateCore(e);
        }

        DataSchema.Table HoSoDb => Provider.GetTable<HoSo>();
        DataSchema.Table TaiKhoanDb => Provider.GetTable<TaiKhoan>();
        protected override string GetProcName() => null;
        protected override void TryInsert(ViewHoSo e)
        {
            if (TaiKhoanDb.GetValueById("HoSoId", e.TenDangNhap) != null)
            {
                UpdateContext.Message = "Đã có người dùng " + e.TenDangNhap;
                return;
            }

            var sql = HoSoDb.CreateInsertSql(e);
            ExecSQL(sql);
            
            var acc = new TaiKhoan {
                TenDangNhap = e.TenDangNhap,
                MatKhau = "1234",
                QuyenId = e.QuyenId,
                HoSoId = HoSoDb.GetIdentity(),
            };
            sql = TaiKhoanDb.CreateInsertSql(acc);
            ExecSQL(sql);

        }
        protected override void TryUpdate(ViewHoSo e)
        {
            ExecSQL(HoSoDb.CreateUpdateSql(e));
        }
        protected override void TryDelete(ViewHoSo e)
        {
            ExecSQL(TaiKhoanDb.CreateDeleteSql(new TaiKhoan { TenDangNhap = e.TenDangNhap }));

            ExecSQL(HoSoDb.CreateDeleteSql(e));
        }
    }
}

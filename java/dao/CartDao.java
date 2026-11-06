package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class CartDao {
    public boolean taoDonHang(int maND, int maXe, int soLuong, double totalGia) {
        String sqlDH = "INSERT INTO DonHang (MaND, NgayDat, TongTien, TienDatCoc, TrangThai) VALUES (?, GETDATE(), ?, ?, N'Chờ xử lý')";
        String sqlCT = "INSERT INTO ChiTietDonHang (MaDH, MaXe, SoLuong, GiaBan) VALUES (?, ?, ?, ?)";
        String sqlCoc = "INSERT INTO DatCoc (MaDH, SoTienCoc, YeuCauHoanCoc) VALUES (?, ?, 0)";

        double tienDatCoc = totalGia * 0.35;

        try (Connection conn = DBContext.getConnection()) {
            conn.setAutoCommit(false);
            
            try (PreparedStatement psDH = conn.prepareStatement(sqlDH, Statement.RETURN_GENERATED_KEYS)) {
                psDH.setInt(1, maND);
                psDH.setDouble(2, totalGia);
                psDH.setDouble(3, tienDatCoc);
                psDH.executeUpdate();
                
                ResultSet rs = psDH.getGeneratedKeys();
                int maDH = 0;
                if (rs.next()) maDH = rs.getInt(1);

                try (PreparedStatement psCT = conn.prepareStatement(sqlCT)) {
                    psCT.setInt(1, maDH);
                    psCT.setInt(2, maXe);
                    psCT.setInt(3, soLuong);
                    psCT.setDouble(4, totalGia / soLuong);
                    psCT.executeUpdate();
                }

                try (PreparedStatement psCoc = conn.prepareStatement(sqlCoc)) {
                    psCoc.setInt(1, maDH);
                    psCoc.setDouble(2, tienDatCoc);
                    psCoc.executeUpdate();
                }

                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}

package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.PhieuTuVan;

public class EmployeeDao {

    public List<PhieuTuVan> getAllPhieuTuVan() {
        List<PhieuTuVan> list = new ArrayList<>();

        String sql = "SELECT ptv.*, s.Gia " +
                     "FROM PhieuTuVan ptv " +
                     "LEFT JOIN SanPham s ON ptv.DongXeQuanTam = s.TenXe " +
                     "ORDER BY ptv.NgayGui DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                PhieuTuVan p = new PhieuTuVan();
                p.setMaPTV(rs.getInt("MaPTV"));
                p.setHoTenKhachHang(rs.getString("HoTenKhachHang"));
                p.setSdt(rs.getString("SDT"));
                p.setEmail(rs.getString("Email"));
                p.setDongXeQuanTam(rs.getString("DongXeQuanTam"));
                p.setMaNhanVien(rs.getInt("MaNhanVien"));
                p.setTrangThai(rs.getString("TrangThai"));
                p.setNgayGui(rs.getTimestamp("NgayGui"));
                p.setGhiChu(rs.getString("GhiChu"));
                
                try {
                    p.setGia(rs.getDouble("Gia"));
                } catch (Exception e) {
                }
                
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateTrangThai(int maPTV, String trangThai) {
        String sqlPTV = "UPDATE PhieuTuVan SET TrangThai = ? WHERE MaPTV = ?";
        String sqlDH = "UPDATE DonHang SET TrangThai = ? WHERE MaDH = ?";
        
        try (Connection conn = DBContext.getConnection()) {

            try (PreparedStatement ps1 = conn.prepareStatement(sqlPTV)) {
                ps1.setString(1, trangThai);
                ps1.setInt(2, maPTV);
                ps1.executeUpdate();
            }
      
            try (PreparedStatement ps2 = conn.prepareStatement(sqlDH)) {
                ps2.setString(1, trangThai);
                ps2.setInt(2, maPTV);
                ps2.executeUpdate();
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
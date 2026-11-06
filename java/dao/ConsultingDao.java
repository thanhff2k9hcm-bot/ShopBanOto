package dao;

import model.Consulting;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ConsultingDao {
    
    public boolean guiYeuCauVoiTenXe(String hoTen, String sdt, String email, String tenXe, String noiDung, int maNhanVienMacDinh) {
        String sql = "INSERT INTO PhieuTuVan (HoTenKhachHang, SDT, Email, DongXeQuanTam, MaNhanVien, TrangThai, GhiChu) VALUES (?, ?, ?, ?, ?, N'Chờ xử lý', ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hoTen);
            ps.setString(2, sdt);
            ps.setString(3, email);
            ps.setString(4, (tenXe != null && !tenXe.trim().isEmpty() ? tenXe : "Tư vấn chung"));
            ps.setInt(5, maNhanVienMacDinh);
            ps.setString(6, noiDung);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean guiYeuCauVoiGia(String hoTen, String sdt, String email, String tenXeVaSL, String ghiChu, double gia, int maND) {
        String sql = "INSERT INTO PhieuTuVan (HoTenKhachHang, SDT, Email, DongXeQuanTam, MaNhanVien, TrangThai, GhiChu) VALUES (?, ?, ?, ?, 1, N'Chờ xử lý', ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hoTen);
            ps.setString(2, sdt);
            ps.setString(3, email);
            ps.setString(4, tenXeVaSL);
            ps.setString(5, ghiChu + " - Giá trị: " + gia);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    public List<Consulting> getAllConsulting() {
        List<Consulting> list = new ArrayList<>();
        String sql = "SELECT * FROM PhieuTuVan ORDER BY MaPTV DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Consulting c = new Consulting();
                c.setMaTV(rs.getInt("MaPTV"));
                c.setMaPTV(rs.getInt("MaPTV")); // Cầu nối alias
                c.setHoTen(rs.getString("HoTenKhachHang"));
                c.setSdt(rs.getString("SDT"));
                c.setEmail(rs.getString("Email"));
                c.setTenXe(rs.getString("DongXeQuanTam"));
                c.setMaNhanVien(rs.getInt("MaNhanVien"));
                c.setTrangThai(rs.getString("TrangThai"));
                
                try {
                    c.setNgayGui(rs.getString("NgayGui"));
                } catch (Exception ex) {
                    c.setNgayGui("");
                }
                
                String ghiChu = rs.getString("GhiChu");
                c.setGhiChu(ghiChu != null ? ghiChu : "");
                
                double gia = 0;
                if (ghiChu != null && ghiChu.contains("Giá trị:")) {
                    try {
                        int idx = ghiChu.indexOf("Giá trị:");
                        String giaStr = ghiChu.substring(idx + 8).trim();
                        if (giaStr.contains(" ")) {
                            giaStr = giaStr.split(" ")[0];
                        }
                        gia = Double.parseDouble(giaStr);
                    } catch (Exception ex) {
                        gia = 0;
                    }
                }
                c.setTienGoc(gia);
                

                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(int maPTV, String trangThai) {
        String sql = "UPDATE PhieuTuVan SET TrangThai = ? WHERE MaPTV = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, trangThai);
            ps.setInt(2, maPTV);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean insertHoanCoc(int maDH, String trangThaiHoan, String chiTiet) {
        String sql = "INSERT INTO HoanCoc (MaDH, TrangThaiHoan, NgayThucHien, ThongBaoChoNhanVien, ThucHienBoSuDung, ChiTiet) VALUES (?, ?, GETDATE(), N'Đã xác nhận hủy cọc bởi Admin', N'Admin hệ thống', ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maDH);
            ps.setString(2, trangThaiHoan);
            ps.setString(3, chiTiet);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
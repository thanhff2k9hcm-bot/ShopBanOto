package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Cart;
import model.Product;

public class AdminDao {

    public int getTongSoSanPham(String[] brandList) {
        String sql = "SELECT SUM(SoLuongTon) FROM SanPham";
        boolean filter = (brandList != null && brandList.length > 0);
        if (filter) {
            sql += " WHERE HangXe IN (";
            for (int i = 0; i < brandList.length; i++) {
                sql += (i == 0) ? "?" : ", ?";
            }
            sql += ")";
        }
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (filter) {
                for (int i = 0; i < brandList.length; i++) {
                    ps.setString(i + 1, brandList[i]);
                }
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTongLoaiXe(String[] brandList) {
        String sql = "SELECT COUNT(*) FROM SanPham";
        boolean filter = (brandList != null && brandList.length > 0);
        if (filter) {
            sql += " WHERE HangXe IN (";
            for (int i = 0; i < brandList.length; i++) {
                sql += (i == 0) ? "?" : ", ?";
            }
            sql += ")";
        }
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (filter) {
                for (int i = 0; i < brandList.length; i++) {
                    ps.setString(i + 1, brandList[i]);
                }
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getSoLuongConHang() {
        String sql = "SELECT COUNT(*) FROM SanPham WHERE SoLuongTon > 0";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int getSoLuongHetHang() {
        String sql = "SELECT COUNT(*) FROM SanPham WHERE SoLuongTon <= 0";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean themXeMoi(String tenXe, String hangXe, double gia, int soLuongTon, String hinhAnh) {
        String sql = "INSERT INTO SanPham (TenXe, HangXe, Gia, SoLuongTon, HinhAnhDaiDien) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tenXe);
            ps.setString(2, hangXe);
            ps.setDouble(3, gia);
            ps.setInt(4, soLuongTon);
            ps.setString(5, hinhAnh);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean xoaSanPham(int maXe) {
        String sql = "DELETE FROM SanPham WHERE MaXe = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maXe);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean suaSanPham(int maXe, String tenXe, String hangXe, double gia, int soLuongTon, String hinhAnh) {
        String sql = "UPDATE SanPham SET TenXe = ?, HangXe = ?, Gia = ?, SoLuongTon = ?, HinhAnhDaiDien = ? WHERE MaXe = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tenXe);
            ps.setString(2, hangXe);
            ps.setDouble(3, gia);
            ps.setInt(4, soLuongTon);
            ps.setString(5, hinhAnh);
            ps.setInt(6, maXe);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Cart> getAllOrders(String keyword) {
        return searchOrders(keyword, "ALL");
    }

    public List<Cart> searchOrders(String keyword, String statusFilter) {
        List<Cart> list = new ArrayList<>();
        String sql = "SELECT dh.MaDH, dh.MaND, dh.NgayDat, dh.TongTien, dh.TienDatCoc, dh.TrangThai, " +
                     "nd.HoTen AS TenKhachHang, nd.SDT, s.TenXe, s.Gia " +
                     "FROM DonHang dh " +
                     "JOIN NguoiDung nd ON dh.MaND = nd.MaND " +
                     "JOIN ChiTietDonHang ctdh ON dh.MaDH = ctdh.MaDH " +
                     "JOIN SanPham s ON ctdh.MaXe = s.MaXe WHERE 1=1";
        
        boolean hasKeyword = (keyword != null && !keyword.trim().isEmpty());
        boolean hasStatus = (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equals("ALL"));

        if (hasKeyword) {
            sql += " AND (nd.HoTen LIKE ? OR nd.SDT LIKE ?)";
        }
        if (hasStatus) {
            sql += " AND dh.TrangThai = ?";
        }
        sql += " ORDER BY dh.MaDH DESC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            if (hasKeyword) {
                ps.setString(idx++, "%" + keyword.trim() + "%");
                ps.setString(idx++, "%" + keyword.trim() + "%");
            }
            if (hasStatus) {
                ps.setString(idx++, statusFilter.trim());
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Cart c = new Cart();
                    c.setMaDH(rs.getInt("MaDH"));
                    c.setTenKhachHang(rs.getString("TenKhachHang"));
                    c.setSdt(rs.getString("SDT"));
                    c.setTienDatCoc(rs.getDouble("TienDatCoc"));
                    c.setTenXe(rs.getString("TenXe"));
                    c.setGia(rs.getDouble("Gia"));
                    c.setTrangThai(rs.getString("TrangThai"));
                    list.add(c);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateOrderStatus(int maDH, String trangThai) {
        String sql = "UPDATE DonHang SET TrangThai = ? WHERE MaDH = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, trangThai);
            ps.setInt(2, maDH);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Product> getProductsByHang(String[] brandList) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM SanPham";
        boolean filter = (brandList != null && brandList.length > 0);
        if (filter) {
            sql += " WHERE HangXe IN (";
            for (int i = 0; i < brandList.length; i++) {
                sql += (i == 0) ? "?" : ", ?";
            }
            sql += ")";
        }
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (filter) {
                for (int i = 0; i < brandList.length; i++) {
                    ps.setString(i + 1, brandList[i]);
                }
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setMaXe(rs.getInt("MaXe"));
                    p.setTenXe(rs.getString("TenXe"));
                    p.setHangXe(rs.getString("HangXe"));
                    p.setGia(rs.getDouble("Gia"));
                    p.setSoLuongTon(rs.getInt("SoLuongTon"));
                    p.setHinhAnhDaiDien(rs.getString("HinhAnhDaiDien"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<String> getAllBrands() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT HangXe FROM SanPham WHERE HangXe IS NOT NULL";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("HangXe"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

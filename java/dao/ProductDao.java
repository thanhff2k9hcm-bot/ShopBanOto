package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Cart;
import model.Product;

public class ProductDao {


    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM SanPham";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getProductsFiltered(String[] brandList, double minPrice, double maxPrice) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM SanPham WHERE 1=1");
        
        boolean hasBrand = (brandList != null && brandList.length > 0 && !brandList[0].isEmpty());
        if (hasBrand) {
            sql.append(" AND HangXe = ?");
        }
        if (minPrice >= 0) {
            sql.append(" AND Gia >= ?");
        }
        if (maxPrice >= 0) {
            sql.append(" AND Gia <= ?");
        }

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int index = 1;
            if (hasBrand) {
                ps.setString(index++, brandList[0]);
            }
            if (minPrice >= 0) {
                ps.setDouble(index++, minPrice);
            }
            if (maxPrice >= 0) {
                ps.setDouble(index++, maxPrice);
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

    public Product getProductById(int maXe) {
        String sql = "SELECT * FROM SanPham WHERE MaXe = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maXe);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product p = new Product();
                    p.setMaXe(rs.getInt("MaXe"));
                    p.setTenXe(rs.getString("TenXe"));
                    p.setHangXe(rs.getString("HangXe"));
                    p.setGia(rs.getDouble("Gia"));
                    p.setSoLuongTon(rs.getInt("SoLuongTon"));
                    p.setHinhAnhDaiDien(rs.getString("HinhAnhDaiDien"));
                    return p;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
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

    public List<Cart> getOrdersByUserId(int maND) {
        List<Cart> list = new ArrayList<>();
        String sql = "SELECT dh.*, nd.HoTen AS TenKhachHang, nd.SDT, s.TenXe, s.Gia " +
                     "FROM DonHang dh " +
                     "JOIN NguoiDung nd ON dh.MaND = nd.MaND " +
                     "JOIN ChiTietDonHang ctdh ON dh.MaDH = ctdh.MaDH " +
                     "JOIN SanPham s ON ctdh.MaXe = s.MaXe " +
                     "WHERE dh.MaND = ? ORDER BY dh.MaDH DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, maND);
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


    public boolean insertOrder(int maND, int maXe, int soLuong, double totalGia, String hoTen, String sdt) {
        String sqlDH = "INSERT INTO DonHang (MaND, NgayDat, TongTien, TienDatCoc, TrangThai) VALUES (?, GETDATE(), ?, ?, N'Chờ xử lý')";
        String sqlCT = "INSERT INTO ChiTietDonHang (MaDH, MaXe, SoLuong, GiaBan) VALUES (?, ?, ?, ?)";
        String sqlCoc = "INSERT INTO DatCoc (MaDH, SoTienCoc, YeuCauHoanCoc) VALUES (?, ?, 0)";

        double tienDatCoc = totalGia * 0.35;

        try (Connection conn = DBContext.getConnection()) {
            conn.setAutoCommit(false);
            
            try (PreparedStatement psDH = conn.prepareStatement(sqlDH, PreparedStatement.RETURN_GENERATED_KEYS)) {
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
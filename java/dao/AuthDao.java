package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Auth;

public class AuthDao {

    public Auth checkLogin(String loginInput, String matKhau) {
        String sql = "SELECT * FROM NguoiDung WHERE (TenDangNhap = ? OR Email = ?) AND MatKhau = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String input = loginInput != null ? loginInput.trim() : "";
            ps.setString(1, input);
            ps.setString(2, input);
            ps.setString(3, matKhau != null ? matKhau.trim() : "");
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Auth(
                        rs.getInt("MaND"),
                        rs.getString("TenDangNhap"),
                        rs.getString("MatKhau"),
                        rs.getString("HoTen"),
                        rs.getString("Email"),
                        rs.getString("SDT"),
                        rs.getString("VaiTro")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); 
        }
        return null;
    }

    public boolean register(String tenDangNhap, String matKhau, String hoTen, String email, String sdt) {
        String sql = "INSERT INTO NguoiDung (TenDangNhap, MatKhau, HoTen, Email, SDT, VaiTro) VALUES (?, ?, ?, ?, ?, 'Customer')";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tenDangNhap);
            ps.setString(2, matKhau);
            ps.setString(3, hoTen);
            ps.setString(4, email);
            ps.setString(5, sdt);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean checkDuplicateEmailOrPhone(String email, String sdt, int currentMaND) {
        String sql = "SELECT * FROM NguoiDung WHERE (Email = ? OR SDT = ?) AND MaND != ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, sdt);
            ps.setInt(3, currentMaND);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}

package model;

import java.util.Date;

public class PhieuTuVan {
    private int maPTV;
    private String hoTenKhachHang;
    private String sdt;
    private String email;
    private String dongXeQuanTam;
    private int maNhanVien;
    private String trangThai;
    private Date ngayGui;
    private String ghiChu;
    private Integer maHoanCoc;
    private double gia;

    public PhieuTuVan() {}

    public int getMaPTV() { return maPTV; }
    public void setMaPTV(int maPTV) { this.maPTV = maPTV; }
    

    public int getMaTV() { return maPTV; }
    public void setMaTV(int maTV) { this.maPTV = maTV; }
    
    public String getHoTenKhachHang() { return hoTenKhachHang; }
    public void setHoTenKhachHang(String hoTenKhachHang) { this.hoTenKhachHang = hoTenKhachHang; }
    
    public String getHoTen() { return hoTenKhachHang; }
    public void setHoTen(String hoTen) { this.hoTenKhachHang = hoTen; }
    
    public String getSdt() { return sdt; }
    public void setSdt(String sdt) { this.sdt = sdt; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getDongXeQuanTam() { return dongXeQuanTam; }
    public void setDongXeQuanTam(String dongXeQuanTam) { this.dongXeQuanTam = dongXeQuanTam; }

    public String getTenXe() { return dongXeQuanTam; }
    public void setTenXe(String tenXe) { this.dongXeQuanTam = tenXe; }
    
    public int getMaNhanVien() { return maNhanVien; }
    public void setMaNhanVien(int maNhanVien) { this.maNhanVien = maNhanVien; }
    
    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }
    
    public Date getNgayGui() { return ngayGui; }
    public void setNgayGui(Date ngayGui) { this.ngayGui = ngayGui; }
    
    public String getGhiChu() { return ghiChu; }
    public void setGhiChu(String ghiChu) { this.ghiChu = ghiChu; }
    
    public Integer getMaHoanCoc() { return maHoanCoc; }
    public void setMaHoanCoc(Integer maHoanCoc) { this.maHoanCoc = maHoanCoc; }

    public double getGia() { return gia; }
    public void setGia(double gia) { this.gia = gia; }
    
    public double getTienGoc() { return gia; }
    public void setTienGoc(double tienGoc) { this.gia = tienGoc; }
}
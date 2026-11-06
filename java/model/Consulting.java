package model;

public class Consulting {
    private int maTV;
    private String hoTen;
    private String sdt;
    private String email;
    private String tenXe;
    private int maNhanVien;
    private String trangThai;
    private String ngayGui;
    private String ghiChu;
    private double tienGoc;

    public Consulting() {
    }

    public Consulting(int maTV, String hoTen, String sdt, String email, String tenXe, int maNhanVien, String trangThai, String ngayGui, String ghiChu) {
        this.maTV = maTV;
        this.hoTen = hoTen;
        this.sdt = sdt;
        this.email = email;
        this.tenXe = tenXe;
        this.maNhanVien = maNhanVien;
        this.trangThai = trangThai;
        this.ngayGui = ngayGui;
        this.ghiChu = ghiChu;
    }

    public int getMaTV() {
        return maTV;
    }

    public void setMaTV(int maTV) {
        this.maTV = maTV;
    }

    public int getMaPTV() {
        return maTV;
    }

    public void setMaPTV(int maPTV) {
        this.maTV = maPTV;
    }

    public String getHoTen() {
        return hoTen;
    }

    public void setHoTen(String hoTen) {
        this.hoTen = hoTen;
    }

    public String getSdt() {
        return sdt;
    }

    public void setSdt(String sdt) {
        this.sdt = sdt;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTenXe() {
        return tenXe;
    }

    public void setTenXe(String tenXe) {
        this.tenXe = tenXe;
    }

    public int getMaNhanVien() {
        return maNhanVien;
    }

    public void setMaNhanVien(int maNhanVien) {
        this.maNhanVien = maNhanVien;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public String getNgayGui() {
        return ngayGui;
    }

    public void setNgayGui(String ngayGui) {
        this.ngayGui = ngayGui;
    }

    public void setNgayGui(java.sql.Timestamp ngayGui) {
        if (ngayGui != null) {
            this.ngayGui = ngayGui.toString();
        } else {
            this.ngayGui = "";
        }
    }

    public String getGhiChu() {
        return ghiChu;
    }

    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }

    public double getTienGoc() {
        return tienGoc;
    }

    public void setTienGoc(double tienGoc) {
        this.tienGoc = tienGoc;
    }
}
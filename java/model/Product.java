package model;

public class Product {
    private int maXe;
    private String tenXe;
    private String hangXe;
    private double gia;
    private int soLuongTon;
    private String hinhAnhDaiDien;

    public Product() {}

    public Product(int maXe, String tenXe, String hangXe, double gia, int soLuongTon, String hinhAnhDaiDien) {
        this.maXe = maXe;
        this.tenXe = tenXe;
        this.hangXe = hangXe;
        this.gia = gia;
        this.soLuongTon = soLuongTon;
        this.hinhAnhDaiDien = hinhAnhDaiDien;
    }

    public int getMaXe() { return maXe; }
    public void setMaXe(int maXe) { this.maXe = maXe; }
    public String getTenXe() { return tenXe; }
    public void setTenXe(String tenXe) { this.tenXe = tenXe; }
    public String getHangXe() { return hangXe; }
    public void setHangXe(String hangXe) { this.hangXe = hangXe; }
    public double getGia() { return gia; }
    public void setGia(double gia) { this.gia = gia; }
    public int getSoLuongTon() { return soLuongTon; }
    public void setSoLuongTon(int soLuongTon) { this.soLuongTon = soLuongTon; }
    public String getHinhAnhDaiDien() { return hinhAnhDaiDien; }
    public void setHinhAnhDaiDien(String hinhAnhDaiDien) { this.hinhAnhDaiDien = hinhAnhDaiDien; }
}

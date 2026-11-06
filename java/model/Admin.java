package model;

public class Admin {
    private int maND;
    private String tenDangNhap;
    private String hoTen;
    private String email;

    public Admin() {}

    public Admin(int maND, String tenDangNhap, String hoTen, String email) {
        this.maND = maND;
        this.tenDangNhap = tenDangNhap;
        this.hoTen = hoTen;
        this.email = email;
    }

    public int getMaND() { return maND; }
    public void setMaND(int maND) { this.maND = maND; }
    public String getTenDangNhap() { return tenDangNhap; }
    public void setTenDangNhap(String tenDangNhap) { this.tenDangNhap = tenDangNhap; }
    public String getHoTen() { return hoTen; }
    public void setHoTen(String hoTen) { this.hoTen = hoTen; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}

package model;

public class Employee {
    private int maND;
    private String tenDangNhap;
    private String matKhau;
    private String hoTen;
    private String email;
    private String sdt;
    private String vaiTro;

    public Employee() {}

    public Employee(int maND, String tenDangNhap, String matKhau, String hoTen, String email, String sdt, String vaiTro) {
        this.maND = maND;
        this.tenDangNhap = tenDangNhap;
        this.matKhau = matKhau;
        this.hoTen = hoTen;
        this.email = email;
        this.sdt = sdt;
        this.vaiTro = vaiTro;
    }

    public int getMaND() { return maND; }
    public void setMaND(int maND) { this.maND = maND; }
    
    public String getTenDangNhap() { return tenDangNhap; }
    public void setTenDangNhap(String tenDangNhap) { this.tenDangNhap = tenDangNhap; }
    
    public String getMatKhau() { return matKhau; }
    public void setMatKhau(String matKhau) { this.matKhau = matKhau; }
    
    public String getHoTen() { return hoTen; }
    public void setHoTen(String hoTen) { this.hoTen = hoTen; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getSdt() { return sdt; }
    public void setSdt(String sdt) { this.sdt = sdt; }
    
    public String getVaiTro() { return vaiTro; }
    public void setVaiTro(String vaiTro) { this.vaiTro = vaiTro; }
}
package model;

public class Cart {
    private int maDH;
    private String tenKhachHang;
    private String sdt;
    private String diaChi;
    private double tienDatCoc;
    private String tenXe;
    private double gia;
    private String trangThai; // <-- Đã bổ sung biến trạng thái

    public Cart() {}

    public Cart(int maDH, String tenKhachHang, String sdt, String diaChi, double tienDatCoc, String tenXe, double gia, String trangThai) {
        this.maDH = maDH;
        this.tenKhachHang = tenKhachHang;
        this.sdt = sdt;
        this.diaChi = diaChi;
        this.tienDatCoc = tienDatCoc;
        this.tenXe = tenXe;
        this.gia = gia;
        this.trangThai = trangThai;
    }

    public int getMaDH() { return maDH; }
    public void setMaDH(int maDH) { this.maDH = maDH; }
    
    public String getTenKhachHang() { return tenKhachHang; }
    public void setTenKhachHang(String tenKhachHang) { this.tenKhachHang = tenKhachHang; }


    public String getTenKhach() { return tenKhachHang; }
    public void setTenKhach(String tenKhach) { this.tenKhachHang = tenKhach; }
    
    public String getSdt() { return sdt; }
    public void setSdt(String sdt) { this.sdt = sdt; }
    
    public String getDiaChi() { return diaChi; }
    public void setDiaChi(String diaChi) { this.diaChi = diaChi; }
    
    public double getTienDatCoc() { return tienDatCoc; }
    public void setTienDatCoc(double tienDatCoc) { this.tienDatCoc = tienDatCoc; }
    
    public String getTenXe() { return tenXe; }
    public void setTenXe(String tenXe) { this.tenXe = tenXe; }
    
    public double getGia() { return gia; }
    public void setGia(double gia) { this.gia = gia; }

    public String getTrangThai() { 
        return trangThai; 
    }
    
    public void setTrangThai(String trangThai) { 
        this.trangThai = trangThai; 
    }
}
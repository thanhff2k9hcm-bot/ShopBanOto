package controller;

import dao.AdminDao;
import dao.EmployeeDao;
import dao.ConsultingDao;
import dao.DBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Cart;
import model.Product;
import model.Auth;
import model.Consulting;

@WebServlet(name = "AdminController", urlPatterns = {"/admin"})
public class AdminController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession();
        Auth acc = (Auth) session.getAttribute("acc");
        if (acc == null || !"Admin".equalsIgnoreCase(acc.getVaiTro())) {
            response.sendRedirect("login");
            return;
        }
        
        try {
            AdminDao dao = new AdminDao();
            String action = request.getParameter("action");
            
            if ("consulting".equals(action)) {
                ConsultingDao cDao = new ConsultingDao();
                List<Consulting> consultingList = cDao.getAllConsulting();
                
                request.setAttribute("consultingList", consultingList);
                request.setAttribute("phieuList", consultingList);
                request.getRequestDispatcher("admin_consulting.jsp").forward(request, response);
                return;
            }
            
            if ("delete".equals(action)) {
                String maXeStr = request.getParameter("maXe");
                if (maXeStr != null) {
                    dao.xoaSanPham(Integer.parseInt(maXeStr));
                }
                request.setAttribute("message", "Xóa sản phẩm thành công!");
                request.setAttribute("type", "success");
                request.setAttribute("redirectUrl", "admin");
                request.getRequestDispatcher("thongbao.jsp").forward(request, response);
                return;
            }
            
            if ("editForm".equals(action)) {
                String maXeStr = request.getParameter("maXe");
                if (maXeStr != null) {
                    int maXe = Integer.parseInt(maXeStr);
                    List<Product> productList = dao.getProductsByHang(null);
                    Product selectedProduct = null;
                    for (Product p : productList) {
                        if (p.getMaXe() == maXe) {
                            selectedProduct = p;
                            break;
                        }
                    }
                    request.setAttribute("editingProduct", selectedProduct);
                }
            }

            String[] selectedBrands = request.getParameterValues("brand");
            String orderKeyword = request.getParameter("orderKeyword");
            String statusFilter = request.getParameter("statusFilter");

            int totalProducts = dao.getTongSoSanPham(selectedBrands);
            int tongLoaiXe = dao.getTongLoaiXe(selectedBrands);
            int soLuongCon = dao.getSoLuongConHang();
            int soLuongHet = dao.getSoLuongHetHang();
            
            List<Cart> orderList = dao.searchOrders(orderKeyword, statusFilter);
            List<Product> productList = dao.getProductsByHang(selectedBrands);
            List<String> brandList = dao.getAllBrands();
            
            double tongTienDatCoc = 0;
            for (Cart c : orderList) {
                double tienCoc = c.getGia() * 0.35;
                tongTienDatCoc += tienCoc;
            }

            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("tongLoaiXe", tongLoaiXe);
            request.setAttribute("soLuongCon", soLuongCon);
            request.setAttribute("soLuongHet", soLuongHet);
            request.setAttribute("orderList", orderList);
            request.setAttribute("productList", productList);
            request.setAttribute("brandList", brandList);
            request.setAttribute("selectedBrands", selectedBrands);
            request.setAttribute("orderKeyword", orderKeyword);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("tongTienDatCoc", tongTienDatCoc);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Auth acc = (Auth) session.getAttribute("acc");
        if (acc == null || !"Admin".equalsIgnoreCase(acc.getVaiTro())) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        AdminDao dao = new AdminDao();

        if ("cancelDeposit".equals(action)) {
            try {
                int maTV = Integer.parseInt(request.getParameter("maTV"));
                ConsultingDao cDao = new ConsultingDao();
                

                cDao.updateStatus(maTV, "Đã hủy cọc");
  
              
                cDao.insertHoanCoc(maTV, "Đã hoàn tất", "Phê duyệt hủy cọc cho phiếu #" + maTV);

                try (java.sql.Connection conn = DBContext.getConnection();
                     java.sql.PreparedStatement ps = conn.prepareStatement(
                         "UPDATE DonHang SET TrangThai = N'Đã hủy cọc' WHERE MaDH = ?"
                     )) {
                    ps.setInt(1, maTV);
                    ps.executeUpdate();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                
                request.setAttribute("message", "Đã phê duyệt hủy cọc thành công cho đơn hàng #" + maTV + "!");
                request.setAttribute("type", "success");
                request.setAttribute("redirectUrl", "admin?action=consulting");
                request.getRequestDispatcher("thongbao.jsp").forward(request, response);
                return;
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("message", "Phê duyệt hủy cọc thất bại!");
                request.setAttribute("type", "error");
                request.setAttribute("redirectUrl", "admin?action=consulting");
                request.getRequestDispatcher("thongbao.jsp").forward(request, response);
                return;
            }
        }

        if ("updateConsultingStatus".equals(action)) {
            try {
                int maPTV = Integer.parseInt(request.getParameter("maPTV"));
                String trangThai = request.getParameter("trangThai");
                EmployeeDao empDao = new EmployeeDao();
                empDao.updateTrangThai(maPTV, trangThai);
                
                request.setAttribute("message", "Cập nhật trạng thái phiếu tư vấn #" + maPTV + " thành công (" + trangThai + ")!");
                request.setAttribute("type", "success");
                request.setAttribute("redirectUrl", "admin?action=consulting");
                request.getRequestDispatcher("thongbao.jsp").forward(request, response);
                return;
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("message", "Cập nhật trạng thái tư vấn thất bại!");
                request.setAttribute("type", "error");
                request.setAttribute("redirectUrl", "admin?action=consulting");
                request.getRequestDispatcher("thongbao.jsp").forward(request, response);
                return;
            }
        }

        if ("updateOrderStatus".equals(action)) {
            try {
                int maDH = Integer.parseInt(request.getParameter("maDH"));
                String trangThai = request.getParameter("trangThai");
                
                dao.updateOrderStatus(maDH, trangThai);
                
                request.setAttribute("message", "Cập nhật trạng thái đơn hàng #" + maDH + " thành công (" + trangThai + ")!");
                request.setAttribute("type", "success");
                request.setAttribute("redirectUrl", "admin");
                request.getRequestDispatcher("thongbao.jsp").forward(request, response);
                return;
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("message", "Cập nhật trạng thái đơn hàng thất bại!");
                request.setAttribute("type", "error");
                request.setAttribute("redirectUrl", "admin");
                request.getRequestDispatcher("thongbao.jsp").forward(request, response);
                return;
            }
        }

        try {
            String giaStr = request.getParameter("gia");
            double gia = (giaStr != null && !giaStr.trim().isEmpty()) ? Double.parseDouble(giaStr.trim()) : 0;
            
            int soLuongTon = Integer.parseInt(request.getParameter("soLuongTon"));
            
            if (gia < 0) gia = 0;
            if (soLuongTon < 0) soLuongTon = 0;

            String status = request.getParameter("status");
            if ("het".equals(status)) {
                soLuongTon = 0;
            } else if ("con".equals(status) && soLuongTon <= 0) {
                soLuongTon = 1;
            }

            if ("update".equals(action)) {
                int maXe = Integer.parseInt(request.getParameter("maXe"));
                String tenXe = request.getParameter("tenXe");
                String hangXe = request.getParameter("hangXe");
                String hinhAnh = request.getParameter("hinhAnhDaiDien");

                dao.suaSanPham(maXe, tenXe, hangXe, gia, soLuongTon, hinhAnh);
                request.setAttribute("message", "Cập nhật thông tin sản phẩm thành công!");
            } else {
                String tenXe = request.getParameter("tenXe");
                String hangXe = request.getParameter("hangXe");
                String hinhAnh = request.getParameter("hinhAnhDaiDien");

                dao.themXeMoi(tenXe, hangXe, gia, soLuongTon, hinhAnh);
                request.setAttribute("message", "Thêm sản phẩm mới thành công!");
            }
            request.setAttribute("type", "success");
            request.setAttribute("redirectUrl", "admin");
            request.getRequestDispatcher("thongbao.jsp").forward(request, response);
            return;
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Thực hiện thao tác quản trị thất bại!");
            request.setAttribute("type", "error");
            request.setAttribute("redirectUrl", "admin");
            request.getRequestDispatcher("thongbao.jsp").forward(request, response);
            return;
        }
    }
}
package controller;

import dao.ProductDao;
import dao.ConsultingDao;
import model.Product;
import model.Auth;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CartController", urlPatterns = {"/cart"})
public class CartController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        String maXeStr = request.getParameter("maXe");

        Map<Integer, Integer> cartQuantities = (Map<Integer, Integer>) session.getAttribute("cartQuantities");
        List<Product> cartList = (List<Product>) session.getAttribute("cartList");
        
        if (cartQuantities == null) cartQuantities = new HashMap<>();
        if (cartList == null) cartList = new ArrayList<>();

        if ("remove".equals(action) && maXeStr != null && !maXeStr.trim().isEmpty()) {
            try {
                int maXe = Integer.parseInt(maXeStr.trim());
                cartList.removeIf(p -> p.getMaXe() == maXe);
                cartQuantities.remove(maXe);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
            session.setAttribute("cartList", cartList);
            session.setAttribute("cartQuantities", cartQuantities);
            response.sendRedirect("cart");
            return;
        }

        if (maXeStr != null && !maXeStr.trim().isEmpty()) {
            try {
                int maXe = Integer.parseInt(maXeStr.trim());
                ProductDao pDao = new ProductDao();
                Product product = pDao.getProductById(maXe);
                
                if (product != null) {
                    boolean exists = false;
                    for (Product p : cartList) {
                        if (p.getMaXe() == maXe) {
                            exists = true;
                            break;
                        }
                    }
                    if (!exists) {
                        cartList.add(product);
                    }
                    
                    int currentQty = cartQuantities.getOrDefault(maXe, 0);
                    if ("add".equals(action)) {
                        cartQuantities.put(maXe, currentQty + 1);
                    } else {
                        if (currentQty == 0) {
                            cartQuantities.put(maXe, 1);
                        }
                    }
                }
                session.setAttribute("cartList", cartList);
                session.setAttribute("cartQuantities", cartQuantities);

                if ("add".equals(action)) {
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().write("Thêm sản phẩm vào giỏ hàng thành công!");
                    return;
                } else {
                    response.sendRedirect("cart");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        session.setAttribute("cartList", cartList);
        session.setAttribute("cartQuantities", cartQuantities);
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Auth user = (Auth) session.getAttribute("acc");
        
        String hoTen = request.getParameter("hoTen");
        String sdt = request.getParameter("sdt");

        String email = (user != null && user.getEmail() != null) ? user.getEmail() : "khachvanglai@shopbanoto.com";
        int maND = (user != null) ? user.getMaND() : 1; // ID mặc định cho khách vãng lai

        try {
            List<Product> cartList = (List<Product>) session.getAttribute("cartList");
            Map<Integer, Integer> cartQuantities = (Map<Integer, Integer>) session.getAttribute("cartQuantities");
            ProductDao pDao = new ProductDao();
            ConsultingDao consultingDao = new ConsultingDao();
            
            boolean allSuccess = true;
            if (cartList != null && !cartList.isEmpty()) {
                for (Product p : cartList) {
                    int soLuong = 1;
                    try {
                        String slStr = request.getParameter("soLuong_" + p.getMaXe());
                        if (slStr != null && !slStr.trim().isEmpty()) {
                            soLuong = Integer.parseInt(slStr.trim());
                        } else if (cartQuantities != null && cartQuantities.containsKey(p.getMaXe())) {
                            soLuong = cartQuantities.get(p.getMaXe());
                        }
                    } catch (Exception e) {
                        soLuong = 1;
                    }

                    double totalGia = p.getGia() * soLuong;
                    
                    pDao.insertOrder(maND, p.getMaXe(), soLuong, totalGia, hoTen, sdt);
                 
                    String tenXeGoc = p.getTenXe();
                    String ghiChuDatCoc = "Đặt cọc xe qua giỏ hàng (Số lượng: " + soLuong + ")";
                    boolean successConsulting = consultingDao.guiYeuCauVoiGia(hoTen, sdt, email, tenXeGoc, ghiChuDatCoc, p.getGia(), maND);
                    
                    if (!successConsulting) {
                        allSuccess = false;
                    }
                }
            }

            if (allSuccess && cartList != null && !cartList.isEmpty()) {
                session.removeAttribute("cartList");
                session.removeAttribute("cartQuantities");
                request.setAttribute("message", "Xác nhận đặt cọc thành công! Đơn hàng của quý khách (" + hoTen + " - " + sdt + ") đã được chuyển tới hệ thống quản lý.");
                request.setAttribute("type", "success");
                request.setAttribute("redirectUrl", "product");
            } else {
                request.setAttribute("message", "Đặt cọc thất bại hoặc giỏ hàng trống. Vui lòng thử lại!");
                request.setAttribute("type", "error");
                request.setAttribute("redirectUrl", "cart");
            }
            
            request.getRequestDispatcher("thongbao.jsp").forward(request, response);
            return;

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Có lỗi xảy ra trong quá trình xử lý đặt cọc!");
            request.setAttribute("type", "error");
            request.setAttribute("redirectUrl", "cart");
            request.getRequestDispatcher("thongbao.jsp").forward(request, response);
            return;
        }
    }
}
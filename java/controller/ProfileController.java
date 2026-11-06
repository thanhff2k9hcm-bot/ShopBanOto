package controller;

import dao.AuthDao;
import dao.ProductDao;
import model.Auth;
import model.Cart;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProfileController", urlPatterns = {"/profile"})
public class ProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession();
        Auth acc = (Auth) session.getAttribute("acc");
        
        if (acc == null) {
            response.sendRedirect("auth.jsp");
            return;
        }

        try {
            ProductDao pDao = new ProductDao();
            List<Cart> orderList = pDao.getOrdersByUserId(acc.getMaND());
            request.setAttribute("orderList", orderList);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Auth acc = (Auth) session.getAttribute("acc");
        
        if (acc == null) {
            response.sendRedirect("auth.jsp");
            return;
        }

        String action = request.getParameter("action");
        AuthDao dao = new AuthDao();

        if ("updateInfo".equals(action)) {
            String hoTen = request.getParameter("hoTen");
            String email = request.getParameter("email");
            String sdt = request.getParameter("sdt");
            
            if (dao.checkDuplicateEmailOrPhone(email, sdt, acc.getMaND())) {
                request.setAttribute("paramHoTen", hoTen);
                request.setAttribute("paramEmail", email);
                request.setAttribute("paramSdt", sdt);
                request.setAttribute("errorMsg", "⚠️ Email hoặc số điện thoại này đã được sử dụng bởi tài khoản khác!");
                request.getRequestDispatcher("profile.jsp").forward(request, response);
                return;
            } else {
                acc.setHoTen(hoTen);
                acc.setEmail(email);
                acc.setSdt(sdt);
                session.setAttribute("acc", acc);
                request.setAttribute("message", "Cập nhật thông tin thành công!");
            }
        } else if ("changePassword".equals(action)) {
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            if (!acc.getMatKhau().equals(oldPassword)) {
                request.setAttribute("errorMsg", "⚠️ Mật khẩu hiện tại không chính xác!");
            } else if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("errorMsg", "Mật khẩu mới và xác nhận mật khẩu không khớp!");
            } else {
                acc.setMatKhau(newPassword);
                session.setAttribute("acc", acc);
                request.setAttribute("message", "Đổi mật khẩu thành công!");
            }
        }
        
        doGet(request, response);
    }
}

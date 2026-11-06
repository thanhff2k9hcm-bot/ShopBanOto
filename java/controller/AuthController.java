package controller;

import dao.AuthDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Auth;

@WebServlet(name = "AuthController", urlPatterns = {"/login", "/register", "/logout"})
public class AuthController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        
        if ("/logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.removeAttribute("cartList");
                session.removeAttribute("cartQuantities");
                session.invalidate();
            }
            response.sendRedirect("home");
        } else {
            request.getRequestDispatcher("auth.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getServletPath();

        AuthDao dao = new AuthDao();

        if ("/login".equals(action)) {
            String user = request.getParameter("tenDangNhap");
            String pass = request.getParameter("matKhau");
            Auth account = dao.checkLogin(user, pass);

            if (account != null) {
                HttpSession session = request.getSession();
                session.removeAttribute("cartList");
                session.removeAttribute("cartQuantities");
                
                session.setAttribute("acc", account);
                
                String role = account.getVaiTro();
                if (role != null && role.trim().equalsIgnoreCase("Admin")) {
                    response.sendRedirect("admin");
                } else if (role != null && role.trim().equalsIgnoreCase("Employee")) {
                    response.sendRedirect("employee");
                } else {
                    response.sendRedirect("home");
                }
            } else {
                request.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu!");
                request.getRequestDispatcher("auth.jsp").forward(request, response);
            }
            
        } else if ("/register".equals(action)) {
            String user = request.getParameter("tenDangNhap");
            String pass = request.getParameter("matKhau");
            String hoTen = request.getParameter("hoTen");
            String email = request.getParameter("email");
            String sdt = request.getParameter("sdt");

            boolean ok = dao.register(user, pass, hoTen, email, sdt);
            if (ok) {
                response.sendRedirect("auth.jsp");
            } else {
                request.setAttribute("paramUser", user);
                request.setAttribute("paramHoTen", hoTen);
                request.setAttribute("paramEmail", email);
                request.setAttribute("paramSdt", sdt);
                request.setAttribute("errorReg", "Đăng ký thất bại! Tên đăng nhập, email hoặc số điện thoại có thể đã tồn tại.");
                request.getRequestDispatcher("auth.jsp").forward(request, response);
            }
        }
    }
}

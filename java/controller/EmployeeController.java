package controller;

import dao.EmployeeDao;
import model.Auth;
import model.PhieuTuVan;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "EmployeeController", urlPatterns = {"/employee"})
public class EmployeeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession();
        Auth acc = (Auth) session.getAttribute("acc");

        if (acc == null || (!"Employee".equals(acc.getVaiTro()) && !"Admin".equals(acc.getVaiTro()))) {
            response.sendRedirect("auth.jsp");
            return;
        }

        try {
            EmployeeDao eDao = new EmployeeDao();
            List<PhieuTuVan> phieuList = eDao.getAllPhieuTuVan();
            request.setAttribute("phieuList", phieuList);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("employee.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Auth acc = (Auth) session.getAttribute("acc");
        
        if (acc == null || (!"Employee".equals(acc.getVaiTro()) && !"Admin".equals(acc.getVaiTro()))) {
            response.sendRedirect("auth.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("updateStatus".equals(action) || "updateConsultingStatus".equals(action)) {
            try {
                int maPTV = Integer.parseInt(request.getParameter("maPTV"));
                String trangThai = request.getParameter("trangThai");
                
                EmployeeDao eDao = new EmployeeDao();
                boolean success = eDao.updateTrangThai(maPTV, trangThai);
                
                if (success) {
                    request.setAttribute("message", "Cập nhật trạng thái phiếu tư vấn #" + maPTV + " thành công (" + trangThai + ")!");
                    request.setAttribute("type", "success");
                } else {
                    request.setAttribute("message", "Cập nhật trạng thái thất bại!");
                    request.setAttribute("type", "error");
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("message", "Có lỗi xảy ra khi cập nhật trạng thái!");
                request.setAttribute("type", "error");
            }
        }
        
        if ("Admin".equals(acc.getVaiTro()) && request.getRequestURI().contains("admin")) {
            response.sendRedirect("admin?action=consulting");
        } else {
            doGet(request, response);
        }
    }
}

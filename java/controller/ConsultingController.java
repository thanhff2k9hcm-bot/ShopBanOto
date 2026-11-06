package controller;

import dao.ConsultingDao;
import dao.ProductDao;
import model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ConsultingController", urlPatterns = {"/consulting"})
public class ConsultingController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String maXeStr = request.getParameter("maXe");
        if (maXeStr != null && !maXeStr.trim().isEmpty()) {
            try {
                int maXe = Integer.parseInt(maXeStr.trim());
                ProductDao pDao = new ProductDao();
                Product product = pDao.getProductById(maXe);
                
                if (product != null) {
                    request.setAttribute("selectedProduct", product);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        
        request.getRequestDispatcher("consulting.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String hoTen = request.getParameter("hoTen");
        String sdt = request.getParameter("sdt");
        String email = request.getParameter("email");
        String tenXe = request.getParameter("tenXe");
        String noiDung = request.getParameter("noiDung");

        ConsultingDao dao = new ConsultingDao();
        int defaultEmployeeId = 1;
        boolean ok = dao.guiYeuCauVoiTenXe(hoTen, sdt, email, tenXe, noiDung, defaultEmployeeId);

        if (ok) {
            request.setAttribute("message", "Gửi yêu cầu tư vấn thành công! Yêu cầu đang ở trạng thái chờ xử lý, chúng tôi sẽ liên hệ sớm nhất.");
            request.setAttribute("type", "pending");
            request.setAttribute("redirectUrl", "home");
        } else {
            request.setAttribute("message", "Gửi yêu cầu tư vấn thất bại. Vui lòng thử lại sau!");
            request.setAttribute("type", "error");
            request.setAttribute("redirectUrl", "consulting");
        }

        request.getRequestDispatcher("thongbao.jsp").forward(request, response);
    }
}
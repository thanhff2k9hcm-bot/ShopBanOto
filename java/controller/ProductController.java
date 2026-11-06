package controller;

import dao.ProductDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Product;

@WebServlet(name = "ProductController", urlPatterns = {"/product", "/products"})
public class ProductController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        ProductDao dao = new ProductDao();
        

        String hang = request.getParameter("hang");
        String gia = request.getParameter("gia");

        double minPrice = -1;
        double maxPrice = -1;

        if (gia != null && !gia.trim().isEmpty()) {
            if ("duoi10".equals(gia)) {
                maxPrice = 10000000000.0;
            } else if ("10to20".equals(gia)) {
                minPrice = 10000000000.0;
                maxPrice = 20000000000.0; 
            } else if ("tren20".equals(gia)) {
                minPrice = 20000000000.0; 
            }
        }


        String[] selectedBrands = (hang != null && !hang.trim().isEmpty()) ? new String[]{hang} : null;

        List<Product> list = dao.getProductsFiltered(selectedBrands, minPrice, maxPrice);
        List<String> brandList = dao.getAllBrands();
        
        request.setAttribute("productList", list);
        request.setAttribute("hangList", brandList);
        
        request.getRequestDispatcher("product.jsp").forward(request, response);
    }
}
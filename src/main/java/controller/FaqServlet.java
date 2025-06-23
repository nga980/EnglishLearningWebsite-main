package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet này xử lý các yêu cầu cho trang Câu hỏi thường gặp (FAQ).
 * Nó chỉ đơn giản là chuyển tiếp yêu cầu đến tệp faq.jsp để hiển thị.
 */
@WebServlet(name = "FaqServlet", urlPatterns = {"/faq"})
public class FaqServlet extends HttpServlet {

    /**
     * Xử lý phương thức HTTP <code>GET</code>.
     * Phương thức này chuyển tiếp yêu cầu đến trang faq.jsp.
     *
     * @param request đối tượng servlet request
     * @param response đối tượng servlet response
     * @throws ServletException nếu có lỗi đặc trưng của servlet xảy ra
     * @throws IOException nếu có lỗi I/O xảy ra
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("faq.jsp").forward(request, response);
    }

    /**
     * Xử lý phương thức HTTP <code>POST</code>.
     *
     * @param request đối tượng servlet request
     * @param response đối tượng servlet response
     * @throws ServletException nếu có lỗi đặc trưng của servlet xảy ra
     * @throws IOException nếu có lỗi I/O xảy ra
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Trong trường hợp này, xử lý POST giống hệt như GET
        doGet(request, response);
    }

    /**
     * Trả về một mô tả ngắn về servlet.
     *
     * @return một chuỗi String chứa mô tả của servlet
     */
    @Override
    public String getServletInfo() {
        return "Servlet forwards to the FAQ page";
    }
}
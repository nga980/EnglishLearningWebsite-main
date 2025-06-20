package controller; 
import java.io.IOException;
import jakarta.servlet.ServletException; // Hoặc javax.servlet.ServletException
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

 @WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Lấy session hiện tại, không tạo mới
        if (session != null) {
            session.invalidate(); // Hủy session
        }
        response.sendRedirect("login.jsp"); // Chuyển hướng về trang đăng nhập
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp); // Xử lý POST giống như GET
    }
}
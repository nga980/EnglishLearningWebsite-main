package controller; // Giữ nguyên package của bạn

import dao.UserDAO;    // Giữ nguyên package của bạn
import model.User;     // Giữ nguyên package của bạn
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.logging.Level;
import java.util.logging.Logger; // THÊM IMPORT NÀY

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;
    // KHAI BÁO VÀ KHỞI TẠO LOGGER Ở ĐÂY
    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() ||
            password == null || password.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập tên đăng nhập và mật khẩu.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.login(username, password);

        if (user != null) {
            // Dòng log này sẽ hoạt động khi LOGGER đã được khai báo đúng
            LOGGER.log(Level.INFO, "LoginServlet: User ''{0}'' logged in with role: ''{1}''. Setting to session.",
                    new Object[]{user.getUsername(), user.getRole()});

            HttpSession session = request.getSession(); // Tạo session mới nếu chưa có
            session.setAttribute("loggedInUser", user); // Lưu thông tin người dùng vào session

            // Logic chuyển hướng dựa trên vai trò
            if ("ADMIN".equals(user.getRole())) {
                // Nếu là ADMIN, chuyển hướng đến Admin Dashboard (URL của AdminDashboardServlet)
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                // Nếu là USER hoặc vai trò khác, chuyển hướng đến trang chủ
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển tiếp đến trang đăng nhập nếu người dùng truy cập qua GET
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Login Servlet with role-based redirection";
    }
}
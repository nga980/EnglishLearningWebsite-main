package controller;

import model.User;
import dao.UserDAO;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO;
    private static final Logger LOGGER = Logger.getLogger(RegisterServlet.class.getName());

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
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");

        // Kiểm tra dữ liệu đầu vào
        if (username == null || username.trim().isEmpty() ||
            password == null || password.isEmpty() ||
            email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ các trường bắt buộc.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            request.setAttribute("error", "Địa chỉ email không hợp lệ.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Khởi tạo DAO nếu chưa có (đề phòng lỗi init)
        if (userDAO == null) {
            userDAO = new UserDAO();
        }

        // Kiểm tra username đã tồn tại
        if (userDAO.checkUserExist(username)) {
            request.setAttribute("error", "Tên đăng nhập '" + username + "' đã tồn tại!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Tạo user mới
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(password); // Nên hash trong DAO
        newUser.setEmail(email);
        newUser.setFullName(fullName);

        LOGGER.log(Level.INFO, "Đang thử đăng ký người dùng: {0}", username);

        boolean registered = userDAO.addUser(newUser);

        LOGGER.log(Level.INFO, "Kết quả userDAO.addUser() cho {0}: {1}", new Object[]{username, registered});

        if (registered) {
            LOGGER.log(Level.INFO, "Đăng ký thành công cho {0}. Đang chuyển hướng...", username);
            String contextPath = request.getContextPath();
            String message = URLEncoder.encode("Đăng ký thành công! Vui lòng đăng nhập.", "UTF-8");
            response.sendRedirect(contextPath + "/login.jsp?message=" + message);
        } else {
            LOGGER.log(Level.WARNING, "Đăng ký thất bại cho {0} từ DAO.", username);
            request.setAttribute("error", "Đăng ký thất bại do lỗi hệ thống hoặc dữ liệu không hợp lệ. Vui lòng thử lại.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
}

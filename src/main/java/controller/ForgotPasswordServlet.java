package controller;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    private UserDAO userDAO;
    private static final Logger LOGGER = Logger.getLogger(ForgotPasswordServlet.class.getName());

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        User user = userDAO.findUserByEmail(email);

        if (user != null) {
            String token = UUID.randomUUID().toString();
            // Token hết hạn sau 1 giờ
            Timestamp expiryDate = new Timestamp(System.currentTimeMillis() + 3600 * 1000);
            userDAO.createPasswordResetToken(user.getUserId(), token, expiryDate);

            // **Mô phỏng gửi email**: In link ra console
            String resetLink = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
                    + request.getContextPath() + "/reset-password?token=" + token;
            
            LOGGER.log(Level.INFO, "PASSWORD RESET LINK (for testing): {0}", resetLink);
        }

        // Luôn hiển thị thông báo thành công để tránh lộ thông tin email nào đã đăng ký
        request.setAttribute("message", "Nếu email của bạn tồn tại trong hệ thống, một đường link để đặt lại mật khẩu đã được gửi đi (kiểm tra console của server để lấy link).");
        request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
    }
}
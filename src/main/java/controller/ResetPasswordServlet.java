package controller;

import dao.UserDAO;
import utils.SecurityUtils;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/reset-password"})
public class ResetPasswordServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        int userId = userDAO.getUserIdByPasswordResetToken(token);

        if (userId != -1) {
            // Token hợp lệ, chuyển đến trang nhập mật khẩu mới
            request.setAttribute("token", token);
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
        } else {
            // Token không hợp lệ hoặc đã hết hạn
            request.setAttribute("error", "Đường link đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmNewPassword");
        
        int userId = userDAO.getUserIdByPasswordResetToken(token);

        if (userId == -1) {
            request.setAttribute("error", "Yêu cầu không hợp lệ hoặc đã hết hạn. Vui lòng thử lại.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        if (newPassword == null || newPassword.length() < 8) {
            request.setAttribute("error", "Mật khẩu mới phải có ít nhất 8 ký tự.");
            request.setAttribute("token", token); // Gửi lại token để form không bị mất
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            return;
        }

        String hashedNewPassword = SecurityUtils.hashPassword(newPassword);
        boolean success = userDAO.updatePassword(userId, hashedNewPassword);

        HttpSession session = request.getSession();
        if (success) {
            userDAO.deletePasswordResetToken(token); // Xóa token đã sử dụng
            session.setAttribute("successMessage", "Mật khẩu của bạn đã được cập nhật thành công. Vui lòng đăng nhập.");
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("error", "Đã xảy ra lỗi khi cập nhật mật khẩu. Vui lòng thử lại.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
        }
    }
}
package controller;

import dao.UserDAO;
import model.User;
import utils.SecurityUtils;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/change-password"})
public class ChangePasswordServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String currentPassword = getSafeParam(request, "currentPassword");
        String newPassword = getSafeParam(request, "newPassword");
        String confirmNewPassword = getSafeParam(request, "confirmNewPassword");

        if (currentPassword.isEmpty() || newPassword.isEmpty() || confirmNewPassword.isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng điền đầy đủ tất cả các trường.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        String storedHashedPassword = userDAO.getHashedPasswordById(loggedInUser.getUserId());
        if (!SecurityUtils.checkPassword(currentPassword, storedHashedPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu hiện tại không chính xác.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmNewPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu mới và xác nhận không khớp.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 8) {
            request.setAttribute("errorMessage", "Mật khẩu mới phải có ít nhất 8 ký tự.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        String newHashedPassword = SecurityUtils.hashPassword(newPassword);
        boolean success = userDAO.updatePassword(loggedInUser.getUserId(), newHashedPassword);

        if (success) {
            // Đặt message vào session
            session.setAttribute("successMessage", "Đổi mật khẩu thành công!");
            // Redirect về servlet /profile để nó có thể tải lại trang profile một cách sạch sẽ
            response.sendRedirect(request.getContextPath() + "/profile"); 
        } else {
            request.setAttribute("errorMessage", "Đã xảy ra lỗi. Không thể đổi mật khẩu.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        }
    }

    private String getSafeParam(HttpServletRequest request, String paramName) {
        String param = request.getParameter(paramName);
        return param != null ? param.trim() : "";
    }
}
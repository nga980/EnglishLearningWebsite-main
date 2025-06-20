package controller;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet xử lý việc cập nhật vai trò của người dùng từ trang quản lý.
 */
@WebServlet(name = "UpdateUserRoleServlet", urlPatterns = {"/admin/update-user-role"})
public class UpdateUserRoleServlet extends HttpServlet {

    private UserDAO userDAO;
    private static final Logger LOGGER = Logger.getLogger(UpdateUserRoleServlet.class.getName());

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // Lấy thông tin từ form
        String userIdStr = request.getParameter("userId");
        String newRole = request.getParameter("newRole");

        // Lấy thông tin admin đang đăng nhập từ session để kiểm tra an toàn
        User loggedInAdmin = (User) session.getAttribute("loggedInUser");

        String redirectURL = request.getContextPath() + "/admin/manage-users";

        try {
            int userId = Integer.parseInt(userIdStr);

            // KIỂM TRA AN TOÀN QUAN TRỌNG: Ngăn admin tự thay đổi vai trò của chính mình
            if (loggedInAdmin != null && loggedInAdmin.getUserId() == userId) {
                session.setAttribute("errorMessage_user", "Bạn không thể tự thay đổi vai trò của chính mình.");
                response.sendRedirect(redirectURL);
                return;
            }

            boolean success = userDAO.updateUserRole(userId, newRole);

            if (success) {
                session.setAttribute("successMessage_user", "Cập nhật vai trò cho người dùng ID " + userId + " thành công!");
                LOGGER.log(Level.INFO, "Admin ''{0}'' updated role for user ID {1} to ''{2}''", 
                        new Object[]{loggedInAdmin.getUsername(), userId, newRole});
            } else {
                session.setAttribute("errorMessage_user", "Cập nhật vai trò cho người dùng ID " + userId + " thất bại.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage_user", "ID người dùng không hợp lệ.");
        }

        response.sendRedirect(redirectURL);
    }
}
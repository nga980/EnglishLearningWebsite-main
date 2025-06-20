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
 * Servlet xử lý việc xóa một người dùng.
 */
@WebServlet(name = "DeleteUserServlet", urlPatterns = {"/admin/delete-user"})
public class DeleteUserServlet extends HttpServlet {

    private UserDAO userDAO;
    private static final Logger LOGGER = Logger.getLogger(DeleteUserServlet.class.getName());

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userIdStr = request.getParameter("userId");
        String redirectURL = request.getContextPath() + "/admin/manage-users";

        User loggedInAdmin = (User) session.getAttribute("loggedInUser");

        try {
            int userIdToDelete = Integer.parseInt(userIdStr);

            // KIỂM TRA AN TOÀN PHÍA SERVER: Ngăn admin tự xóa mình qua URL
            if (loggedInAdmin != null && loggedInAdmin.getUserId() == userIdToDelete) {
                session.setAttribute("errorMessage_user", "Không thể tự xóa tài khoản của chính mình.");
                response.sendRedirect(redirectURL);
                return;
            }

            boolean success = userDAO.deleteUser(userIdToDelete);

            if (success) {
                session.setAttribute("successMessage_user", "Xóa người dùng ID " + userIdToDelete + " thành công!");
            } else {
                session.setAttribute("errorMessage_user", "Xóa người dùng ID " + userIdToDelete + " thất bại.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage_user", "ID người dùng không hợp lệ.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa người dùng", e);
            session.setAttribute("errorMessage_user", "Lỗi hệ thống khi xóa người dùng.");
        }

        response.sendRedirect(redirectURL);
    }
}
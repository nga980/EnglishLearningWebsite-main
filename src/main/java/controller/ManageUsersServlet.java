package controller;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ManageUsersServlet", urlPatterns = {"/admin/manage-users"})
public class ManageUsersServlet extends HttpServlet {

    private UserDAO userDAO;
    private static final int PAGE_SIZE = 10;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String pageStr = request.getParameter("page");
        int currentPage = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        int totalUsers = userDAO.countTotalUsers(); // Phương thức này đã có
        int totalPages = (int) Math.ceil((double) totalUsers / PAGE_SIZE);
        
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }
        if (currentPage < 1) {
            currentPage = 1;
        }

        List<User> userList = userDAO.getUsersByPage(currentPage, PAGE_SIZE);

        request.setAttribute("userList", userList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/admin/manageUsers.jsp").forward(request, response);
    }
}
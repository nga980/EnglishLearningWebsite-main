package controller;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

@WebServlet(name = "ManageUsersServlet", urlPatterns = {"/admin/manage-users"})
public class ManageUsersServlet extends BaseManageServlet<User> {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected int getTotalItems() {
        return userDAO.countTotalUsers();
    }

    @Override
    protected List<User> getItemsByPage(int currentPage, int pageSize) {
        return userDAO.getUsersByPage(currentPage, pageSize);
    }

    @Override
    protected String getItemListAttributeName() {
        return "userList";
    }

    @Override
    protected String getTotalItemsAttributeName() {
        // JSP này có thể chưa dùng đến, nhưng thêm vào cho nhất quán
        return "totalUsers"; 
    }

    @Override
    protected String getJspPage() {
        return "/admin/manageUsers.jsp";
    }
    
    // Giữ nguyên PAGE_SIZE mặc định là 10
}
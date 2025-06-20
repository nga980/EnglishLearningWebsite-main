package controller;

// Import các DAO cần thiết
import dao.LessonDAO;
import dao.UserDAO;
import dao.VocabularyDAO;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet này xử lý việc hiển thị trang Admin Dashboard.
 * Nó được bảo vệ bởi AdminAuthFilter do URL pattern của nó.
 */
@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard", "/admin/home"})
public class AdminDashboardServlet extends HttpServlet {

    // Khai báo các DAO ở cấp độ lớp
    private LessonDAO lessonDAO;
    private VocabularyDAO vocabularyDAO;
    private UserDAO userDAO;

    @Override
    public void init() {
        // Khởi tạo các DAO
        lessonDAO = new LessonDAO();
        vocabularyDAO = new VocabularyDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // Gán thông tin người dùng để hiển thị trên giao diện (giữ nguyên)
        request.setAttribute("loggedInUser", request.getSession().getAttribute("loggedInUser"));

        // THAY THẾ DỮ LIỆU GIẢ BẰNG DỮ LIỆU THẬT TỪ DAO
        int totalLessons = lessonDAO.countTotalLessons();
        int totalVocabulary = vocabularyDAO.countTotalVocabulary();
        int totalUsers = userDAO.countTotalUsers();

        // Gán các thống kê thật vào request
        request.setAttribute("totalLessons", totalLessons);
        request.setAttribute("totalVocabulary", totalVocabulary);
        request.setAttribute("totalUsers", totalUsers);

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Admin Dashboard Servlet with dynamic statistics";
    }
}
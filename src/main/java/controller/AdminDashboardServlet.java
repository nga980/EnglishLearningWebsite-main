package controller;

// Import các DAO cần thiết
import dao.LessonDAO;
import dao.UserDAO;
import dao.VocabularyDAO;
import dao.GrammarTopicDAO; 
import com.google.gson.Gson;
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
    private GrammarTopicDAO grammarTopicDAO; // <-- THÊM KHAI BÁO NÀY

    @Override
    public void init() {
        // Khởi tạo các DAO
        lessonDAO = new LessonDAO();
        vocabularyDAO = new VocabularyDAO();
        userDAO = new UserDAO();
        grammarTopicDAO = new GrammarTopicDAO(); // <-- THÊM KHỞI TẠO NÀY
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // Gán thông tin người dùng để hiển thị trên giao diện (giữ nguyên)
        request.setAttribute("loggedInUser", request.getSession().getAttribute("loggedInUser"));

        // Lấy dữ liệu thống kê từ các DAO
        int totalLessons = lessonDAO.countTotalLessons();
        int totalVocabulary = vocabularyDAO.countTotalVocabulary();
        int totalUsers = userDAO.countTotalUsers();
        int totalGrammarTopics = grammarTopicDAO.countTotalGrammarTopics(); // <-- THÊM DÒNG NÀY

        // Gán các thống kê vào request để gửi sang JSP
        request.setAttribute("totalLessons", totalLessons);
        request.setAttribute("totalVocabulary", totalVocabulary);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalGrammarTopics", totalGrammarTopics); // <-- THÊM DÒNG NÀY

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
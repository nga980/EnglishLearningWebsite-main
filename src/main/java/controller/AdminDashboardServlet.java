package controller;

import dao.LessonDAO;
import dao.UserDAO;
import dao.VocabularyDAO;
import dao.GrammarTopicDAO;
import com.google.gson.Gson;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard", "/admin/home"})
public class AdminDashboardServlet extends HttpServlet {

    private LessonDAO lessonDAO;
    private VocabularyDAO vocabularyDAO;
    private UserDAO userDAO;
    private GrammarTopicDAO grammarTopicDAO;

    @Override
    public void init() {
        lessonDAO = new LessonDAO();
        vocabularyDAO = new VocabularyDAO();
        userDAO = new UserDAO();
        grammarTopicDAO = new GrammarTopicDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        request.setAttribute("loggedInUser", request.getSession().getAttribute("loggedInUser"));

        // Lấy dữ liệu thống kê tổng quan
        int totalLessons = lessonDAO.countTotalLessons();
        int totalVocabulary = vocabularyDAO.countTotalVocabulary();
        int totalUsers = userDAO.countTotalUsers();
        int totalGrammarTopics = grammarTopicDAO.countTotalGrammarTopics();

        // ================== LOGIC XỬ LÝ DỮ LIỆU BIỂU ĐỒ TĂNG TRƯỞNG ==================
        int monthsToTrack = 6;
        
        // 1. Tạo danh sách các nhãn tháng chuẩn (vd: "Tháng 1/2025", "Tháng 2/2025"...)
        List<String> monthLabels = new ArrayList<>();
        LocalDate startDate = LocalDate.now().minusMonths(monthsToTrack - 1);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("'Tháng' M/yyyy");
        for (int i = 0; i < monthsToTrack; i++) {
            monthLabels.add(startDate.plusMonths(i).format(formatter));
        }

        // 2. Lấy dữ liệu thô từ DAO
        Map<String, Integer> rawUserGrowth = userDAO.getMonthlyUserGrowth(monthsToTrack);
        Map<String, Integer> rawLessonGrowth = lessonDAO.getMonthlyLessonGrowth(monthsToTrack);
        Map<String, Integer> rawVocabGrowth = vocabularyDAO.getMonthlyVocabularyGrowth(monthsToTrack);

        // 3. Chuẩn bị các danh sách dữ liệu cuối cùng, đảm bảo cùng kích thước với nhãn tháng
        List<Integer> finalUserGrowth = new ArrayList<>();
        List<Integer> finalLessonGrowth = new ArrayList<>();
        List<Integer> finalVocabGrowth = new ArrayList<>();

        for (String label : monthLabels) {
            finalUserGrowth.add(rawUserGrowth.getOrDefault(label, 0));
            finalLessonGrowth.add(rawLessonGrowth.getOrDefault(label, 0));
            finalVocabGrowth.add(rawVocabGrowth.getOrDefault(label, 0));
        }
        
        // 4. Chuyển đổi sang JSON để gửi sang JSP
        Gson gson = new Gson();
        request.setAttribute("growthLabels", gson.toJson(monthLabels));
        request.setAttribute("userGrowthValues", gson.toJson(finalUserGrowth));
        request.setAttribute("lessonGrowthValues", gson.toJson(finalLessonGrowth));
        request.setAttribute("vocabularyGrowthValues", gson.toJson(finalVocabGrowth));
        // ================== KẾT THÚC LOGIC XỬ LÝ BIỂU ĐỒ ==================

        // Gán các thống kê tổng quan vào request
        request.setAttribute("totalLessons", totalLessons);
        request.setAttribute("totalVocabulary", totalVocabulary);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalGrammarTopics", totalGrammarTopics);

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
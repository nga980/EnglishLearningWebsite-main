package controller;

import dao.LessonDAO;
import model.Lesson;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ManageLessonsServlet", urlPatterns = {"/admin/manage-lessons"})
public class ManageLessonsServlet extends HttpServlet {

    private LessonDAO lessonDAO;
    private static final int PAGE_SIZE = 5; // Số lượng bài học trên mỗi trang

    @Override
    public void init() {
        lessonDAO = new LessonDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // Lấy số trang hiện tại từ request parameter. Mặc định là trang 1.
        String pageStr = request.getParameter("page");
        int currentPage = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                currentPage = 1; // Nếu param không hợp lệ, quay về trang 1
            }
        }

        // Lấy tổng số bài học để tính tổng số trang
        int totalLessons = lessonDAO.countTotalLessons();
        int totalPages = (int) Math.ceil((double) totalLessons / PAGE_SIZE);

        // Đảm bảo currentPage không vượt quá tổng số trang
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }
        if (currentPage < 1) {
            currentPage = 1;
        }
        
        // Lấy danh sách bài học cho trang hiện tại
        List<Lesson> lessonList = lessonDAO.getLessonsByPage(currentPage, PAGE_SIZE);

        // Đặt các thuộc tính vào request để JSP có thể sử dụng
        request.setAttribute("lessonList", lessonList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/admin/manageLessons.jsp").forward(request, response);
    }
}
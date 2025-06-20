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

// Map servlet này với URL gốc của trang web
@WebServlet(name = "HomeServlet", urlPatterns = {"/home", ""})
public class HomeServlet extends HttpServlet {
    private LessonDAO lessonDAO;

    @Override
    public void init() {
        lessonDAO = new LessonDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy 6 bài học mới nhất để hiển thị trên trang chủ
        List<Lesson> recentLessonList = lessonDAO.getRecentLessons(6);
        request.setAttribute("recentLessonList", recentLessonList);

        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}
// File: src/main/java/controller/LessonDetailServlet.java
package controller;

import dao.LessonDAO;
import dao.VocabularyDAO; // Thêm import
import java.io.IOException;
import java.util.List; // Thêm import
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Lesson;
import model.Vocabulary; // Thêm import

@WebServlet(name = "LessonDetailServlet", urlPatterns = {"/lesson-detail"})
public class LessonDetailServlet extends HttpServlet {

    private LessonDAO lessonDAO;
    private VocabularyDAO vocabularyDAO; // Thêm DAO mới

    @Override
    public void init() {
        lessonDAO = new LessonDAO();
        vocabularyDAO = new VocabularyDAO(); // Khởi tạo
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String lessonIdStr = request.getParameter("lessonId");
        if (lessonIdStr != null) {
            try {
                int lessonId = Integer.parseInt(lessonIdStr);
                Lesson lesson = lessonDAO.getLessonById(lessonId);

                if (lesson != null) {
                    // LẤY THÊM TỪ VỰNG CỦA BÀI HỌC
                    List<Vocabulary> lessonVocabulary = vocabularyDAO.getVocabularyByLessonId(lessonId);
                    
                    request.setAttribute("lesson", lesson);
                    request.setAttribute("lessonVocabulary", lessonVocabulary); // Gửi danh sách từ vựng sang JSP
                    
                    request.getRequestDispatcher("lessonDetail.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy bài học với ID: " + lessonId);
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID bài học không hợp lệ.");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu ID bài học.");
        }
    }
}
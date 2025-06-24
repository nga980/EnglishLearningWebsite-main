package controller;

import dao.LessonDAO;
import dao.VocabularyDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Lesson;
import model.Vocabulary;

@WebServlet(name = "LessonDetailServlet", urlPatterns = {"/lesson-detail"})
public class LessonDetailServlet extends HttpServlet {

    private LessonDAO lessonDAO;
    private VocabularyDAO vocabularyDAO;

    @Override
    public void init() {
        lessonDAO = new LessonDAO();
        vocabularyDAO = new VocabularyDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String lessonIdStr = request.getParameter("lessonId");
        if (lessonIdStr != null && !lessonIdStr.trim().isEmpty()) {
            try {
                int lessonId = Integer.parseInt(lessonIdStr);
                Lesson lesson = lessonDAO.getLessonById(lessonId);

                if (lesson != null) {
                    // --- TỐI ƯU HÓA: Thay đổi lời gọi phương thức tại đây ---
                    // Gọi phương thức được tối ưu để không tải dữ liệu ảnh/audio không cần thiết.
                    // Điều này giúp trang tải nhanh hơn rất nhiều.
                    List<Vocabulary> lessonVocabulary = vocabularyDAO.getVocabularyByLessonIdForFlashcards(lessonId);
                    
                    request.setAttribute("lesson", lesson);
                    request.setAttribute("lessonVocabulary", lessonVocabulary); // Gửi danh sách từ vựng đã tối ưu sang JSP
                    
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
package controller;

import dao.LessonDAO;
import dao.VocabularyDAO;
import model.Lesson;
import model.Vocabulary;
import java.io.IOException;
import java.util.Collections;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet này xử lý việc hiển thị trang Flashcard.
 * Nó có thể hiển thị flashcard cho toàn bộ từ vựng hoặc chỉ cho một bài học cụ thể.
 */
@WebServlet(name = "FlashcardPageServlet", urlPatterns = {"/flashcards"})
public class FlashcardPageServlet extends HttpServlet {

    private VocabularyDAO vocabularyDAO;
    private LessonDAO lessonDAO;

    @Override
    public void init() {
        vocabularyDAO = new VocabularyDAO();
        lessonDAO = new LessonDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String lessonIdStr = request.getParameter("lessonId");
        List<Vocabulary> vocabList;

        if (lessonIdStr != null && !lessonIdStr.trim().isEmpty()) {
            // Trường hợp học theo bài
            try {
                int lessonId = Integer.parseInt(lessonIdStr);
                vocabList = vocabularyDAO.getVocabularyByLessonId(lessonId);
                Lesson lesson = lessonDAO.getLessonById(lessonId);
                if (lesson != null) {
                    request.setAttribute("lessonTitle", lesson.getTitle());
                }
            } catch (NumberFormatException e) {
                // Nếu lessonId không hợp lệ, tải tất cả từ vựng để tránh lỗi trang trắng
                vocabList = vocabularyDAO.getAllVocabulary();
            }
        } else {
            // Trường hợp ôn tập chung
            vocabList = vocabularyDAO.getAllVocabulary();
        }
        
        // Xáo trộn danh sách để mỗi lần học là một trải nghiệm mới
        if (vocabList != null) {
            Collections.shuffle(vocabList);
        }
        
        request.setAttribute("vocabularyList", vocabList);
        request.getRequestDispatcher("/flashcards.jsp").forward(request, response);
    }
}
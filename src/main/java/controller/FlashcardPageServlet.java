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
            try {
                int lessonId = Integer.parseInt(lessonIdStr);
                // --- UPDATE: Gọi phương thức đã tối ưu hóa ---
                vocabList = vocabularyDAO.getVocabularyByLessonIdForFlashcards(lessonId);
                Lesson lesson = lessonDAO.getLessonById(lessonId);
                if (lesson != null) {
                    request.setAttribute("lessonTitle", lesson.getTitle());
                }
            } catch (NumberFormatException e) {
                // ...
                // --- UPDATE: Gọi phương thức đã tối ưu hóa ---
                vocabList = vocabularyDAO.getAllVocabularyForFlashcards();
            }
        } else {
            // --- UPDATE: Gọi phương thức đã tối ưu hóa ---
            vocabList = vocabularyDAO.getAllVocabularyForFlashcards();
        }
        
        if (vocabList != null) {
            Collections.shuffle(vocabList);
        }
        
        request.setAttribute("vocabularyList", vocabList);
        request.getRequestDispatcher("/flashcards.jsp").forward(request, response);
    }
}
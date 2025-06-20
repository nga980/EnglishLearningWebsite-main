package controller; // Hoặc package controller của bạn

import dao.VocabularyDAO; // Hoặc package dao của bạn
import model.Vocabulary;  // Hoặc package model của bạn
// import dao.LessonDAO; // Tùy chọn: Nếu bạn muốn hiển thị dropdown chọn Lesson
// import model.Lesson;  // Tùy chọn
// import java.util.List; // Tùy chọn
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "EditVocabularyFormServlet", urlPatterns = {"/admin/edit-vocabulary-form"})
public class EditVocabularyFormServlet extends HttpServlet {

    private VocabularyDAO vocabularyDAO;
    // private LessonDAO lessonDAO; // Tùy chọn

    @Override
    public void init() {
        vocabularyDAO = new VocabularyDAO();
        // lessonDAO = new LessonDAO(); // Tùy chọn
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String vocabIdStr = request.getParameter("vocabId");
        if (vocabIdStr == null || vocabIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage_vocab", "Thiếu ID từ vựng để sửa.");
            response.sendRedirect(request.getContextPath() + "/admin/manage-vocabulary");
            return;
        }

        try {
            int vocabId = Integer.parseInt(vocabIdStr);
            Vocabulary vocabToEdit = vocabularyDAO.getVocabularyById(vocabId);

            if (vocabToEdit != null) {
                request.setAttribute("vocabToEdit", vocabToEdit);
                // Tùy chọn: Lấy danh sách bài học để tạo dropdown cho lessonId
                // List<Lesson> lessons = lessonDAO.getAllLessons();
                // request.setAttribute("lessonsForSelect", lessons);
                request.getRequestDispatcher("/admin/editVocabulary.jsp").forward(request, response);
            } else {
                session.setAttribute("errorMessage_vocab", "Không tìm thấy từ vựng với ID: " + vocabId);
                response.sendRedirect(request.getContextPath() + "/admin/manage-vocabulary");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage_vocab", "ID từ vựng không hợp lệ: " + vocabIdStr);
            response.sendRedirect(request.getContextPath() + "/admin/manage-vocabulary");
        }
    }
}
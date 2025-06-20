package controller; // Hoặc package controller của bạn

import dao.VocabularyDAO; // Hoặc package dao của bạn
import model.Vocabulary;  // Hoặc package model của bạn
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AddVocabularyServlet", urlPatterns = {"/admin/add-vocabulary-action"})
public class AddVocabularyServlet extends HttpServlet {

    private VocabularyDAO vocabularyDAO;

    @Override
    public void init() {
        vocabularyDAO = new VocabularyDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/addVocabulary.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();

        String word = request.getParameter("vocabWord");
        String meaning = request.getParameter("vocabMeaning");
        String example = request.getParameter("vocabExample");
        String lessonIdStr = request.getParameter("lessonId");

        if (word == null || word.trim().isEmpty() || meaning == null || meaning.trim().isEmpty()) {
            request.setAttribute("errorMessage_addVocab", "Từ (Word) và Nghĩa (Meaning) không được để trống.");
            request.getRequestDispatcher("/admin/addVocabulary.jsp").forward(request, response);
            return;
        }

        Vocabulary newVocab = new Vocabulary();
        newVocab.setWord(word);
        newVocab.setMeaning(meaning);
        newVocab.setExample(example);

        if (lessonIdStr != null && !lessonIdStr.trim().isEmpty()) {
            try {
                newVocab.setLessonId(Integer.parseInt(lessonIdStr));
            } catch (NumberFormatException e) {
                // Có thể bỏ qua lỗi này và để lessonId là null, hoặc báo lỗi
                // Hiện tại, nếu nhập sai thì lessonId sẽ là null (do default của Integer)
                // Hoặc bạn có thể báo lỗi và forward lại form
                request.setAttribute("errorMessage_addVocab", "Lesson ID không hợp lệ. Nếu nhập, phải là một con số.");
                request.getRequestDispatcher("/admin/addVocabulary.jsp").forward(request, response);
                return;
            }
        } // Nếu lessonIdStr rỗng hoặc null, newVocab.getLessonId() sẽ là null (đúng)

        boolean success = vocabularyDAO.addVocabulary(newVocab);

        if (success) {
            session.setAttribute("successMessage_vocab", "Thêm từ vựng mới thành công!");
        } else {
            session.setAttribute("errorMessage_vocab", "Thêm từ vựng thất bại. Vui lòng thử lại.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-vocabulary");
    }
}
package controller; // Hoặc package controller của bạn

import dao.VocabularyDAO; // Hoặc package dao của bạn
import model.Vocabulary;  // Hoặc package model của bạn
// import dao.LessonDAO; // Nếu cần validate lessonId tồn tại
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "UpdateVocabularyServlet", urlPatterns = {"/admin/update-vocabulary-action"})
public class UpdateVocabularyServlet extends HttpServlet {

    private VocabularyDAO vocabularyDAO;
    // private LessonDAO lessonDAO; // Nếu cần validate lessonId

    @Override
    public void init() {
        vocabularyDAO = new VocabularyDAO();
        // lessonDAO = new LessonDAO(); // Nếu cần
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();

        String vocabIdStr = request.getParameter("vocabId");
        String word = request.getParameter("vocabWord");
        String meaning = request.getParameter("vocabMeaning");
        String example = request.getParameter("vocabExample");
        String lessonIdStr = request.getParameter("lessonId");

        int vocabId = 0;
        if (vocabIdStr == null || vocabIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage_vocab", "ID từ vựng không hợp lệ hoặc bị thiếu.");
            response.sendRedirect(request.getContextPath() + "/admin/manage-vocabulary");
            return;
        }
        try {
            vocabId = Integer.parseInt(vocabIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage_vocab", "ID từ vựng không phải là số hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/manage-vocabulary");
            return;
        }

        if (word == null || word.trim().isEmpty() || meaning == null || meaning.trim().isEmpty()) {
            request.setAttribute("errorMessage_editVocab", "Từ (Word) và Nghĩa (Meaning) không được để trống.");
            // Để điền lại form, cần truyền lại các giá trị đã nhập và vocabId
            request.setAttribute("submittedVocabWord", word);
            request.setAttribute("submittedVocabMeaning", meaning);
            request.setAttribute("submittedVocabExample", example);
            request.setAttribute("submittedLessonId", lessonIdStr);

            // Cần đối tượng vocabToEdit để JSP hiển thị đúng cấu trúc form
            Vocabulary vocabDataForForm = vocabularyDAO.getVocabularyById(vocabId); // Lấy lại để giữ các giá trị khác nếu có
            if(vocabDataForForm == null) { // Trường hợp vocabId bị sửa thành không tồn tại
                 session.setAttribute("errorMessage_vocab", "Từ vựng không tồn tại để sửa.");
                 response.sendRedirect(request.getContextPath() + "/admin/manage-vocabulary");
                 return;
            }
            // Ghi đè các giá trị đã submit lên đối tượng này để form hiển thị đúng
            vocabDataForForm.setWord(word); 
            vocabDataForForm.setMeaning(meaning);
            vocabDataForForm.setExample(example);
            if (lessonIdStr != null && !lessonIdStr.trim().isEmpty()) {
                 try { vocabDataForForm.setLessonId(Integer.parseInt(lessonIdStr)); } catch (NumberFormatException ignored) {}
            } else {
                 vocabDataForForm.setLessonId(null);
            }
            request.setAttribute("vocabToEdit", vocabDataForForm);

            request.getRequestDispatcher("/admin/editVocabulary.jsp").forward(request, response);
            return;
        }

        Vocabulary vocabToUpdate = new Vocabulary();
        vocabToUpdate.setVocabId(vocabId);
        vocabToUpdate.setWord(word);
        vocabToUpdate.setMeaning(meaning);
        vocabToUpdate.setExample(example);

        if (lessonIdStr != null && !lessonIdStr.trim().isEmpty()) {
            try {
                vocabToUpdate.setLessonId(Integer.parseInt(lessonIdStr));
                // Tùy chọn: Kiểm tra xem lessonId có tồn tại không
                // if (lessonDAO.getLessonById(vocabToUpdate.getLessonId()) == null) {
                //     request.setAttribute("errorMessage_editVocab", "Lesson ID không tồn tại.");
                //     request.setAttribute("vocabToEdit", vocabToUpdate); // Để điền lại form
                //     request.getRequestDispatcher("/admin/editVocabulary.jsp").forward(request, response);
                //     return;
                // }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage_editVocab", "Lesson ID không hợp lệ. Nếu nhập, phải là một con số.");
                request.setAttribute("vocabToEdit", vocabToUpdate); // Để điền lại form
                request.getRequestDispatcher("/admin/editVocabulary.jsp").forward(request, response);
                return;
            }
        } else {
            vocabToUpdate.setLessonId(null);
        }

        boolean success = vocabularyDAO.updateVocabulary(vocabToUpdate);

        if (success) {
            session.setAttribute("successMessage_vocab", "Cập nhật từ vựng ID " + vocabId + " thành công!");
        } else {
            session.setAttribute("errorMessage_vocab", "Cập nhật từ vựng ID " + vocabId + " thất bại.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-vocabulary");
    }
}
package controller;

import dao.VocabularyDAO;
import model.Vocabulary;
import java.io.IOException;
import java.io.InputStream;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet(name = "UpdateVocabularyServlet", urlPatterns = {"/admin/update-vocabulary-action"})
@MultipartConfig
public class UpdateVocabularyServlet extends HttpServlet {

    private VocabularyDAO vocabularyDAO;

    @Override
    public void init() {
        vocabularyDAO = new VocabularyDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String vocabIdStr = request.getParameter("vocabId");
        String word = request.getParameter("vocabWord");
        String meaning = request.getParameter("vocabMeaning");
        String example = request.getParameter("vocabExample");
        String lessonIdStr = request.getParameter("lessonId");

        int vocabId = 0;
        try {
            vocabId = Integer.parseInt(vocabIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage_vocab", "ID từ vựng không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/manage-vocabulary");
            return;
        }

        Vocabulary vocabToUpdate = vocabularyDAO.getVocabularyById(vocabId);
        if (vocabToUpdate == null) {
            session.setAttribute("errorMessage_vocab", "Không tìm thấy từ vựng để cập nhật.");
            response.sendRedirect(request.getContextPath() + "/admin/manage-vocabulary");
            return;
        }

        if (word == null || word.trim().isEmpty() || meaning == null || meaning.trim().isEmpty()) {
            session.setAttribute("errorMessage_vocab", "Từ (Word) và Nghĩa (Meaning) không được để trống.");
            response.sendRedirect(request.getContextPath() + "/admin/edit-vocabulary-form?vocabId=" + vocabId);
            return;
        }

        byte[] newImageData = getBytesFromPart(request.getPart("imageFile"));
        byte[] newAudioData = getBytesFromPart(request.getPart("audioFile"));

        vocabToUpdate.setWord(word);
        vocabToUpdate.setMeaning(meaning);
        vocabToUpdate.setExample(example);

        if (newImageData != null) {
            vocabToUpdate.setImageData(newImageData);
        }
        if (newAudioData != null) {
            vocabToUpdate.setAudioData(newAudioData);
        }
        
        if (lessonIdStr != null && !lessonIdStr.trim().isEmpty()) {
            try {
                vocabToUpdate.setLessonId(Integer.parseInt(lessonIdStr));
            } catch (NumberFormatException e) {
                vocabToUpdate.setLessonId(null);
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

    private byte[] getBytesFromPart(Part part) throws IOException {
        if (part == null || part.getSize() == 0) {
            return null;
        }
        try (InputStream inputStream = part.getInputStream()) {
            return inputStream.readAllBytes();
        }
    }
}
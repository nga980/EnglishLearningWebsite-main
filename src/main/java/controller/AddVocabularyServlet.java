package controller;

import dao.VocabularyDAO;
import model.Vocabulary;
import java.io.IOException;
import util.S3ClientUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

/**
 * Servlet xử lý việc thêm từ vựng mới, bao gồm upload file ảnh và audio lên S3
 * và lưu URL tương ứng vào cơ sở dữ liệu.
 */
@WebServlet(name = "AddVocabularyServlet", urlPatterns = {"/admin/add-vocabulary-action"})
@MultipartConfig // Bắt buộc phải có để xử lý form có file upload
public class AddVocabularyServlet extends HttpServlet {

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

        // Lấy dữ liệu từ các trường text
        String word = request.getParameter("vocabWord");
        String meaning = request.getParameter("vocabMeaning");
        String example = request.getParameter("vocabExample");
        String lessonIdStr = request.getParameter("lessonId");

        // Validation cơ bản
        if (word == null || word.trim().isEmpty() || meaning == null || meaning.trim().isEmpty()) {
            request.setAttribute("errorMessage_addVocab", "Từ (Word) và Nghĩa (Meaning) không được để trống.");
            request.getRequestDispatcher("/admin/addVocabulary.jsp").forward(request, response);
            return;
        }
        
        Part imagePart = request.getPart("imageFile");
        Part audioPart = request.getPart("audioFile");

        String imageUrl = null;
        if (imagePart != null && imagePart.getSize() > 0) {
            imageUrl = S3ClientUtil.upload(imagePart.getInputStream(), imagePart.getSubmittedFileName(), imagePart.getSize());
        }

        String audioUrl = null;
        if (audioPart != null && audioPart.getSize() > 0) {
            audioUrl = S3ClientUtil.upload(audioPart.getInputStream(), audioPart.getSubmittedFileName(), audioPart.getSize());
        }

        // Tạo đối tượng Vocabulary mới
        Vocabulary newVocab = new Vocabulary();
        newVocab.setWord(word);
        newVocab.setMeaning(meaning);
        newVocab.setExample(example);
        newVocab.setImageUrl(imageUrl);
        newVocab.setAudioUrl(audioUrl);

        // Xử lý lessonId (có thể null)
        if (lessonIdStr != null && !lessonIdStr.trim().isEmpty()) {
            try {
                newVocab.setLessonId(Integer.parseInt(lessonIdStr));
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage_addVocab", "Lesson ID không hợp lệ. Nếu nhập, phải là một con số.");
                request.getRequestDispatcher("/admin/addVocabulary.jsp").forward(request, response);
                return;
            }
        }
        
        // Gọi DAO để lưu vào CSDL
        boolean success = vocabularyDAO.addVocabulary(newVocab);

        // Đặt thông báo kết quả và chuyển hướng
        if (success) {
            session.setAttribute("successMessage_vocab", "Thêm từ vựng mới thành công!");
        } else {
            session.setAttribute("errorMessage_vocab", "Thêm từ vựng thất bại. Vui lòng thử lại.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-vocabulary");
    }
    
    // Không cần phương thức trợ giúp đọc toàn bộ file vào bộ nhớ
}
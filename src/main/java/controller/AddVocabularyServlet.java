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

/**
 * Servlet xử lý việc thêm từ vựng mới, bao gồm cả việc upload file ảnh và audio
 * trực tiếp vào cơ sở dữ liệu dưới dạng BLOB.
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
        
        // Đọc dữ liệu của file được upload thành mảng byte[]
        byte[] imageData = getBytesFromPart(request.getPart("imageFile"));
        byte[] audioData = getBytesFromPart(request.getPart("audioFile"));

        // Tạo đối tượng Vocabulary mới
        Vocabulary newVocab = new Vocabulary();
        newVocab.setWord(word);
        newVocab.setMeaning(meaning);
        newVocab.setExample(example);
        
        // Gán dữ liệu nhị phân vào đối tượng
        newVocab.setImageData(imageData);
        newVocab.setAudioData(audioData);

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
    
    /**
     * Hàm trợ giúp để đọc dữ liệu từ một Part (file upload) và chuyển thành mảng byte.
     * @param part Đối tượng Part chứa dữ liệu file.
     * @return Mảng byte của file, hoặc null nếu không có file hoặc file rỗng.
     * @throws IOException
     */
    private byte[] getBytesFromPart(Part part) throws IOException {
        if (part == null || part.getSize() == 0) {
            return null;
        }
        try (InputStream inputStream = part.getInputStream()) {
            // inputStream.readAllBytes() là cách hiện đại để đọc toàn bộ stream
            return inputStream.readAllBytes();
        }
    }
}
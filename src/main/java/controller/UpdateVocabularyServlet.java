package controller;

import dao.VocabularyDAO;
import model.Vocabulary;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet(name = "UpdateVocabularyServlet", urlPatterns = {"/admin/update-vocabulary-action"})
@MultipartConfig // QUAN TRỌNG: Bật chế độ xử lý file upload
public class UpdateVocabularyServlet extends HttpServlet {

    private VocabularyDAO vocabularyDAO;
    private static final String UPLOAD_DIR = "uploads";

    @Override
    public void init() {
        vocabularyDAO = new VocabularyDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // Lấy dữ liệu từ form
        String vocabIdStr = request.getParameter("vocabId");
        String word = request.getParameter("vocabWord");
        String meaning = request.getParameter("vocabMeaning");
        String example = request.getParameter("vocabExample");
        String lessonIdStr = request.getParameter("lessonId");
        
        // Lấy đường dẫn của file cũ từ hidden input
        String existingImageUrl = request.getParameter("existingImageUrl");
        String existingAudioUrl = request.getParameter("existingAudioUrl");

        // --- Validation cơ bản ---
        int vocabId = 0;
        try {
            vocabId = Integer.parseInt(vocabIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage_vocab", "ID từ vựng không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/manage-vocabulary");
            return;
        }
        
        if (word == null || word.trim().isEmpty() || meaning == null || meaning.trim().isEmpty()) {
            // Xử lý lỗi validation và forward lại form
            // (Bạn có thể thêm logic để gửi lại đối tượng vocabToEdit để form điền lại)
            session.setAttribute("errorMessage_vocab", "Từ (Word) và Nghĩa (Meaning) không được để trống.");
            response.sendRedirect(request.getContextPath() + "/admin/edit-vocabulary-form?vocabId=" + vocabId);
            return;
        }

        // --- Xử lý file upload ---
        // Thử tải lên file mới
        String newImageUrl = uploadFile(request, "imageFile", "images");
        String newAudioUrl = uploadFile(request, "audioFile", "audio");

        // Quyết định đường dẫn cuối cùng
        // Nếu có file mới được tải lên, sử dụng nó. Ngược lại, giữ file cũ.
        String finalImageUrl = (newImageUrl != null) ? newImageUrl : existingImageUrl;
        String finalAudioUrl = (newAudioUrl != null) ? newAudioUrl : existingAudioUrl;
        
        // (Tùy chọn nhưng khuyến khích) Xóa file cũ nếu có file mới được tải lên để thay thế
        if (newImageUrl != null && existingImageUrl != null && !existingImageUrl.isEmpty()) {
            deleteFile(existingImageUrl, request);
        }
        if (newAudioUrl != null && existingAudioUrl != null && !existingAudioUrl.isEmpty()) {
            deleteFile(existingAudioUrl, request);
        }

        // --- Cập nhật đối tượng và lưu vào CSDL ---
        Vocabulary vocabToUpdate = new Vocabulary();
        vocabToUpdate.setVocabId(vocabId);
        vocabToUpdate.setWord(word);
        vocabToUpdate.setMeaning(meaning);
        vocabToUpdate.setExample(example);
        vocabToUpdate.setImageUrl(finalImageUrl);
        vocabToUpdate.setAudioUrl(finalAudioUrl);

        if (lessonIdStr != null && !lessonIdStr.trim().isEmpty()) {
            try {
                vocabToUpdate.setLessonId(Integer.parseInt(lessonIdStr));
            } catch (NumberFormatException e) {
                // Xử lý lỗi nếu cần
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

    private String uploadFile(HttpServletRequest request, String partName, String subDir) throws IOException, ServletException {
        Part filePart = request.getPart(partName);
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        if (fileName.isEmpty()) {
            return null;
        }
        String uniqueFileName = System.currentTimeMillis() + "_" + fileName.replaceAll("[^a-zA-Z0-9.-]", "_");
        String applicationPath = getServletContext().getRealPath("");
        String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR + File.separator + subDir;
        File uploadDir = new File(uploadFilePath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        filePart.write(uploadFilePath + File.separator + uniqueFileName);
        return UPLOAD_DIR + "/" + subDir + "/" + uniqueFileName;
    }
    
    private void deleteFile(String relativePath, HttpServletRequest request) {
        if (relativePath == null || relativePath.isEmpty()) {
            return;
        }
        String applicationPath = request.getServletContext().getRealPath("");
        File fileToDelete = new File(applicationPath + File.separator + relativePath);
        if (fileToDelete.exists()) {
            fileToDelete.delete();
        }
    }
}
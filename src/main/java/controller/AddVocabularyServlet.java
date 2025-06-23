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

@WebServlet(name = "AddVocabularyServlet", urlPatterns = {"/admin/add-vocabulary-action"})
@MultipartConfig
public class AddVocabularyServlet extends HttpServlet {

    private VocabularyDAO vocabularyDAO;
    private static final String UPLOAD_DIR = "uploads";

    @Override
    public void init() {
        vocabularyDAO = new VocabularyDAO();
    }
    
    // THAY ĐỔI LẠI: Xóa doGet để servlet không chuyển hướng lung tung
    // và chỉ chấp nhận phương thức POST.
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
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
        
        String imageUrl = uploadFile(request, "imageFile", "images");
        String audioUrl = uploadFile(request, "audioFile", "audio");

        Vocabulary newVocab = new Vocabulary();
        newVocab.setWord(word);
        newVocab.setMeaning(meaning);
        newVocab.setExample(example);
        // Các trường mới cho upload file
        newVocab.setImageUrl(imageUrl);
        newVocab.setAudioUrl(audioUrl);

        if (lessonIdStr != null && !lessonIdStr.trim().isEmpty()) {
            try {
                newVocab.setLessonId(Integer.parseInt(lessonIdStr));
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage_addVocab", "Lesson ID không hợp lệ. Nếu nhập, phải là một con số.");
                request.getRequestDispatcher("/admin/addVocabulary.jsp").forward(request, response);
                return;
            }
        }
        
        boolean success = vocabularyDAO.addVocabulary(newVocab);

        // THAY ĐỔI LẠI: Sử dụng các key message riêng biệt như cũ
        if (success) {
            session.setAttribute("successMessage_vocab", "Thêm từ vựng mới thành công!");
        } else {
            session.setAttribute("errorMessage_vocab", "Thêm từ vựng thất bại. Vui lòng thử lại.");
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
}
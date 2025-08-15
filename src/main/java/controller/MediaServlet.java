package controller;

import dao.VocabularyDAO;
import model.Vocabulary;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;

/**
 * Servlet này xử lý việc trả về dữ liệu media (ảnh, audio) cho các flashcard.
 * Nó lắng nghe tại URL /media và trả về dữ liệu byte dựa trên vocabId và type.
 */
@WebServlet(name = "MediaServlet", urlPatterns = {"/media"})
public class MediaServlet extends HttpServlet {

    private VocabularyDAO vocabularyDAO;

    @Override
    public void init() {
        vocabularyDAO = new VocabularyDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String vocabIdStr = request.getParameter("id");
        String type = request.getParameter("type");

        if (vocabIdStr == null || type == null || vocabIdStr.trim().isEmpty() || type.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing 'id' or 'type' parameter.");
            return;
        }

        try {
            int vocabId = Integer.parseInt(vocabIdStr);
            Vocabulary vocab = vocabularyDAO.getVocabularyById(vocabId); // Bạn cần có phương thức này trong DAO

            if (vocab == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Vocabulary not found.");
                return;
            }

            byte[] mediaData = null;
            String contentType = null;

            if ("image".equalsIgnoreCase(type)) {
                mediaData = vocab.getImageData(); // Cần có getter getImageData() trong model
                // Giả sử bạn lưu ảnh PNG hoặc JPEG. Thay đổi cho phù hợp.
                contentType = getServletContext().getMimeType("image.jpg"); // "image/jpeg"
            } else if ("audio".equalsIgnoreCase(type)) {
                mediaData = vocab.getAudioData(); // Cần có getter getAudioData() trong model
                // Giả sử bạn lưu audio MP3. Thay đổi cho phù hợp.
                contentType = getServletContext().getMimeType("audio.mp3"); // "audio/mpeg"
            }

            if (mediaData != null && mediaData.length > 0) {
                response.setContentType(contentType);
                response.setContentLength(mediaData.length);
                
                // Ghi dữ liệu vào response
                try (OutputStream out = response.getOutputStream()) {
                    out.write(mediaData);
                }
            } else {
                // Không có dữ liệu media tương ứng
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Media data not found for this vocabulary.");
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid 'id' parameter.");
        } catch (Exception e) {
            // Ghi log lỗi để gỡ lỗi
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while retrieving media.");
        }
    }
}
package controller;

import dao.VocabularyDAO;
import model.Vocabulary;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet này xử lý việc lấy URL media (ảnh, audio) cho các flashcard.
 * Nó lắng nghe tại URL /media và chuyển hướng tới URL đã lưu trong cơ sở dữ liệu.
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

            String mediaUrl = null;
            if ("image".equalsIgnoreCase(type)) {
                mediaUrl = vocab.getImageUrl();
            } else if ("audio".equalsIgnoreCase(type)) {
                mediaUrl = vocab.getAudioUrl();
            }

            if (mediaUrl != null && !mediaUrl.trim().isEmpty()) {
                response.sendRedirect(mediaUrl);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Media URL not found for this vocabulary.");
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
package controller;

import dao.VocabularyDAO;
import model.Vocabulary;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.OutputStream;

@WebServlet("/media")
public class MediaServlet extends HttpServlet {
    private VocabularyDAO vocabularyDAO;

    @Override
    public void init() {
        vocabularyDAO = new VocabularyDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int vocabId = Integer.parseInt(request.getParameter("id"));
            String type = request.getParameter("type"); // "image" hoặc "audio"

            Vocabulary vocab = vocabularyDAO.getVocabularyById(vocabId);

            if (vocab != null) {
                byte[] content = null;
                if ("image".equals(type) && vocab.getHasImage()) {
                    content = vocab.getImageData();
                    response.setContentType("image/jpeg"); // Hoặc một kiểu chung hơn
                } else if ("audio".equals(type) && vocab.getHasAudio()) {
                    content = vocab.getAudioData();
                    response.setContentType("audio/mpeg"); // Hoặc một kiểu chung hơn
                }

                if (content != null) {
                    response.setContentLength(content.length);
                    try (OutputStream os = response.getOutputStream()) {
                        os.write(content);
                    }
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND); // Không có media
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND); // Không tìm thấy vocab
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST); // ID không hợp lệ
        }
    }
}
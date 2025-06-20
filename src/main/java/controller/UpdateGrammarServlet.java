package controller;

import dao.GrammarTopicDAO;
import model.GrammarTopic;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "UpdateGrammarServlet", urlPatterns = {"/admin/update-grammar-action"})
public class UpdateGrammarServlet extends HttpServlet {
    private GrammarTopicDAO grammarTopicDAO;

    @Override
    public void init() {
        grammarTopicDAO = new GrammarTopicDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        try {
            int topicId = Integer.parseInt(request.getParameter("topicId"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String exampleSentences = request.getParameter("exampleSentences");
            String difficultyLevel = request.getParameter("difficultyLevel");

            if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
                // Xử lý validation lỗi và forward lại
                request.setAttribute("errorMessage_editGrammar", "Tiêu đề và Nội dung không được để trống.");
                GrammarTopic topicForForm = new GrammarTopic(topicId, title, content, exampleSentences, difficultyLevel, null);
                request.setAttribute("topicToEdit", topicForForm);
                request.getRequestDispatcher("/admin/editGrammar.jsp").forward(request, response);
                return;
            }

            GrammarTopic topicToUpdate = new GrammarTopic(topicId, title, content, exampleSentences, difficultyLevel, null);
            boolean success = grammarTopicDAO.updateGrammarTopic(topicToUpdate);

            if (success) {
                session.setAttribute("successMessage_grammar", "Cập nhật chủ đề ngữ pháp ID " + topicId + " thành công!");
            } else {
                session.setAttribute("errorMessage_grammar", "Cập nhật chủ đề ngữ pháp ID " + topicId + " thất bại.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/manage-grammar");

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage_grammar", "ID chủ đề ngữ pháp không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/manage-grammar");
        }
    }
}
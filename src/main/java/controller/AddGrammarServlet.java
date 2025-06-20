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

@WebServlet(name = "AddGrammarServlet", urlPatterns = {"/admin/add-grammar-action"})
public class AddGrammarServlet extends HttpServlet {
    private GrammarTopicDAO grammarTopicDAO;

    @Override
    public void init() {
        grammarTopicDAO = new GrammarTopicDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String exampleSentences = request.getParameter("exampleSentences");
        String difficultyLevel = request.getParameter("difficultyLevel");

        if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
            request.setAttribute("errorMessage_addGrammar", "Tiêu đề và Nội dung không được để trống.");
            request.getRequestDispatcher("/admin/addGrammar.jsp").forward(request, response);
            return;
        }

        GrammarTopic newTopic = new GrammarTopic();
        newTopic.setTitle(title);
        newTopic.setContent(content);
        newTopic.setExampleSentences(exampleSentences);
        newTopic.setDifficultyLevel(difficultyLevel);

        boolean success = grammarTopicDAO.addGrammarTopic(newTopic);

        if (success) {
            session.setAttribute("successMessage_grammar", "Thêm chủ đề ngữ pháp mới thành công!");
        } else {
            session.setAttribute("errorMessage_grammar", "Thêm chủ đề ngữ pháp thất bại.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-grammar");
    }
}
package controller;

import dao.GrammarTopicDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "DeleteGrammarServlet", urlPatterns = {"/admin/delete-grammar"})
public class DeleteGrammarServlet extends HttpServlet {
    private GrammarTopicDAO grammarTopicDAO;

    @Override
    public void init() {
        grammarTopicDAO = new GrammarTopicDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
            int topicId = Integer.parseInt(request.getParameter("topicId"));
            boolean success = grammarTopicDAO.deleteGrammarTopic(topicId);

            if (success) {
                session.setAttribute("successMessage_grammar", "Xóa chủ đề ngữ pháp ID " + topicId + " thành công!");
            } else {
                session.setAttribute("errorMessage_grammar", "Xóa chủ đề ngữ pháp ID " + topicId + " thất bại.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage_grammar", "ID chủ đề ngữ pháp không hợp lệ.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-grammar");
    }
}
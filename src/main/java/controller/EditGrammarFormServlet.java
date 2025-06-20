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

@WebServlet(name = "EditGrammarFormServlet", urlPatterns = {"/admin/edit-grammar-form"})
public class EditGrammarFormServlet extends HttpServlet {
    private GrammarTopicDAO grammarTopicDAO;

    @Override
    public void init() {
        grammarTopicDAO = new GrammarTopicDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        String topicIdStr = request.getParameter("topicId");

        try {
            int topicId = Integer.parseInt(topicIdStr);
            GrammarTopic topicToEdit = grammarTopicDAO.getGrammarTopicById(topicId);
            if (topicToEdit != null) {
                request.setAttribute("topicToEdit", topicToEdit);
                request.getRequestDispatcher("/admin/editGrammar.jsp").forward(request, response);
            } else {
                session.setAttribute("errorMessage_grammar", "Không tìm thấy chủ đề ngữ pháp với ID: " + topicId);
                response.sendRedirect(request.getContextPath() + "/admin/manage-grammar");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage_grammar", "ID chủ đề ngữ pháp không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/manage-grammar");
        }
    }
}
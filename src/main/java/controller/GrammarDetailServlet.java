package controller; 

import dao.GrammarTopicDAO;
import model.GrammarTopic;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "GrammarDetailServlet", urlPatterns = {"/grammar-detail"})
public class GrammarDetailServlet extends HttpServlet {

    private GrammarTopicDAO grammarTopicDAO;

    @Override
    public void init() {
        grammarTopicDAO = new GrammarTopicDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String topicIdStr = request.getParameter("topicId");
        if (topicIdStr != null) {
            try {
                int topicId = Integer.parseInt(topicIdStr);
                GrammarTopic topic = grammarTopicDAO.getGrammarTopicById(topicId);

                if (topic != null) {
                    request.setAttribute("grammarTopic", topic);
                    request.getRequestDispatcher("grammarDetail.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy chủ đề ngữ pháp với ID: " + topicId);
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID chủ đề ngữ pháp không hợp lệ.");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu ID chủ đề ngữ pháp.");
        }
    }
}
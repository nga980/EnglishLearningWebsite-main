package controller;

import dao.GrammarTopicDAO;
import model.GrammarTopic;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "GrammarListServlet", urlPatterns = {"/grammar"})
public class GrammarListServlet extends HttpServlet {

    private GrammarTopicDAO grammarTopicDAO;
    private static final int PAGE_SIZE = 10;

    @Override
    public void init() {
        grammarTopicDAO = new GrammarTopicDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String pageStr = request.getParameter("page");
        int currentPage = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        int totalTopics = grammarTopicDAO.countTotalGrammarTopics();
        int totalPages = (int) Math.ceil((double) totalTopics / PAGE_SIZE);
        
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }
        if (currentPage < 1) {
            currentPage = 1;
        }

        List<GrammarTopic> grammarTopicList = grammarTopicDAO.getGrammarTopicsByPage(currentPage, PAGE_SIZE);

        request.setAttribute("grammarTopicList", grammarTopicList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("grammar.jsp").forward(request, response);
    }
}
package controller;

import dao.GrammarTopicDAO;
import model.GrammarTopic;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

@WebServlet(name = "ManageGrammarServlet", urlPatterns = {"/admin/manage-grammar"})
public class ManageGrammarServlet extends BaseManageServlet<GrammarTopic> {

    private GrammarTopicDAO grammarTopicDAO;

    @Override
    public void init() {
        grammarTopicDAO = new GrammarTopicDAO();
    }

    @Override
    protected int getTotalItems() {
        return grammarTopicDAO.countTotalGrammarTopics();
    }

    @Override
    protected List<GrammarTopic> getItemsByPage(int currentPage, int pageSize) {
        return grammarTopicDAO.getGrammarTopicsByPage(currentPage, pageSize);
    }

    @Override
    protected String getItemListAttributeName() {
        return "grammarTopicList";
    }

    @Override
    protected String getTotalItemsAttributeName() {
        return "totalTopics";
    }

    @Override
    protected String getJspPage() {
        return "/admin/manageGrammar.jsp";
    }
    
    // Giữ nguyên PAGE_SIZE mặc định là 10
}
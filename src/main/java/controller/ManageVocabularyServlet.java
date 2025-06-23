package controller;

import dao.VocabularyDAO;
import model.Vocabulary;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

@WebServlet(name = "ManageVocabularyServlet", urlPatterns = {"/admin/manage-vocabulary"})
public class ManageVocabularyServlet extends BaseManageServlet<Vocabulary> {

    private VocabularyDAO vocabularyDAO;

    @Override
    public void init() {
        vocabularyDAO = new VocabularyDAO();
    }

    @Override
    protected int getTotalItems() {
        return vocabularyDAO.countTotalVocabulary();
    }

    @Override
    protected List<Vocabulary> getItemsByPage(int currentPage, int pageSize) {
        return vocabularyDAO.getVocabularyByPage(currentPage, pageSize);
    }

    @Override
    protected String getItemListAttributeName() {
        return "vocabularyList";
    }

    @Override
    protected String getTotalItemsAttributeName() {
        return "totalVocabulary";
    }

    @Override
    protected String getJspPage() {
        return "/admin/manageVocabulary.jsp";
    }
    
    // Giữ nguyên PAGE_SIZE mặc định là 10
}
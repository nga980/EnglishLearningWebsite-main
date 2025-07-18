package controller;

import dao.VocabularyDAO;
import model.Vocabulary;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "VocabularyListServlet", urlPatterns = {"/vocabulary"})
public class VocabularyListServlet extends HttpServlet {

    private VocabularyDAO vocabularyDAO;
    private static final int PAGE_SIZE = 15; // Hiển thị 15 từ vựng trên mỗi trang

    @Override
    public void init() {
        vocabularyDAO = new VocabularyDAO();
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

        int totalVocabulary = vocabularyDAO.countTotalVocabulary();
        int totalPages = (int) Math.ceil((double) totalVocabulary / PAGE_SIZE);
        
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }
        if (currentPage < 1) {
            currentPage = 1;
        }

        // === THAY ĐỔI TỐI ƯU HÓA TẠI ĐÂY ===
        // Gọi phương thức mới để chỉ tải cờ media, giúp trang nhanh hơn.
        List<Vocabulary> vocabularyList = vocabularyDAO.getVocabularyByPageForFlashcards(currentPage, PAGE_SIZE);

        request.setAttribute("vocabularyList", vocabularyList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("vocabulary.jsp").forward(request, response);
    }
}
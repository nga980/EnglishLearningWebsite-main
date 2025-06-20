package controller;

import dao.GrammarTopicDAO;
import dao.LessonDAO;
import dao.VocabularyDAO;
import model.GrammarTopic;
import model.Lesson;
import model.Vocabulary;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "SearchServlet", urlPatterns = {"/search"})
public class SearchServlet extends HttpServlet {
    private LessonDAO lessonDAO;
    private VocabularyDAO vocabularyDAO;
    private GrammarTopicDAO grammarTopicDAO;

    @Override
    public void init() {
        lessonDAO = new LessonDAO();
        vocabularyDAO = new VocabularyDAO();
        grammarTopicDAO = new GrammarTopicDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String keyword = request.getParameter("keyword");
        if (keyword != null && !keyword.trim().isEmpty()) {
            keyword = keyword.trim();

            // Gọi các phương thức search từ các DAO
            List<Lesson> lessonResults = lessonDAO.searchLessons(keyword);
            List<Vocabulary> vocabResults = vocabularyDAO.searchVocabulary(keyword);
            List<GrammarTopic> grammarResults = grammarTopicDAO.searchGrammarTopics(keyword);

            // Đặt các danh sách kết quả vào request
            request.setAttribute("lessonResults", lessonResults);
            request.setAttribute("vocabResults", vocabResults);
            request.setAttribute("grammarResults", grammarResults);
            request.setAttribute("searchedKeyword", keyword); // Để hiển thị lại từ khóa đã tìm
        }
        // Nếu keyword rỗng hoặc null, sẽ không có kết quả nào được đặt, trang JSP sẽ hiển thị thông báo "vui lòng nhập"

        request.getRequestDispatcher("searchResult.jsp").forward(request, response);
    }
}
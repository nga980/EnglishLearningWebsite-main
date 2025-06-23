package controller;

import dao.LessonDAO;
import model.Lesson;
import jakarta.servlet.annotation.WebServlet;
import java.util.List;

@WebServlet(name = "ManageLessonsServlet", urlPatterns = {"/admin/manage-lessons"})
public class ManageLessonsServlet extends BaseManageServlet<Lesson> {

    private LessonDAO lessonDAO;

    @Override
    public void init() {
        lessonDAO = new LessonDAO();
    }
    
    @Override
    protected int getTotalItems() {
        return lessonDAO.countTotalLessons();
    }

    @Override
    protected List<Lesson> getItemsByPage(int currentPage, int pageSize) {
        return lessonDAO.getLessonsByPage(currentPage, pageSize);
    }

    @Override
    protected String getItemListAttributeName() {
        return "lessonList";
    }

    @Override
    protected String getTotalItemsAttributeName() {
        return "totalLessons";
    }

    @Override
    protected String getJspPage() {
        return "/admin/manageLessons.jsp";
    }

    @Override
    protected int getPageSize() {
        return 5; // Giữ nguyên pageSize là 5 cho trang này
    }
}
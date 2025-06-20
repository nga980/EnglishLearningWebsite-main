package controller;

import dao.LessonDAO;
import dao.QuizDAO;
import model.Lesson;
import model.QuizQuestion;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet để quản lý quiz (câu hỏi & lựa chọn) cho một bài học cụ thể.
 */
@WebServlet(name = "ManageQuizServlet", urlPatterns = {"/admin/manage-quiz"})
public class ManageQuizServlet extends HttpServlet {

    private QuizDAO quizDAO;
    private LessonDAO lessonDAO;

    @Override
    public void init() {
        quizDAO = new QuizDAO();
        lessonDAO = new LessonDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String lessonIdStr = request.getParameter("lessonId");
        if (lessonIdStr == null || lessonIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Thiếu ID bài học để quản lý quiz.");
            response.sendRedirect(request.getContextPath() + "/admin/manage-lessons");
            return;
        }

        try {
            int lessonId = Integer.parseInt(lessonIdStr);
            // Lấy thông tin bài học để hiển thị tiêu đề
            Lesson lesson = lessonDAO.getLessonById(lessonId);

            if (lesson != null) {
                // Lấy danh sách câu hỏi của bài học
                List<QuizQuestion> questions = quizDAO.getQuestionsByLessonId(lessonId);

                request.setAttribute("lesson", lesson);
                request.setAttribute("questionList", questions);
                request.getRequestDispatcher("/admin/manageQuiz.jsp").forward(request, response);
            } else {
                session.setAttribute("errorMessage", "Không tìm thấy bài học với ID: " + lessonId);
                response.sendRedirect(request.getContextPath() + "/admin/manage-lessons");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID bài học không hợp lệ: " + lessonIdStr);
            response.sendRedirect(request.getContextPath() + "/admin/manage-lessons");
        }
    }
}
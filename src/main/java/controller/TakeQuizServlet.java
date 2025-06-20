package controller;

import dao.LessonDAO;
import dao.QuizDAO;
import model.Lesson;
import model.QuizQuestion;
import java.io.IOException;
import java.util.Collections;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "TakeQuizServlet", urlPatterns = {"/take-quiz"})
public class TakeQuizServlet extends HttpServlet {
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

        String lessonIdStr = request.getParameter("lessonId");
        if (lessonIdStr == null) {
            // Nếu không có lessonId, chuyển về trang bài học
            response.sendRedirect(request.getContextPath() + "/lessons");
            return;
        }

        try {
            int lessonId = Integer.parseInt(lessonIdStr);
            Lesson lesson = lessonDAO.getLessonById(lessonId);
            List<QuizQuestion> questions = quizDAO.getQuestionsByLessonId(lessonId);

            // Nếu không có bài học hoặc không có câu hỏi, quay về trang chi tiết bài học
            if (lesson == null || questions.isEmpty()) {
                request.setAttribute("quizMessage", "Bài học này hiện chưa có bài trắc nghiệm.");
                // Cần set lại lesson để forward về trang chi tiết
                request.setAttribute("lesson", lesson);
                request.getRequestDispatcher("/lessonDetail.jsp").forward(request, response);
                return;
            }

            // Xáo trộn thứ tự các lựa chọn trong mỗi câu hỏi (tùy chọn, để tăng độ khó)
            for (QuizQuestion question : questions) {
                Collections.shuffle(question.getOptions());
            }

            request.setAttribute("lesson", lesson);
            request.setAttribute("questionList", questions);
            request.getRequestDispatcher("takeQuiz.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/lessons");
        }
    }
}
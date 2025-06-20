package controller;

import dao.QuizDAO;
import model.QuizQuestion;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "EditQuizQuestionFormServlet", urlPatterns = {"/admin/edit-quiz-question-form"})
public class EditQuizQuestionFormServlet extends HttpServlet {

    private QuizDAO quizDAO;

    @Override
    public void init() {
        quizDAO = new QuizDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String questionIdStr = request.getParameter("questionId");
        // Lấy lessonId để có thể quay lại đúng trang quản lý quiz
        String lessonIdStr = request.getParameter("lessonId"); 

        if (questionIdStr == null || questionIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage_quiz", "Thiếu ID câu hỏi để sửa.");
            response.sendRedirect(request.getContextPath() + "/admin/manage-lessons"); // Quay về trang quản lý chung
            return;
        }

        try {
            int questionId = Integer.parseInt(questionIdStr);
            QuizQuestion questionToEdit = quizDAO.getQuestionById(questionId);

            if (questionToEdit != null) {
                request.setAttribute("questionToEdit", questionToEdit);
                request.getRequestDispatcher("/admin/editQuizQuestion.jsp").forward(request, response);
            } else {
                String redirectUrl = lessonIdStr != null ? "/admin/manage-quiz?lessonId=" + lessonIdStr : "/admin/manage-lessons";
                session.setAttribute("errorMessage_quiz", "Không tìm thấy câu hỏi với ID: " + questionId);
                response.sendRedirect(request.getContextPath() + redirectUrl);
            }
        } catch (NumberFormatException e) {
            String redirectUrl = lessonIdStr != null ? "/admin/manage-quiz?lessonId=" + lessonIdStr : "/admin/manage-lessons";
            session.setAttribute("errorMessage_quiz", "ID câu hỏi không hợp lệ: " + questionIdStr);
            response.sendRedirect(request.getContextPath() + redirectUrl);
        }
    }
}
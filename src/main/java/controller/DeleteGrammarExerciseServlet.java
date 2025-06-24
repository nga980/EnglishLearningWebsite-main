package controller;

import dao.QuizDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "DeleteGrammarExerciseServlet", urlPatterns = {"/admin/delete-grammar-exercise"})
public class DeleteGrammarExerciseServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(DeleteGrammarExerciseServlet.class.getName());
    private QuizDAO quizDAO;

    @Override
    public void init() {
        quizDAO = new QuizDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String questionIdStr = request.getParameter("questionId");
        String grammarTopicIdStr = request.getParameter("grammarTopicId");

        // URL để redirect lại đúng trang quản lý bài tập của chủ đề ngữ pháp
        String redirectURL = request.getContextPath() + "/admin/manage-grammar-exercises?grammarTopicId=" + grammarTopicIdStr;
        
        if (questionIdStr == null || questionIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Thiếu ID câu hỏi để xóa.");
            response.sendRedirect(redirectURL);
            return;
        }

        try {
            int questionId = Integer.parseInt(questionIdStr);
            LOGGER.log(Level.INFO, "Attempting to delete grammar exercise (question) with ID: {0}", questionId);

            boolean success = quizDAO.deleteQuestion(questionId);

            if (success) {
                session.setAttribute("successMessage", "Xóa bài tập ID " + questionId + " thành công!");
            } else {
                session.setAttribute("errorMessage", "Xóa bài tập ID " + questionId + " thất bại.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID câu hỏi không hợp lệ: " + questionIdStr);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa bài tập ngữ pháp: ", e);
            session.setAttribute("errorMessage", "Lỗi hệ thống khi xóa bài tập.");
        }

        response.sendRedirect(redirectURL);
    }
}
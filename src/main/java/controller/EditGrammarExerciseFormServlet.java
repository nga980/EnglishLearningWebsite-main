package controller;

import dao.QuizDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.QuizQuestion;

/**
 * Servlet này xử lý việc hiển thị form để sửa một câu hỏi bài tập ngữ pháp.
 */
@WebServlet(name = "EditGrammarExerciseFormServlet", urlPatterns = {"/admin/edit-grammar-exercise-form"})
public class EditGrammarExerciseFormServlet extends HttpServlet {
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
        // Lấy grammarTopicId để có thể quay lại đúng trang quản lý
        String grammarTopicIdStr = request.getParameter("grammarTopicId"); 

        // URL mặc định nếu có lỗi nghiêm trọng
        String defaultRedirectURL = request.getContextPath() + "/admin/manage-grammar";
        String redirectURL = grammarTopicIdStr != null 
                ? request.getContextPath() + "/admin/manage-grammar-exercises?grammarTopicId=" + grammarTopicIdStr 
                : defaultRedirectURL;

        if (questionIdStr == null || questionIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Thiếu ID câu hỏi để sửa.");
            response.sendRedirect(redirectURL);
            return;
        }

        try {
            int questionId = Integer.parseInt(questionIdStr);
            QuizQuestion questionToEdit = quizDAO.getQuestionById(questionId);

            if (questionToEdit != null) {
                request.setAttribute("questionToEdit", questionToEdit);
                // Forward đến trang JSP để sửa bài tập ngữ pháp
                request.getRequestDispatcher("/admin/editGrammarExercise.jsp").forward(request, response);
            } else {
                session.setAttribute("errorMessage", "Không tìm thấy câu hỏi với ID: " + questionId);
                response.sendRedirect(redirectURL);
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID câu hỏi không hợp lệ: " + questionIdStr);
            response.sendRedirect(redirectURL);
        }
    }
}
package controller;

import dao.GrammarTopicDAO;
import dao.QuizDAO;
import model.GrammarTopic;
import model.QuizQuestion;
import java.io.IOException;
import java.util.Collections;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "TakeGrammarExerciseServlet", urlPatterns = {"/take-grammar-exercise"})
public class TakeGrammarExerciseServlet extends HttpServlet {
    private QuizDAO quizDAO;
    private GrammarTopicDAO grammarTopicDAO;

    @Override
    public void init() {
        quizDAO = new QuizDAO();
        grammarTopicDAO = new GrammarTopicDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String grammarTopicIdStr = request.getParameter("grammarTopicId");
        if (grammarTopicIdStr == null || grammarTopicIdStr.trim().isEmpty()) {
            // Nếu không có grammarTopicId, chuyển về trang danh sách ngữ pháp
            response.sendRedirect(request.getContextPath() + "/grammar");
            return;
        }

        try {
            int grammarTopicId = Integer.parseInt(grammarTopicIdStr);
            GrammarTopic topic = grammarTopicDAO.getGrammarTopicById(grammarTopicId);
            List<QuizQuestion> questions = quizDAO.getQuestionsByGrammarTopicId(grammarTopicId);

            // Nếu không tìm thấy chủ đề hoặc không có câu hỏi nào cho chủ đề này
            if (topic == null || questions.isEmpty()) {
                request.setAttribute("quizMessage", "Chủ đề ngữ pháp này hiện chưa có bài tập."); // Có thể đổi tên attribute cho phù hợp hơn
                // Cần set lại topic để forward về trang chi tiết chủ đề ngữ pháp
                request.setAttribute("grammarTopic", topic); 
                request.getRequestDispatcher("/grammarDetail.jsp").forward(request, response);
                return;
            }

            // Xáo trộn thứ tự các lựa chọn trong mỗi câu hỏi (tùy chọn)
            for (QuizQuestion question : questions) {
                Collections.shuffle(question.getOptions());
            }

            request.setAttribute("topic", topic);
            request.setAttribute("questionList", questions);
            request.getRequestDispatcher("takeGrammarExercise.jsp").forward(request, response); // Chuyển tiếp đến JSP
        } catch (NumberFormatException e) {
            // Nếu ID không hợp lệ, chuyển về trang danh sách ngữ pháp
            response.sendRedirect(request.getContextPath() + "/grammar");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Xử lý POST tương tự GET nếu cần hoặc không cho phép (tùy thuộc vào luồng ứng dụng)
        doGet(req, resp);
    }
}
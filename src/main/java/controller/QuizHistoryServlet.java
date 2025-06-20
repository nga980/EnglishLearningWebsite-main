package controller;

import dao.QuizDAO;
import model.QuizHistoryItem;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "QuizHistoryServlet", urlPatterns = {"/quiz-history"})
public class QuizHistoryServlet extends HttpServlet {
    private QuizDAO quizDAO;

    @Override
    public void init() {
        quizDAO = new QuizDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<QuizHistoryItem> history = quizDAO.getQuizHistoryForUser(loggedInUser.getUserId());
        request.setAttribute("quizHistory", history);

        request.getRequestDispatcher("quizHistory.jsp").forward(request, response);
    }
}
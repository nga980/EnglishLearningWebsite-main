package controller;

import dao.QuizDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.GrammarExerciseHistoryItem; // Đã đổi import
import model.User;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "GrammarExerciseHistoryServlet", urlPatterns = {"/grammar-history"})
public class GrammarExerciseHistoryServlet extends HttpServlet {
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

        List<GrammarExerciseHistoryItem> history = quizDAO.getGrammarExerciseHistoryForUser(loggedInUser.getUserId()); // Đã đổi phương thức DAO
        request.setAttribute("grammarHistory", history); // Đã đổi tên attribute

        request.getRequestDispatcher("/grammarExerciseHistory.jsp").forward(request, response); // Đã đổi tên JSP
    }
}
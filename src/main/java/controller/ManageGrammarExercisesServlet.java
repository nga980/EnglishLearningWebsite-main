/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.GrammarTopicDAO;
import dao.QuizDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.GrammarTopic;
import model.QuizQuestion;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ManageGrammarExercisesServlet", urlPatterns = {"/admin/manage-grammar-exercises"})
public class ManageGrammarExercisesServlet extends HttpServlet {
    private final GrammarTopicDAO grammarTopicDAO = new GrammarTopicDAO();
    private final QuizDAO quizDAO = new QuizDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String grammarTopicIdStr = request.getParameter("grammarTopicId");
        if (grammarTopicIdStr == null || grammarTopicIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-grammar");
            return;
        }

        try {
            int grammarTopicId = Integer.parseInt(grammarTopicIdStr);
            GrammarTopic topic = grammarTopicDAO.getGrammarTopicById(grammarTopicId);
            List<QuizQuestion> questionList = quizDAO.getQuestionsByGrammarTopicId(grammarTopicId);

            request.setAttribute("topic", topic);
            request.setAttribute("questionList", questionList);
            request.getRequestDispatcher("/admin/manageGrammarExercises.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-grammar");
        }
    }
}
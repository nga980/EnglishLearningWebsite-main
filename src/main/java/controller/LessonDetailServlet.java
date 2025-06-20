/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.LessonDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Lesson;

@WebServlet(name = "LessonDetailServlet", urlPatterns = {"/lesson-detail"}) // Ánh xạ servlet tới URL /lesson-detail
public class LessonDetailServlet extends HttpServlet {

    private LessonDAO lessonDAO;

    @Override
    public void init() {
        lessonDAO = new LessonDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String lessonIdStr = request.getParameter("lessonId");
        if (lessonIdStr != null) {
            try {
                int lessonId = Integer.parseInt(lessonIdStr);
                Lesson lesson = lessonDAO.getLessonById(lessonId);

                if (lesson != null) {
                    request.setAttribute("lesson", lesson);
                    request.getRequestDispatcher("lessonDetail.jsp").forward(request, response);
                } else {
                    // Không tìm thấy bài học, có thể hiển thị trang lỗi 404 hoặc thông báo
                    response.getWriter().println("Không tìm thấy bài học với ID: " + lessonId);
                }
            } catch (NumberFormatException e) {
                // lessonId không phải là số, xử lý lỗi
                response.getWriter().println("ID bài học không hợp lệ.");
            }
        } else {
            // Không có lessonId, có thể chuyển hướng về trang danh sách bài học
            response.sendRedirect(request.getContextPath() + "/lessons");
        }
    }
}
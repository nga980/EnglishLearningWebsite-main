package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import utils.S3ClientUtil;

/**
 * Servlet proxy phục vụ file từ AWS S3.
 * Tham số "key" đại diện cho đường dẫn đối tượng trong bucket.
 */
@WebServlet(name = "MediaServlet", urlPatterns = {"/media"})
public class MediaServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String key = request.getParameter("key");
        if (key == null || key.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing 'key' parameter.");
            return;
        }
        try {
            S3ClientUtil.streamFile(key, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while retrieving media.");
        }
    }
}

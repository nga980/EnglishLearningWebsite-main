package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import utils.S3ClientUtil;

@WebServlet("/admin/upload-media")
@MultipartConfig(fileSizeThreshold = 0)
public class MediaUploadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        try {
            Part filePart = request.getPart("file");
            String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
            String newFileName = UUID.randomUUID().toString() + fileExtension;

            try (InputStream inputStream = filePart.getInputStream()) {
                S3ClientUtil.uploadFile("uploads/" + newFileName, inputStream, filePart.getSize(), filePart.getContentType());
            }

            // Tạo URL công khai (nếu bucket cho phép public-read hoặc dùng CloudFront)
            String fileUrl = S3ClientUtil.getFileUrl("uploads/" + URLEncoder.encode(newFileName, "UTF-8"));

            Map<String, String> jsonResponse = new HashMap<>();
            jsonResponse.put("location", fileUrl);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(new Gson().toJson(jsonResponse));

        } catch (Exception e) {
            e.printStackTrace(); // Log lỗi ra console
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi tải file lên AWS S3.");
        }
    }
}

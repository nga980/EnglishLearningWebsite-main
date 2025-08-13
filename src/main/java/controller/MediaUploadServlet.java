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
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.net.URLEncoder;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@WebServlet("/admin/upload-media")
@MultipartConfig
public class MediaUploadServlet extends HttpServlet {

    private static final String BUCKET_NAME = "your-bucket-name";
    private static final String ACCESS_KEY = "your-access-key";
    private static final String SECRET_KEY = "your-secret-key";
    private static final Region REGION = Region.AP_SOUTHEAST_1; // Singapore

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        try {
            Part filePart = request.getPart("file");
            String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
            String newFileName = UUID.randomUUID().toString() + fileExtension;

            try (InputStream inputStream = filePart.getInputStream()) {

                AwsBasicCredentials credentials = AwsBasicCredentials.create(ACCESS_KEY, SECRET_KEY);
                S3Client s3 = S3Client.builder()
                        .region(REGION)
                        .credentialsProvider(StaticCredentialsProvider.create(credentials))
                        .build();

                PutObjectRequest requestPut = PutObjectRequest.builder()
                        .bucket(BUCKET_NAME)
                        .key("uploads/" + newFileName)
                        .contentType(filePart.getContentType())
                        .build();

                s3.putObject(requestPut, software.amazon.awssdk.core.sync.RequestBody.fromInputStream(inputStream, filePart.getSize()));
            }

            // Tạo URL công khai (nếu bucket cho phép public-read hoặc dùng CloudFront)
            String fileUrl = "https://" + BUCKET_NAME + ".s3." + REGION.toString().toLowerCase().replace("_", "-") + ".amazonaws.com/uploads/" + URLEncoder.encode(newFileName, "UTF-8");

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

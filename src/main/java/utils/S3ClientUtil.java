package utils;

import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.services.s3.model.S3Object;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.commons.io.IOUtils;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class S3ClientUtil {
    private static final String BUCKET_NAME = "your-bucket-name";
    private static final String ACCESS_KEY = "your-access-key";
    private static final String SECRET_KEY = "your-secret-key";
    private static final Regions REGION = Regions.AP_SOUTHEAST_1; // Singapore

    private static final AmazonS3 s3Client = AmazonS3ClientBuilder.standard()
            .withRegion(REGION)
            .withCredentials(new AWSStaticCredentialsProvider(new BasicAWSCredentials(ACCESS_KEY, SECRET_KEY)))
            .build();

    public static void uploadFile(String key, InputStream inputStream, long contentLength, String contentType) {
        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(contentLength);
        metadata.setContentType(contentType);
        PutObjectRequest request = new PutObjectRequest(BUCKET_NAME, key, inputStream, metadata);
        s3Client.putObject(request);
    }

    public static void streamFile(String key, HttpServletResponse response) throws IOException {
        S3Object s3Object = s3Client.getObject(BUCKET_NAME, key);
        response.setContentType(s3Object.getObjectMetadata().getContentType());
        try (InputStream in = s3Object.getObjectContent();
             OutputStream out = response.getOutputStream()) {
            IOUtils.copy(in, out);
            out.flush();
        }
    }

    public static String getFileUrl(String key) {
        return String.format("https://%s.s3.%s.amazonaws.com/%s", BUCKET_NAME, REGION.getName(), key);
    }
}

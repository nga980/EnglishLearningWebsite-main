package util;

import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.io.InputStream;
import java.io.IOException;
import java.net.URL;
import java.util.UUID;

public class S3ClientUtil {
    private static final Region REGION = Region.AP_SOUTHEAST_1;
    private static final String BUCKET = System.getenv().getOrDefault("S3_BUCKET", "your-bucket-name");
    private static final S3Client CLIENT = S3Client.builder()
            .region(REGION)
            .credentialsProvider(DefaultCredentialsProvider.create())
            .build();

    private S3ClientUtil() {}

    public static String upload(InputStream inputStream, String fileName, long contentLength) throws IOException {
        String key = UUID.randomUUID() + "_" + fileName;
        PutObjectRequest putReq = PutObjectRequest.builder()
                .bucket(BUCKET)
                .key(key)
                .build();
        CLIENT.putObject(putReq, RequestBody.fromInputStream(inputStream, contentLength));
        URL url = CLIENT.utilities().getUrl(b -> b.bucket(BUCKET).key(key));
        return url.toString();
    }
}

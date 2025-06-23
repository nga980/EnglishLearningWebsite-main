package utils;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Lớp tiện ích để xử lý các hoạt động liên quan đến mật khẩu,
 * sử dụng thuật toán băm BCrypt mạnh mẽ hơn.
 */
public class PasswordUtils {

    /**
     * Mã hóa mật khẩu dạng văn bản thuần sử dụng BCrypt.
     *
     * @param plainPassword Mật khẩu cần mã hóa.
     * @return Một chuỗi hash của mật khẩu.
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            return null;
        }
        // Tham số thứ hai là "work factor", giá trị càng cao càng an toàn nhưng càng chậm.
        // 12 là một giá trị tốt cho năm 2024.
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    /**
     * Kiểm tra một mật khẩu văn bản thuần có khớp với một hash đã được mã hóa bằng BCrypt hay không.
     *
     * @param plainPassword Mật khẩu người dùng nhập vào.
     * @param hashedPassword Mật khẩu đã được mã hóa lưu trong CSDL.
     * @return true nếu mật khẩu khớp, ngược lại là false.
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (IllegalArgumentException e) {
            // Xử lý trường hợp hashedPassword không phải là định dạng BCrypt hợp lệ
            return false;
        }
    }
}
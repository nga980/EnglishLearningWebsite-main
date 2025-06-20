/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

/**
 *
 * @author admin
 */

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class SecurityUtils {

    /**
     * Mã hóa mật khẩu sử dụng SHA-256.
     * @param password Mật khẩu dạng văn bản thuần.
     * @return Chuỗi mật khẩu đã được mã hóa dưới dạng hex.
     */
    public static String hashPassword(String password) {
        if (password == null || password.isEmpty()) {
            return null;
        }
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            Logger.getLogger(SecurityUtils.class.getName()).log(Level.SEVERE, "Lỗi mã hóa mật khẩu: SHA-256 không khả dụng.", e);
            // Trong ứng dụng thực tế, bạn có thể throw một RuntimeException hoặc xử lý khác
            return null; // Hoặc throw new RuntimeException("Error hashing password", e);
        }
    }

    /**
     * Kiểm tra mật khẩu nhập vào với mật khẩu đã mã hóa.
     * @param plainPassword Mật khẩu người dùng nhập.
     * @param hashedPassword Mật khẩu đã mã hóa lưu trong CSDL.
     * @return true nếu khớp, false nếu không.
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        String hashedPlainPassword = hashPassword(plainPassword);
        return hashedPlainPassword != null && hashedPlainPassword.equals(hashedPassword);
    }
}

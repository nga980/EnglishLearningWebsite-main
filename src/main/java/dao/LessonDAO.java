package dao;

import model.Lesson;
import utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Map;
import java.util.LinkedHashMap;
import javax.naming.NamingException; // Thêm import

public class LessonDAO {
    private static final Logger LOGGER = Logger.getLogger(LessonDAO.class.getName());

    public List<Lesson> getLessonsByPage(int pageNumber, int pageSize) {
        List<Lesson> lessons = new ArrayList<>();
        String query = "SELECT lesson_id, title, content, created_at FROM lessons ORDER BY created_at DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            int offset = (pageNumber - 1) * pageSize;
            ps.setInt(1, pageSize);
            ps.setInt(2, offset);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Lesson lesson = new Lesson();
                    lesson.setLessonId(rs.getInt("lesson_id"));
                    lesson.setTitle(rs.getString("title"));
                    lesson.setCreatedAt(rs.getTimestamp("created_at"));
                    lessons.add(lesson);
                }
            }
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách bài học theo trang", e);
        }
        return lessons;
    }

    public Lesson getLessonById(int lessonId) {
        String query = "SELECT lesson_id, title, content, created_at FROM lessons WHERE lesson_id = ?";
        Lesson lesson = null;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, lessonId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    lesson = new Lesson();
                    lesson.setLessonId(rs.getInt("lesson_id"));
                    lesson.setTitle(rs.getString("title"));
                    lesson.setContent(rs.getString("content"));
                    lesson.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy bài học với ID: " + lessonId, e);
        }
        return lesson;
    }

    public boolean addLesson(Lesson lesson) {
        String query = "INSERT INTO lessons (title, content, created_at) VALUES (?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) { 

            ps.setString(1, lesson.getTitle());
            ps.setString(2, lesson.getContent());
            ps.setTimestamp(3, new Timestamp(System.currentTimeMillis()));

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        lesson.setLessonId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi thêm bài học mới: " + lesson.getTitle(), e);
        }
        return false;
    }

    public boolean updateLesson(Lesson lesson) {
        String query = "UPDATE lessons SET title = ?, content = ? WHERE lesson_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, lesson.getTitle());
            ps.setString(2, lesson.getContent());
            ps.setInt(3, lesson.getLessonId());

            return ps.executeUpdate() > 0;
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật bài học ID: " + lesson.getLessonId(), e);
        }
        return false;
    }

    public boolean deleteLesson(int lessonId) {
        String query = "DELETE FROM lessons WHERE lesson_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, lessonId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa bài học ID: " + lessonId, e);
        }
        return false;
    }
    
    public int countTotalLessons() {
        String query = "SELECT COUNT(*) FROM lessons";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm tổng số bài học", e);
        }
        return 0;
    }
    
    public List<Lesson> searchLessons(String keyword) {
        List<Lesson> lessons = new ArrayList<>();
        String query = "SELECT lesson_id, title, content, created_at FROM lessons WHERE title LIKE ? ORDER BY created_at DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Lesson lesson = new Lesson();
                    lesson.setLessonId(rs.getInt("lesson_id"));
                    lesson.setTitle(rs.getString("title"));
                    lesson.setContent(rs.getString("content"));
                    lesson.setCreatedAt(rs.getTimestamp("created_at"));
                    lessons.add(lesson);
                }
            }
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi tìm kiếm bài học với từ khóa: " + keyword, e);
        }
        return lessons;
    }
    
    public List<Lesson> getRecentLessons(int numberOfLessons) {
        List<Lesson> lessons = new ArrayList<>();
        String query = "SELECT lesson_id, title, content, created_at FROM lessons ORDER BY created_at DESC LIMIT ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, numberOfLessons);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Lesson lesson = new Lesson();
                    lesson.setLessonId(rs.getInt("lesson_id"));
                    lesson.setTitle(rs.getString("title"));
                    lesson.setContent(rs.getString("content"));
                    lesson.setCreatedAt(rs.getTimestamp("created_at"));
                    lessons.add(lesson);
                }
            }
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách bài học gần đây", e);
        }
        return lessons;
    }
    
    public Map<String, Integer> getMonthlyLessonGrowth(int lastMonths) {
        Map<String, Integer> monthlyGrowth = new LinkedHashMap<>();
        String query = "SELECT YEAR(created_at) AS year, MONTH(created_at) AS month, COUNT(lesson_id) AS count " +
                       "FROM lessons " +
                       "WHERE created_at >= CURDATE() - INTERVAL ? MONTH " +
                       "GROUP BY YEAR(created_at), MONTH(created_at) ORDER BY year, month;";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, lastMonths);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String monthKey = "Tháng " + rs.getInt("month") + "/" + rs.getInt("year");
                    monthlyGrowth.put(monthKey, rs.getInt("count"));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy dữ liệu tăng trưởng bài học", e);
        }
        return monthlyGrowth;
    }
}
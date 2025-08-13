package dao;

import model.Lesson;
import utils.DBContext;

import javax.naming.NamingException;
import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class LessonDAO {
    private static final Logger LOGGER = Logger.getLogger(LessonDAO.class.getName());

    /** Map 1 hàng ResultSet -> Lesson */
    private Lesson mapRow(ResultSet rs) throws SQLException {
        Lesson l = new Lesson();
        l.setLessonId(rs.getInt("lesson_id"));
        l.setTitle(rs.getString("title"));
        l.setContent(rs.getString("content"));
        l.setCreatedAt(rs.getTimestamp("created_at"));
        return l;
    }

    /** Phân trang: ORDER BY + OFFSET/FETCH (SQL Server) */
    public List<Lesson> getLessonsByPage(int pageNumber, int pageSize) {
        List<Lesson> lessons = new ArrayList<>();
        String sql =
            "SELECT lesson_id, title, [content], created_at " +
            "FROM dbo.lessons " +
            "ORDER BY created_at DESC " +
            "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        int offset = Math.max(0, (pageNumber - 1) * pageSize);
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, offset);
            ps.setInt(2, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lessons.add(mapRow(rs));
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách bài học theo trang", e);
        }
        return lessons;
    }

    /** Lấy bài học theo ID */
    public Lesson getLessonById(int lessonId) {
        String sql = "SELECT lesson_id, title, [content], created_at FROM dbo.lessons WHERE lesson_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, lessonId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy bài học với ID: " + lessonId, e);
        }
        return null;
    }

    /** Thêm bài học; created_at để DB tự set (DEFAULT) */
    public boolean addLesson(Lesson lesson) {
        String sql = "INSERT INTO dbo.lessons (title, [content]) VALUES (?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, lesson.getTitle());
            ps.setString(2, lesson.getContent());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) lesson.setLessonId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi thêm bài học mới: " + lesson.getTitle(), e);
        }
        return false;
    }

    /** Cập nhật bài học */
    public boolean updateLesson(Lesson lesson) {
        String sql = "UPDATE dbo.lessons SET title = ?, [content] = ? WHERE lesson_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, lesson.getTitle());
            ps.setString(2, lesson.getContent());
            ps.setInt(3, lesson.getLessonId());
            return ps.executeUpdate() > 0;
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật bài học ID: " + lesson.getLessonId(), e);
        }
        return false;
    }

    /** Xóa bài học */
    public boolean deleteLesson(int lessonId) {
        String sql = "DELETE FROM dbo.lessons WHERE lesson_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, lessonId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa bài học ID: " + lessonId, e);
        }
        return false;
    }

    /** Đếm tổng số bài học */
    public int countTotalLessons() {
        String sql = "SELECT COUNT(*) FROM dbo.lessons";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm tổng số bài học", e);
        }
        return 0;
    }

    /** Tìm kiếm theo tiêu đề */
    public List<Lesson> searchLessons(String keyword) {
        List<Lesson> lessons = new ArrayList<>();
        String sql =
            "SELECT lesson_id, title, [content], created_at " +
            "FROM dbo.lessons " +
            "WHERE title LIKE ? " +
            "ORDER BY created_at DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + (keyword == null ? "" : keyword) + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lessons.add(mapRow(rs));
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tìm kiếm bài học với từ khóa: " + keyword, e);
        }
        return lessons;
    }

    /** Lấy N bài gần nhất (dùng OFFSET 0 + FETCH NEXT) */
    public List<Lesson> getRecentLessons(int numberOfLessons) {
        List<Lesson> lessons = new ArrayList<>();
        String sql =
            "SELECT lesson_id, title, [content], created_at " +
            "FROM dbo.lessons " +
            "ORDER BY created_at DESC " +
            "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, numberOfLessons);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lessons.add(mapRow(rs));
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách bài học gần đây", e);
        }
        return lessons;
    }

    /** Tăng trưởng theo tháng gần đây (thay CURDATE/INTERVAL bằng DATEADD/GETDATE) */
    public Map<String, Integer> getMonthlyLessonGrowth(int lastMonths) {
        Map<String, Integer> monthlyGrowth = new LinkedHashMap<>();
        String sql =
            "SELECT YEAR(created_at) AS [year], MONTH(created_at) AS [month], COUNT(lesson_id) AS [count] " +
            "FROM dbo.lessons " +
            "WHERE created_at >= DATEADD(MONTH, -?, CAST(GETDATE() AS DATE)) " +
            "GROUP BY YEAR(created_at), MONTH(created_at) " +
            "ORDER BY [year], [month]";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, lastMonths);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String monthKey = "Tháng " + rs.getInt("month") + "/" + rs.getInt("year");
                    monthlyGrowth.put(monthKey, rs.getInt("count"));
                }
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy dữ liệu tăng trưởng bài học", e);
        }
        return monthlyGrowth;
    }
}

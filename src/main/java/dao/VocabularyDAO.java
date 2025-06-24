package dao;

import model.Vocabulary;
import utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.NamingException;

public class VocabularyDAO {
    private static final Logger LOGGER = Logger.getLogger(VocabularyDAO.class.getName());

    private Vocabulary extractVocabularyFromResultSet(ResultSet rs) throws SQLException {
        Vocabulary vocab = new Vocabulary();
        vocab.setVocabId(rs.getInt("vocab_id"));
        vocab.setWord(rs.getString("word"));
        vocab.setMeaning(rs.getString("meaning"));
        vocab.setExample(rs.getString("example"));
        
        // THAY ĐỔI: Lấy dữ liệu dạng byte[]
        vocab.setImageData(rs.getBytes("image_data"));
        vocab.setAudioData(rs.getBytes("audio_data"));
        
        int lessonId = rs.getInt("lesson_id");
        if (!rs.wasNull()) {
            vocab.setLessonId(lessonId);
        }
        vocab.setCreatedAt(rs.getTimestamp("created_at"));
        return vocab;
    }

    public List<Vocabulary> getAllVocabulary() {
        List<Vocabulary> vocabList = new ArrayList<>();
        String query = "SELECT * FROM vocabulary ORDER BY word ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                vocabList.add(extractVocabularyFromResultSet(rs));
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy toàn bộ danh sách từ vựng", e);
        }
        return vocabList;
    }


    public List<Vocabulary> getVocabularyByPage(int pageNumber, int pageSize) {
        List<Vocabulary> vocabList = new ArrayList<>();
        String query = "SELECT * FROM vocabulary ORDER BY word ASC LIMIT ? OFFSET ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            int offset = (pageNumber - 1) * pageSize;
            ps.setInt(1, pageSize);
            ps.setInt(2, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    vocabList.add(extractVocabularyFromResultSet(rs));
                }
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách từ vựng theo trang", e);
        }
        return vocabList;
    }
    

    public Vocabulary getVocabularyById(int vocabId) {
        String query = "SELECT * FROM vocabulary WHERE vocab_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, vocabId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractVocabularyFromResultSet(rs);
                }
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy từ vựng với ID: " + vocabId, e);
        }
        return null;
    }

    public boolean addVocabulary(Vocabulary vocab) {
        String query = "INSERT INTO vocabulary (word, meaning, example, image_data, audio_data, lesson_id, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, vocab.getWord());
            ps.setString(2, vocab.getMeaning());
            ps.setString(3, vocab.getExample());
            
            // THAY ĐỔI: Sử dụng setBytes cho dữ liệu BLOB
            ps.setBytes(4, vocab.getImageData());
            ps.setBytes(5, vocab.getAudioData());

            if (vocab.getLessonId() != null) {
                ps.setInt(6, vocab.getLessonId());
            } else {
                ps.setNull(6, Types.INTEGER);
            }
            ps.setTimestamp(7, new Timestamp(System.currentTimeMillis()));

            return ps.executeUpdate() > 0;
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi thêm từ vựng mới: " + vocab.getWord(), e);
            return false;
        }
    }

    public boolean updateVocabulary(Vocabulary vocab) {
        String query = "UPDATE vocabulary SET word = ?, meaning = ?, example = ?, image_data = ?, audio_data = ?, lesson_id = ? WHERE vocab_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, vocab.getWord());
            ps.setString(2, vocab.getMeaning());
            ps.setString(3, vocab.getExample());
            ps.setBytes(4, vocab.getImageData());
            ps.setBytes(5, vocab.getAudioData());

            if (vocab.getLessonId() != null) {
                ps.setInt(6, vocab.getLessonId());
            } else {
                ps.setNull(6, Types.INTEGER);
            }
            ps.setInt(7, vocab.getVocabId());

            return ps.executeUpdate() > 0;
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật từ vựng ID: " + vocab.getVocabId(), e);
            return false;
        }
    }
    
    public List<Vocabulary> searchVocabulary(String keyword) {
        List<Vocabulary> vocabList = new ArrayList<>();
        String query = "SELECT * FROM vocabulary WHERE word LIKE ? OR meaning LIKE ? ORDER BY word ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    vocabList.add(extractVocabularyFromResultSet(rs));
                }
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tìm kiếm từ vựng với từ khóa: " + keyword, e);
        }
        return vocabList;
    }

    public List<Vocabulary> getVocabularyByLessonId(int lessonId) {
        List<Vocabulary> vocabList = new ArrayList<>();
        String query = "SELECT * FROM vocabulary WHERE lesson_id = ? ORDER BY word ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, lessonId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    vocabList.add(extractVocabularyFromResultSet(rs));
                }
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách từ vựng theo lesson ID: " + lessonId, e);
        }
        return vocabList;
    }

    public boolean deleteVocabulary(int vocabId) {
        String query = "DELETE FROM vocabulary WHERE vocab_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, vocabId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa từ vựng ID: " + vocabId, e);
        }
        return false;
    }

    public int countTotalVocabulary() {
        String query = "SELECT COUNT(*) FROM vocabulary";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException | NamingException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm tổng số từ vựng", e);
        }
        return 0;
    }
    
    public Map<String, Integer> getMonthlyVocabularyGrowth(int lastMonths) {
        Map<String, Integer> monthlyGrowth = new LinkedHashMap<>();
        String query = "SELECT YEAR(created_at) AS year, MONTH(created_at) AS month, COUNT(vocab_id) AS count " +
                       "FROM vocabulary " +
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
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy dữ liệu tăng trưởng từ vựng", e);
        }
        return monthlyGrowth;
    }
}
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author admin
 */
import model.Vocabulary;
import utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types; // Để xử lý setNull cho Integer
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class VocabularyDAO {
    private static final Logger LOGGER = Logger.getLogger(VocabularyDAO.class.getName());

    /**
     * Lấy tất cả các mục từ vựng từ CSDL.
     * @return Danh sách các đối tượng Vocabulary.
     */
    public List<Vocabulary> getAllVocabulary() {
        List<Vocabulary> vocabList = new ArrayList<>();
        String query = "SELECT vocab_id, word, meaning, example, lesson_id, created_at FROM vocabulary ORDER BY word ASC"; // Sắp xếp theo từ
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Vocabulary vocab = new Vocabulary();
                vocab.setVocabId(rs.getInt("vocab_id"));
                vocab.setWord(rs.getString("word"));
                vocab.setMeaning(rs.getString("meaning"));
                vocab.setExample(rs.getString("example"));
                // Xử lý lesson_id có thể NULL
                int lessonId = rs.getInt("lesson_id");
                if (rs.wasNull()) {
                    vocab.setLessonId(null);
                } else {
                    vocab.setLessonId(lessonId);
                }
                vocab.setCreatedAt(rs.getTimestamp("created_at"));
                vocabList.add(vocab);
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách từ vựng", e);
        }
        return vocabList;
    }

    /**
     * Lấy các mục từ vựng thuộc về một bài học cụ thể.
     * @param lessonId ID của bài học.
     * @return Danh sách các đối tượng Vocabulary.
     */
    public List<Vocabulary> getVocabularyByLessonId(int lessonId) {
        List<Vocabulary> vocabList = new ArrayList<>();
        String query = "SELECT vocab_id, word, meaning, example, lesson_id, created_at FROM vocabulary WHERE lesson_id = ? ORDER BY word ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, lessonId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Vocabulary vocab = new Vocabulary();
                    vocab.setVocabId(rs.getInt("vocab_id"));
                    vocab.setWord(rs.getString("word"));
                    vocab.setMeaning(rs.getString("meaning"));
                    vocab.setExample(rs.getString("example"));
                    vocab.setLessonId(rs.getInt("lesson_id")); // Chắc chắn có lesson_id vì đã lọc theo nó
                    vocab.setCreatedAt(rs.getTimestamp("created_at"));
                    vocabList.add(vocab);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách từ vựng theo lesson ID: " + lessonId, e);
        }
        return vocabList;
    }


    /**
     * Thêm một mục từ vựng mới vào CSDL (dành cho Admin).
     * @param vocab Đối tượng Vocabulary chứa thông tin mục từ vựng mới.
     * @return true nếu thêm thành công, false nếu thất bại.
     */
    public boolean addVocabulary(Vocabulary vocab) {
        String query = "INSERT INTO vocabulary (word, meaning, example, lesson_id, created_at) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, vocab.getWord());
            ps.setString(2, vocab.getMeaning());
            ps.setString(3, vocab.getExample());

            if (vocab.getLessonId() != null) {
                ps.setInt(4, vocab.getLessonId());
            } else {
                ps.setNull(4, Types.INTEGER); // Cho phép lesson_id là NULL
            }
            ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        vocab.setVocabId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi thêm từ vựng mới: " + vocab.getWord(), e);
        }
        return false;
    }

    /**
     * Cập nhật thông tin một mục từ vựng (dành cho Admin).
     * @param vocab Đối tượng Vocabulary chứa thông tin cần cập nhật.
     * @return true nếu cập nhật thành công, false nếu thất bại.
     */
    public boolean updateVocabulary(Vocabulary vocab) {
        String query = "UPDATE vocabulary SET word = ?, meaning = ?, example = ?, lesson_id = ? WHERE vocab_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, vocab.getWord());
            ps.setString(2, vocab.getMeaning());
            ps.setString(3, vocab.getExample());
            if (vocab.getLessonId() != null) {
                ps.setInt(4, vocab.getLessonId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setInt(5, vocab.getVocabId());

            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật từ vựng ID: " + vocab.getVocabId(), e);
        }
        return false;
    }

    /**
     * Xóa một mục từ vựng (dành cho Admin).
     * @param vocabId ID của mục từ vựng cần xóa.
     * @return true nếu xóa thành công, false nếu thất bại.
     */
    public boolean deleteVocabulary(int vocabId) {
        String query = "DELETE FROM vocabulary WHERE vocab_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, vocabId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa từ vựng ID: " + vocabId, e);
        }
        return false;
    }

    // Optional: Lấy từ vựng theo ID (nếu cần)
    public Vocabulary getVocabularyById(int vocabId) {
        String query = "SELECT vocab_id, word, meaning, example, lesson_id, created_at FROM vocabulary WHERE vocab_id = ?";
        Vocabulary vocab = null;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, vocabId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    vocab = new Vocabulary();
                    vocab.setVocabId(rs.getInt("vocab_id"));
                    vocab.setWord(rs.getString("word"));
                    vocab.setMeaning(rs.getString("meaning"));
                    vocab.setExample(rs.getString("example"));
                    int lessonIdVal = rs.getInt("lesson_id");
                    if (rs.wasNull()) {
                        vocab.setLessonId(null);
                    } else {
                        vocab.setLessonId(lessonIdVal);
                    }
                    vocab.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy từ vựng với ID: " + vocabId, e);
        }
        return vocab;
    }
    /**
     * Đếm tổng số từ vựng trong CSDL.
     * @return Tổng số từ vựng.
     */
    public int countTotalVocabulary() {
        String query = "SELECT COUNT(*) FROM vocabulary";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm tổng số từ vựng", e);
        }
        return 0;
    }
    /**
     * Tìm kiếm từ vựng theo từ hoặc nghĩa.
     * @param keyword Từ khóa tìm kiếm.
     * @return Danh sách các từ vựng khớp.
     */
    public List<Vocabulary> searchVocabulary(String keyword) {
        List<Vocabulary> vocabList = new ArrayList<>();
        String query = "SELECT * FROM vocabulary WHERE word LIKE ? OR meaning LIKE ? ORDER BY word ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // ... (code tạo đối tượng Vocabulary giống như trong getAllVocabulary) ...
                    Vocabulary vocab = new Vocabulary();
                    vocab.setVocabId(rs.getInt("vocab_id"));
                    vocab.setWord(rs.getString("word"));
                    vocab.setMeaning(rs.getString("meaning"));
                    vocab.setExample(rs.getString("example"));
                    int lessonId = rs.getInt("lesson_id");
                    if (rs.wasNull()) {
                        vocab.setLessonId(null);
                    } else {
                        vocab.setLessonId(lessonId);
                    }
                    vocab.setCreatedAt(rs.getTimestamp("created_at"));
                    vocabList.add(vocab);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tìm kiếm từ vựng với từ khóa: " + keyword, e);
        }
        return vocabList;
    }
    /**
     * Lấy danh sách từ vựng cho một trang cụ thể.
     * @param pageNumber Số trang hiện tại (bắt đầu từ 1).
     * @param pageSize Số lượng từ vựng trên mỗi trang.
     * @return Danh sách các đối tượng Vocabulary cho trang đó.
     */
    public List<Vocabulary> getVocabularyByPage(int pageNumber, int pageSize) {
        List<Vocabulary> vocabList = new ArrayList<>();
        String query = "SELECT vocab_id, word, meaning, example, lesson_id, created_at FROM vocabulary ORDER BY word ASC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            int offset = (pageNumber - 1) * pageSize;
            ps.setInt(1, pageSize);
            ps.setInt(2, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Vocabulary vocab = new Vocabulary();
                    vocab.setVocabId(rs.getInt("vocab_id"));
                    vocab.setWord(rs.getString("word"));
                    vocab.setMeaning(rs.getString("meaning"));
                    vocab.setExample(rs.getString("example"));
                    int lessonId = rs.getInt("lesson_id");
                    if (rs.wasNull()) {
                        vocab.setLessonId(null);
                    } else {
                        vocab.setLessonId(lessonId);
                    }
                    vocab.setCreatedAt(rs.getTimestamp("created_at"));
                    vocabList.add(vocab);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách từ vựng theo trang", e);
        }
        return vocabList;
    }
}
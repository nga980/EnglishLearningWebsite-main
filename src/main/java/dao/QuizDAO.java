package dao; // Hoặc package dao của bạn

import model.QuizOption;
import model.QuizQuestion;
import utils.DBContext; // Đảm bảo bạn đã có lớp này
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
import model.QuizHistoryItem;
import model.UserQuizAttempt;

public class QuizDAO {
    private static final Logger LOGGER = Logger.getLogger(QuizDAO.class.getName());

    /**
     * Lấy tất cả các câu hỏi và các lựa chọn tương ứng của một bài học.
     * @param lessonId ID của bài học.
     * @return Danh sách các đối tượng QuizQuestion.
     */
    public List<QuizQuestion> getQuestionsByLessonId(int lessonId) {
        List<QuizQuestion> questions = new ArrayList<>();
        String questionQuery = "SELECT question_id, question_text FROM quiz_questions WHERE lesson_id = ?";
        String optionQuery = "SELECT option_id, option_text, is_correct FROM quiz_options WHERE question_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement psQuestions = conn.prepareStatement(questionQuery)) {

            psQuestions.setInt(1, lessonId);
            try (ResultSet rsQuestions = psQuestions.executeQuery()) {
                while (rsQuestions.next()) {
                    int questionId = rsQuestions.getInt("question_id");
                    String questionText = rsQuestions.getString("question_text");

                    QuizQuestion question = new QuizQuestion(questionId, lessonId, questionText);

                    // Với mỗi câu hỏi, lấy các lựa chọn của nó
                    try (PreparedStatement psOptions = conn.prepareStatement(optionQuery)) {
                        psOptions.setInt(1, questionId);
                        try (ResultSet rsOptions = psOptions.executeQuery()) {
                            while (rsOptions.next()) {
                                QuizOption option = new QuizOption();
                                option.setOptionId(rsOptions.getInt("option_id"));
                                option.setQuestionId(questionId);
                                option.setOptionText(rsOptions.getString("option_text"));
                                option.setIsCorrect(rsOptions.getBoolean("is_correct"));
                                question.addOption(option);
                            }
                        }
                    }
                    questions.add(question);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy câu hỏi cho bài học ID: " + lessonId, e);
        }
        return questions;
    }

    /**
     * Thêm một câu hỏi mới cùng với các lựa chọn của nó vào CSDL.
     * Sử dụng transaction để đảm bảo tính toàn vẹn dữ liệu.
     * @param question Đối tượng QuizQuestion chứa đầy đủ thông tin.
     * @return true nếu thêm thành công, false nếu thất bại.
     */
    public boolean addQuestionWithOptions(QuizQuestion question) {
        String questionInsertQuery = "INSERT INTO quiz_questions (lesson_id, question_text) VALUES (?, ?)";
        String optionInsertQuery = "INSERT INTO quiz_options (question_id, option_text, is_correct) VALUES (?, ?, ?)";
        Connection conn = null;
        boolean success = false;

        try {
            conn = DBContext.getConnection();
            // Bắt đầu transaction
            conn.setAutoCommit(false);

            // Thêm câu hỏi trước để lấy question_id
            try (PreparedStatement psQuestion = conn.prepareStatement(questionInsertQuery, Statement.RETURN_GENERATED_KEYS)) {
                psQuestion.setInt(1, question.getLessonId());
                psQuestion.setString(2, question.getQuestionText());
                psQuestion.executeUpdate();

                // Lấy question_id vừa được tạo
                try (ResultSet generatedKeys = psQuestion.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int newQuestionId = generatedKeys.getInt(1);
                        question.setQuestionId(newQuestionId);

                        // Thêm các lựa chọn với question_id mới
                        try (PreparedStatement psOption = conn.prepareStatement(optionInsertQuery)) {
                            for (QuizOption option : question.getOptions()) {
                                psOption.setInt(1, newQuestionId);
                                psOption.setString(2, option.getOptionText());
                                psOption.setBoolean(3, option.isIsCorrect());
                                psOption.addBatch(); // Thêm vào batch để thực thi cùng lúc
                            }
                            psOption.executeBatch(); // Thực thi batch
                        }
                    } else {
                        throw new SQLException("Thêm câu hỏi thất bại, không nhận được ID.");
                    }
                }
            }

            conn.commit(); // Hoàn tất transaction
            success = true;
            LOGGER.log(Level.INFO, "Thêm câu hỏi và các lựa chọn thành công cho lesson ID: {0}", question.getLessonId());

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi thêm câu hỏi và lựa chọn. Đang rollback transaction.", e);
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback nếu có lỗi
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi rollback transaction.", ex);
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Trả lại trạng thái auto-commit mặc định
                    conn.close();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi đóng kết nối.", ex);
                }
            }
        }
        return success;
    }

    /**
     * Xóa một câu hỏi (và các lựa chọn liên quan nếu CSDL được thiết lập ON DELETE CASCADE).
     * @param questionId ID của câu hỏi cần xóa.
     * @return true nếu xóa thành công, false nếu thất bại.
     */
    public boolean deleteQuestion(int questionId) {
        String query = "DELETE FROM quiz_questions WHERE question_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, questionId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa câu hỏi ID: " + questionId, e);
        }
        return false;
    }
    /**
     * Lấy một câu hỏi cụ thể và các lựa chọn của nó bằng ID câu hỏi.
     * @param questionId ID của câu hỏi.
     * @return Đối tượng QuizQuestion hoặc null nếu không tìm thấy.
     */
    public QuizQuestion getQuestionById(int questionId) {
        QuizQuestion question = null;
        String questionQuery = "SELECT question_id, lesson_id, question_text FROM quiz_questions WHERE question_id = ?";
        String optionQuery = "SELECT option_id, option_text, is_correct FROM quiz_options WHERE question_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement psQuestion = conn.prepareStatement(questionQuery)) {

            psQuestion.setInt(1, questionId);
            try (ResultSet rsQuestion = psQuestion.executeQuery()) {
                if (rsQuestion.next()) {
                    question = new QuizQuestion();
                    question.setQuestionId(rsQuestion.getInt("question_id"));
                    question.setLessonId(rsQuestion.getInt("lesson_id"));
                    question.setQuestionText(rsQuestion.getString("question_text"));

                    // Lấy các lựa chọn cho câu hỏi này
                    try (PreparedStatement psOptions = conn.prepareStatement(optionQuery)) {
                        psOptions.setInt(1, questionId);
                        try (ResultSet rsOptions = psOptions.executeQuery()) {
                            while (rsOptions.next()) {
                                QuizOption option = new QuizOption();
                                option.setOptionId(rsOptions.getInt("option_id"));
                                option.setQuestionId(questionId);
                                option.setOptionText(rsOptions.getString("option_text"));
                                option.setIsCorrect(rsOptions.getBoolean("is_correct"));
                                question.addOption(option);
                            }
                        }
                    }
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy câu hỏi với ID: " + questionId, e);
        }
        return question;
    }
    /**
     * Cập nhật một câu hỏi và các lựa chọn của nó.
     * Sử dụng transaction để đảm bảo tất cả các cập nhật thành công hoặc không có gì thay đổi.
     * @param question Đối tượng QuizQuestion chứa thông tin đã cập nhật.
     * @return true nếu thành công, false nếu thất bại.
     */
    public boolean updateQuestionWithOptions(QuizQuestion question) {
        String questionUpdateQuery = "UPDATE quiz_questions SET question_text = ? WHERE question_id = ?";
        String optionUpdateQuery = "UPDATE quiz_options SET option_text = ?, is_correct = ? WHERE option_id = ?";
        Connection conn = null;
        boolean success = false;

        try {
            conn = DBContext.getConnection();
            // Bắt đầu transaction
            conn.setAutoCommit(false);

            // 1. Cập nhật nội dung câu hỏi
            try (PreparedStatement psQuestion = conn.prepareStatement(questionUpdateQuery)) {
                psQuestion.setString(1, question.getQuestionText());
                psQuestion.setInt(2, question.getQuestionId());
                psQuestion.executeUpdate();
            }

            // 2. Cập nhật các lựa chọn
            try (PreparedStatement psOption = conn.prepareStatement(optionUpdateQuery)) {
                for (QuizOption option : question.getOptions()) {
                    psOption.setString(1, option.getOptionText());
                    psOption.setBoolean(2, option.isIsCorrect());
                    psOption.setInt(3, option.getOptionId());
                    psOption.addBatch(); // Thêm vào batch để thực thi cùng lúc
                }
                psOption.executeBatch(); // Thực thi batch
            }
            
            conn.commit(); // Hoàn tất transaction nếu không có lỗi
            success = true;
            LOGGER.log(Level.INFO, "Cập nhật câu hỏi và các lựa chọn thành công cho question ID: {0}", question.getQuestionId());

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật câu hỏi và lựa chọn. Đang rollback transaction.", e);
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback nếu có lỗi
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi rollback transaction.", ex);
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Trả lại trạng thái auto-commit mặc định
                    conn.close();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi đóng kết nối.", ex);
                }
            }
        }
        return success;
    }
    /**
     * Lấy lịch sử làm bài quiz của người dùng, được tổng hợp theo mỗi lần làm.
     * @param userId ID của người dùng.
     * @return Danh sách các đối tượng QuizHistoryItem.
     */
    public List<QuizHistoryItem> getQuizHistoryForUser(int userId) {
        List<QuizHistoryItem> history = new ArrayList<>();
        // Câu lệnh SQL này join 4 bảng và nhóm kết quả để tính điểm cho mỗi lần làm bài
        String query = "SELECT " +
                       "    l.lesson_id, " +
                       "    l.title AS lesson_title, " +
                       "    a.attempted_at, " +
                       "    SUM(CASE WHEN a.is_answer_correct = 1 THEN 1 ELSE 0 END) AS score, " +
                       "    COUNT(a.quiz_question_id) AS total_questions " +
                       "FROM " +
                       "    user_quiz_attempts a " +
                       "JOIN " +
                       "    quiz_questions q ON a.quiz_question_id = q.question_id " +
                       "JOIN " +
                       "    lessons l ON q.lesson_id = l.lesson_id " +
                       "WHERE " +
                       "    a.user_id = ? " +
                       "GROUP BY " +
                       "    l.lesson_id, l.title, a.attempted_at " + // Nhóm theo cả thời gian để phân biệt các lần làm khác nhau
                       "ORDER BY " +
                       "    a.attempted_at DESC;";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    QuizHistoryItem item = new QuizHistoryItem();
                    item.setLessonId(rs.getInt("lesson_id"));
                    item.setLessonTitle(rs.getString("lesson_title"));
                    item.setScore(rs.getInt("score"));
                    item.setTotalQuestions(rs.getInt("total_questions"));
                    item.setAttemptedAt(rs.getTimestamp("attempted_at"));
                    history.add(item);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy lịch sử làm bài cho user ID: " + userId, e);
        }
        return history;
    }
    /**
     * Lưu lại một lần trả lời của người dùng vào CSDL.
     * @param attempt Đối tượng UserQuizAttempt chứa thông tin cần lưu.
     * @return true nếu lưu thành công, false nếu thất bại.
     */
    public boolean saveUserAttempt(UserQuizAttempt attempt) {
        // Câu lệnh SQL để chèn một bản ghi mới vào bảng user_quiz_attempts
        String query = "INSERT INTO user_quiz_attempts (user_id, quiz_question_id, selected_option_id, is_answer_correct, attempted_at) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            // Thiết lập các tham số cho câu lệnh INSERT
            ps.setInt(1, attempt.getUserId());
            ps.setInt(2, attempt.getQuizQuestionId());
            ps.setInt(3, attempt.getSelectedOptionId());
            ps.setBoolean(4, attempt.isIsAnswerCorrect());
            ps.setTimestamp(5, new Timestamp(System.currentTimeMillis())); // Lấy thời gian hiện tại để lưu

            // Thực thi và trả về true nếu có ít nhất 1 dòng được thêm vào
            return ps.executeUpdate() > 0;

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lưu kết quả làm bài của user ID: " + attempt.getUserId(), e);
        }
        
        // Trả về false nếu có lỗi xảy ra
        return false;
    }
}
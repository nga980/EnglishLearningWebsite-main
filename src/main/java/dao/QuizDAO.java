package dao;

import model.QuizOption;
import model.QuizQuestion;
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
import javax.naming.NamingException; // Thêm import
import model.QuizHistoryItem;
import model.UserQuizAttempt;

public class QuizDAO {
    private static final Logger LOGGER = Logger.getLogger(QuizDAO.class.getName());

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
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy câu hỏi cho bài học ID: " + lessonId, e);
        }
        return questions;
    }

    public boolean addQuestionWithOptions(QuizQuestion question) {
        String questionInsertQuery = "INSERT INTO quiz_questions (lesson_id, question_text) VALUES (?, ?)";
        String optionInsertQuery = "INSERT INTO quiz_options (question_id, option_text, is_correct) VALUES (?, ?, ?)";
        Connection conn = null;
        boolean success = false;

        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);
            try (PreparedStatement psQuestion = conn.prepareStatement(questionInsertQuery, Statement.RETURN_GENERATED_KEYS)) {
                psQuestion.setInt(1, question.getLessonId());
                psQuestion.setString(2, question.getQuestionText());
                psQuestion.executeUpdate();

                try (ResultSet generatedKeys = psQuestion.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int newQuestionId = generatedKeys.getInt(1);
                        question.setQuestionId(newQuestionId);
                        try (PreparedStatement psOption = conn.prepareStatement(optionInsertQuery)) {
                            for (QuizOption option : question.getOptions()) {
                                psOption.setInt(1, newQuestionId);
                                psOption.setString(2, option.getOptionText());
                                psOption.setBoolean(3, option.isIsCorrect());
                                psOption.addBatch();
                            }
                            psOption.executeBatch();
                        }
                    } else {
                        throw new SQLException("Thêm câu hỏi thất bại, không nhận được ID.");
                    }
                }
            }
            conn.commit();
            success = true;
            LOGGER.log(Level.INFO, "Thêm câu hỏi và các lựa chọn thành công cho lesson ID: {0}", question.getLessonId());

        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi thêm câu hỏi và lựa chọn. Đang rollback transaction.", e);
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi rollback transaction.", ex);
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi đóng kết nối.", ex);
                }
            }
        }
        return success;
    }

    public boolean deleteQuestion(int questionId) {
        String query = "DELETE FROM quiz_questions WHERE question_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, questionId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa câu hỏi ID: " + questionId, e);
        }
        return false;
    }
    
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
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy câu hỏi với ID: " + questionId, e);
        }
        return question;
    }
    
    public boolean updateQuestionWithOptions(QuizQuestion question) {
        String questionUpdateQuery = "UPDATE quiz_questions SET question_text = ? WHERE question_id = ?";
        String optionUpdateQuery = "UPDATE quiz_options SET option_text = ?, is_correct = ? WHERE option_id = ?";
        Connection conn = null;
        boolean success = false;

        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);
            try (PreparedStatement psQuestion = conn.prepareStatement(questionUpdateQuery)) {
                psQuestion.setString(1, question.getQuestionText());
                psQuestion.setInt(2, question.getQuestionId());
                psQuestion.executeUpdate();
            }

            try (PreparedStatement psOption = conn.prepareStatement(optionUpdateQuery)) {
                for (QuizOption option : question.getOptions()) {
                    psOption.setString(1, option.getOptionText());
                    psOption.setBoolean(2, option.isIsCorrect());
                    psOption.setInt(3, option.getOptionId());
                    psOption.addBatch();
                }
                psOption.executeBatch();
            }
            
            conn.commit();
            success = true;
            LOGGER.log(Level.INFO, "Cập nhật câu hỏi và các lựa chọn thành công cho question ID: {0}", question.getQuestionId());

        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật câu hỏi và lựa chọn. Đang rollback transaction.", e);
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi rollback transaction.", ex);
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi đóng kết nối.", ex);
                }
            }
        }
        return success;
    }
    
    public List<QuizHistoryItem> getQuizHistoryForUser(int userId) {
        List<QuizHistoryItem> history = new ArrayList<>();
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
                       "    l.lesson_id, l.title, a.attempted_at " +
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
        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy lịch sử làm bài cho user ID: " + userId, e);
        }
        return history;
    }
    
    public boolean saveUserAttempt(UserQuizAttempt attempt) {
        String query = "INSERT INTO user_quiz_attempts (user_id, quiz_question_id, selected_option_id, is_answer_correct, attempted_at) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, attempt.getUserId());
            ps.setInt(2, attempt.getQuizQuestionId());
            ps.setInt(3, attempt.getSelectedOptionId());
            ps.setBoolean(4, attempt.isIsAnswerCorrect());
            ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));

            return ps.executeUpdate() > 0;

        } catch (SQLException | NamingException e) { // SỬA Ở ĐÂY
            LOGGER.log(Level.SEVERE, "Lỗi khi lưu kết quả làm bài của user ID: " + attempt.getUserId(), e);
        }
        
        return false;
    }
}
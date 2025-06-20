package model; // Hoặc package model của bạn

import java.util.ArrayList;
import java.util.List;

public class QuizQuestion {
    private int questionId;
    private int lessonId;
    private String questionText;
    private List<QuizOption> options; // Danh sách các lựa chọn cho câu hỏi này

    // Constructors
    public QuizQuestion() {
        // Khởi tạo danh sách options để tránh NullPointerException
        this.options = new ArrayList<>();
    }

    public QuizQuestion(int questionId, int lessonId, String questionText) {
        this.questionId = questionId;
        this.lessonId = lessonId;
        this.questionText = questionText;
        this.options = new ArrayList<>();
    }

    // Getters and Setters
    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public int getLessonId() {
        return lessonId;
    }

    public void setLessonId(int lessonId) {
        this.lessonId = lessonId;
    }

    public String getQuestionText() {
        return questionText;
    }

    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }

    public List<QuizOption> getOptions() {
        return options;
    }

    public void setOptions(List<QuizOption> options) {
        this.options = options;
    }

    // Helper method để thêm một lựa chọn vào danh sách
    public void addOption(QuizOption option) {
        if (this.options == null) {
            this.options = new ArrayList<>();
        }
        this.options.add(option);
    }

    @Override
    public String toString() {
        return "QuizQuestion{" + "questionId=" + questionId + ", lessonId=" + lessonId + ", questionText='" + questionText + '\'' + ", options=" + options.size() + '}';
    }
}
package model; // Hoặc package model của bạn

public class QuizResultDetail {

    private QuizQuestion question; // Đối tượng câu hỏi gốc
    private int selectedOptionId;  // ID của lựa chọn mà người dùng đã chọn
    private boolean wasCorrect;      // Ghi nhận câu trả lời này đúng hay sai

    // Constructors
    public QuizResultDetail() {
        this.selectedOptionId = -1; // Mặc định là chưa trả lời
    }

    public QuizResultDetail(QuizQuestion question, int selectedOptionId, boolean wasCorrect) {
        this.question = question;
        this.selectedOptionId = selectedOptionId;
        this.wasCorrect = wasCorrect;
    }

    // Getters and Setters
    public QuizQuestion getQuestion() {
        return question;
    }

    public void setQuestion(QuizQuestion question) {
        this.question = question;
    }

    public int getSelectedOptionId() {
        return selectedOptionId;
    }

    public void setSelectedOptionId(int selectedOptionId) {
        this.selectedOptionId = selectedOptionId;
    }

    public boolean isWasCorrect() {
        return wasCorrect;
    }

    public void setWasCorrect(boolean wasCorrect) {
        this.wasCorrect = wasCorrect;
    }
}
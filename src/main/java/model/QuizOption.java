package model; // Hoặc package model của bạn

public class QuizOption {
    private int optionId;
    private int questionId;
    private String optionText;
    private boolean isCorrect;

    // Constructors
    public QuizOption() {
    }

    public QuizOption(int optionId, int questionId, String optionText, boolean isCorrect) {
        this.optionId = optionId;
        this.questionId = questionId;
        this.optionText = optionText;
        this.isCorrect = isCorrect;
    }

    // Getters and Setters
    public int getOptionId() {
        return optionId;
    }

    public void setOptionId(int optionId) {
        this.optionId = optionId;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public String getOptionText() {
        return optionText;
    }

    public void setOptionText(String optionText) {
        this.optionText = optionText;
    }

    public boolean isIsCorrect() {
        return isCorrect;
    }

    public void setIsCorrect(boolean isCorrect) {
        this.isCorrect = isCorrect;
    }

    @Override
    public String toString() {
        return "QuizOption{" + "optionId=" + optionId + ", optionText='" + optionText + '\'' + ", isCorrect=" + isCorrect + '}';
    }
}
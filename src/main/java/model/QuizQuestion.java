package model;

import java.util.List;

public class QuizQuestion {
    private int questionId;
    private int lessonId;
    private int grammarTopicId; // <-- THÊM DÒNG NÀY
    private String questionText;
    private List<QuizOption> options;

    public QuizQuestion() {
    }

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

    public int getGrammarTopicId() {
        return grammarTopicId;
    }

    public void setGrammarTopicId(int grammarTopicId) {
        this.grammarTopicId = grammarTopicId;
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

    
}
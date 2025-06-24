// File: src/main/java/model/Vocabulary.java
package model;

import java.sql.Timestamp;
import java.util.Base64; // Dùng để hiển thị ảnh tạm thời nếu cần

public class Vocabulary {
    private int vocabId;
    private String word;
    private String meaning;
    private String example;
    private Integer lessonId;
    private byte[] imageData; // THAY ĐỔI
    private byte[] audioData; // THAY ĐỔI
    private Timestamp createdAt;

    // Constructors, Getters, and Setters

    public Vocabulary() {
    }
    public int getVocabId() {    
        return vocabId;
    }

    public void setVocabId(int vocabId) {
        this.vocabId = vocabId;
    }

    public String getWord() {
        return word;
    }

    public void setWord(String word) {
        this.word = word;
    }

    public String getMeaning() {
        return meaning;
    }

    public void setMeaning(String meaning) {
        this.meaning = meaning;
    }

    public String getExample() {
        return example;
    }

    public void setExample(String example) {
        this.example = example;
    }

    public Integer getLessonId() {
        return lessonId;
    }

    public void setLessonId(Integer lessonId) {
        this.lessonId = lessonId;
    }

    public byte[] getImageData() {
        return imageData;
    }

    public void setImageData(byte[] imageData) {
        this.imageData = imageData;
    }

    public byte[] getAudioData() {
        return audioData;
    }

    public void setAudioData(byte[] audioData) {
        this.audioData = audioData;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    // Getters and Setters đã cập nhật
    public void setCreatedAt(Timestamp createdAt) {    
        this.createdAt = createdAt;
    }

    // Helper method để kiểm tra xem có ảnh không (dùng trong JSP)
    public boolean getHasImage() {
        return this.imageData != null && this.imageData.length > 0;
    }

    // Helper method để kiểm tra xem có audio không
    public boolean getHasAudio() {
        return this.audioData != null && this.audioData.length > 0;
    }
}
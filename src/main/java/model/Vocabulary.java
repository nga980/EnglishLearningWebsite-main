package model;

import java.io.Serializable;

public class Vocabulary implements Serializable {
    private int vocabId;
    private String word;
    private String meaning;
    private String example;

    private transient byte[] imageData;
    private transient byte[] audioData;

    private Integer lessonId;
    private java.sql.Timestamp createdAt;

    // THÊM CÁC TRƯỜNG hasImage và hasAudio
    private boolean hasImage;
    private boolean hasAudio;

    // CONSTRUCTOR
    public Vocabulary() {}

    // GETTERS
    public int getVocabId() { return vocabId; }
    public String getWord() { return word; }
    public String getMeaning() { return meaning; }
    public String getExample() { return example; }
    public byte[] getImageData() { return imageData; }
    public byte[] getAudioData() { return audioData; }
    public Integer getLessonId() { return lessonId; }
    public java.sql.Timestamp getCreatedAt() { return createdAt; }

    // THÊM GETTERS MỚI
    public boolean isHasImage() { return hasImage; } // Getter cho boolean thường dùng is...
    public boolean isHasAudio() { return hasAudio; } // Getter cho boolean thường dùng is...

    // SETTERS
    public void setVocabId(int vocabId) { this.vocabId = vocabId; }
    public void setWord(String word) { this.word = word; }
    public void setMeaning(String meaning) { this.meaning = meaning; }
    public void setExample(String example) { this.example = example; }
    public void setImageData(byte[] imageData) { this.imageData = imageData; }
    public void setAudioData(byte[] audioData) { this.audioData = audioData; }
    public void setLessonId(Integer lessonId) { this.lessonId = lessonId; }
    public void setCreatedAt(java.sql.Timestamp createdAt) { this.createdAt = createdAt; }

    // THÊM SETTERS MỚI
    public void setHasImage(boolean hasImage) { this.hasImage = hasImage; }
    public void setHasAudio(boolean hasAudio) { this.hasAudio = hasAudio; }

    @Override
    public String toString() {
        return "Vocabulary{" +
               "vocabId=" + vocabId +
               ", word='" + word + '\'' +
               ", meaning='" + meaning + '\'' +
               ", hasImage=" + hasImage + // Thêm vào toString nếu muốn
               ", hasAudio=" + hasAudio + // Thêm vào toString nếu muốn
               '}';
    }
}
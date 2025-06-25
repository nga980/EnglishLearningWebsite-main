package controller;

import dao.VocabularyDAO;
import model.Vocabulary;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.LinkedList; // For Queue
import java.util.logging.Level;
import java.util.logging.Logger;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException; // Import thêm cho lỗi cú pháp JSON
import com.google.gson.reflect.TypeToken;

// Lớp trợ giúp để parse JSON từ frontend
class UserAttempt {
    private int wordId;
    private int meaningId;
    // Client-side isCorrect là để phản hồi tức thì cho người dùng,
    // Backend sẽ tự xác thực lại. Không cần nhận trường này từ frontend.
    // private boolean isCorrect;

    public int getWordId() { return wordId; }
    public void setWordId(int wordId) { this.wordId = wordId; }
    public int getMeaningId() { return meaningId; }
    public void setMeaningId(int meaningId) { this.meaningId = meaningId; }
    // public boolean getIsCorrect() { return isCorrect; }
    // public void setIsCorrect(boolean isCorrect) { this.isCorrect = isCorrect; }
}

// Lớp để đóng gói dữ liệu game state, lưu trữ trong session
class GameState {
    private List<Vocabulary> allGameVocabularies; // Toàn bộ từ vựng được tải cho game này
    private Queue<Vocabulary> remainingVocabulariesQueue; // Các từ còn lại chưa được đưa lên màn hình chơi
    private List<Vocabulary> currentPlayingVocabularies; // Các từ đang hiển thị trên màn hình
    private List<UserAttempt> allUserAttempts; // Tất cả các lần thử của người dùng trong suốt game
    private Map<Integer, Integer> wordIncorrectCounts; // Số lần sai của mỗi từ
    private Integer lessonId; // ID bài học hiện tại (hoặc 0/null nếu là game ngẫu nhiên/không bài học)
    private Map<Integer, Vocabulary> vocabByIdMap; // Map để tra cứu Vocabulary object nhanh chóng theo vocabId

    public GameState(List<Vocabulary> allVocab, Integer lessonId) {
        this.allGameVocabularies = new ArrayList<>(allVocab);
        Collections.shuffle(this.allGameVocabularies); // Xáo trộn toàn bộ danh sách một lần khi khởi tạo
        this.remainingVocabulariesQueue = new LinkedList<>(this.allGameVocabularies);
        this.currentPlayingVocabularies = new ArrayList<>();
        this.allUserAttempts = new ArrayList<>();
        this.wordIncorrectCounts = new HashMap<>();
        this.lessonId = lessonId;

        // Xây dựng vocabByIdMap để tra cứu nhanh chóng
        this.vocabByIdMap = new HashMap<>();
        for (Vocabulary vocab : allVocab) {
            this.vocabByIdMap.put(vocab.getVocabId(), vocab);
        }
    }

    // Getters
    public List<Vocabulary> getAllGameVocabularies() { return allGameVocabularies; }
    public Queue<Vocabulary> getRemainingVocabulariesQueue() { return remainingVocabulariesQueue; }
    public List<Vocabulary> getCurrentPlayingVocabularies() { return currentPlayingVocabularies; }
    public List<UserAttempt> getAllUserAttempts() { return allUserAttempts; }
    public Map<Integer, Integer> getWordIncorrectCounts() { return wordIncorrectCounts; }
    public Integer getLessonId() { return lessonId; }
    public Map<Integer, Vocabulary> getVocabByIdMap() { return vocabByIdMap; }

    /**
     * Thêm 'count' từ vựng tiếp theo từ hàng đợi vào danh sách đang chơi.
     * Đảm bảo không thêm quá số lượng tối đa (maxPairs) để duy trì số cặp cố định trên màn hình.
     */
    public void addNextVocabularyToCurrentPlaying(int count, int maxPairs) {
        for (int i = 0; i < count && !remainingVocabulariesQueue.isEmpty() && currentPlayingVocabularies.size() < maxPairs; i++) {
            currentPlayingVocabularies.add(remainingVocabulariesQueue.poll());
        }
    }

    // Loại bỏ từ đã khớp đúng khỏi danh sách đang chơi
    public void removeMatchedVocabulary(int vocabId) {
        currentPlayingVocabularies.removeIf(v -> v.getVocabId() == vocabId); // Đảm bảo đúng logic: v.getVocabId() == vocabId
    }
}

@WebServlet(name = "MatchingGameServlet", urlPatterns = {"/matching-game"})
public class MatchingGameServlet extends HttpServlet {
    private VocabularyDAO vocabularyDAO;
    private Gson gson;
    private static final Logger LOGGER = Logger.getLogger(MatchingGameServlet.class.getName());

    // Số cặp từ hiển thị ban đầu trên màn hình game
    private static final int INITIAL_PAIRS_COUNT = 5;

    @Override
    public void init() {
        vocabularyDAO = new VocabularyDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String lessonIdStr = request.getParameter("lessonId");
        Integer lessonId = null; // Mặc định là null (lấy ngẫu nhiên từ tất cả)
        

        List<Vocabulary> allVocabulariesForGame; // Toàn bộ từ vựng có thể chơi trong game này

        try {
            if (lessonIdStr != null && !lessonIdStr.trim().isEmpty()) {
                int parsedLessonId = Integer.parseInt(lessonIdStr);
                // Quy ước: lessonId < 0 hoặc không phải số: lấy ngẫu nhiên từ tất cả.
                // lessonId == 0: lấy từ vựng không thuộc bài học nào (lesson_id IS NULL).
                // lessonId > 0: lấy từ vựng theo ID bài học cụ thể.
                if (parsedLessonId < 0) {
                    LOGGER.log(Level.INFO, "Requesting random vocabulary across all lessons (lessonId < 0).");
                    lessonId = null; // Set to null để DAO lấy tất cả
                } else {
                    lessonId = parsedLessonId;
                }
            }

            // Lấy TOÀN BỘ từ vựng cho game này (không giới hạn số lượng ở đây)
            allVocabulariesForGame = vocabularyDAO.getAllVocabularyForMatchingGame(lessonId);
            // Trong doGet sau khi lấy allVocabulariesForGame
            LOGGER.log(Level.INFO, "All vocabularies fetched for game: {0}", allVocabulariesForGame.size());
            if (!allVocabulariesForGame.isEmpty()) {
                LOGGER.log(Level.INFO, "First vocab ID: {0}, Word: {1}, Meaning: {2}",
                    new Object[]{allVocabulariesForGame.get(0).getVocabId(),
                                 allVocabulariesForGame.get(0).getWord(),
                                 allVocabulariesForGame.get(0).getMeaning()});
            }

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "NumberFormatException for lessonId in MatchingGameServlet (doGet): {0}. Defaulting to random vocabulary.", lessonIdStr);
            allVocabulariesForGame = vocabularyDAO.getAllVocabularyForMatchingGame(null); // Fallback to random all
            lessonId = null; // Reset lessonId cho JSP để phản ánh "random"
            session.setAttribute("errorMessage", "ID bài học không đúng định dạng. Đang tải game ngẫu nhiên.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching all vocabulary for matching game. Lesson ID: " + lessonIdStr, e);
            session.setAttribute("errorMessage", "Lỗi hệ thống khi tải từ vựng. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/vocabulary");
            return;
        }

        // Kiểm tra số lượng từ vựng đủ để tạo game
        if (allVocabulariesForGame.isEmpty() || allVocabulariesForGame.size() < 2) {
            LOGGER.log(Level.INFO, "Not enough vocabulary ({0} items) for matching game. Need at least 2.", allVocabulariesForGame.size());

            String msg;
            // Xác định thông báo lỗi dựa trên việc có lessonId cụ thể hay không
            if (lessonId != null && lessonId > 0) {
                // Ví dụ: "Bài học này hiện không đủ từ vựng (X từ) để chơi game nối từ. Cần ít nhất Y cặp từ có nghĩa."
                msg = "Bài học này hiện không đủ từ vựng (" + allVocabulariesForGame.size() + " từ) để chơi game nối từ. Cần ít nhất " + INITIAL_PAIRS_COUNT + " cặp từ có nghĩa.";
            } else {
                // Ví dụ: "Hệ thống không có đủ từ vựng (X từ) để tạo game nối từ ngẫu nhiên. Cần ít nhất Y cặp từ có nghĩa."
                msg = "Hệ thống không có đủ từ vựng (" + allVocabulariesForGame.size() + " từ) để tạo game nối từ ngẫu nhiên. Cần ít nhất " + INITIAL_PAIRS_COUNT + " cặp từ có nghĩa.";
            }
            session.setAttribute("errorMessage", msg); // Đặt thông báo lỗi vào session

            // Chuyển hướng người dùng đến trang phù hợp (chi tiết bài học hoặc danh sách từ vựng)
            if (lessonId != null && lessonId > 0) {
                response.sendRedirect(request.getContextPath() + "/lesson-detail?lessonId=" + lessonId);
            } else {
                response.sendRedirect(request.getContextPath() + "/vocabulary");
            }
            return; // Dừng xử lý ở đây
        }

        // Khởi tạo trạng thái game mới và lưu vào session
        GameState gameState = new GameState(allVocabulariesForGame, lessonId);
        // Lấy INITIAL_PAIRS_COUNT cặp từ đầu tiên để hiển thị lên màn hình
        gameState.addNextVocabularyToCurrentPlaying(INITIAL_PAIRS_COUNT, INITIAL_PAIRS_COUNT); // Lấy INITIAL_PAIRS_COUNT từ, giới hạn cũng INITIAL_PAIRS_COUNT

        session.setAttribute("matchingGameState", gameState);

        // Chuẩn bị dữ liệu cho JSP hiển thị lần đầu
        List<Vocabulary> wordsColumn = new ArrayList<>(gameState.getCurrentPlayingVocabularies());
        List<Vocabulary> meaningsColumn = new ArrayList<>(gameState.getCurrentPlayingVocabularies());

        // Xáo trộn riêng từng cột để đảm bảo các cặp không liền kề nhau
        Collections.shuffle(wordsColumn);
        Collections.shuffle(meaningsColumn);

        request.setAttribute("wordsColumn", wordsColumn);
        request.setAttribute("meaningsColumn", meaningsColumn);
        // Truyền 0 nếu là game ngẫu nhiên/không bài học để hiển thị trên JSP
        request.setAttribute("lessonId", (lessonId != null) ? lessonId : 0);
        // Tổng số từ vựng ban đầu của game (dùng để tính số cặp còn lại)
        request.setAttribute("totalGameVocabularies", gameState.getAllGameVocabularies().size());

        request.getRequestDispatcher("/matchingGame.jsp").forward(request, response);
    }

    // Xử lý các yêu cầu POST từ frontend, bao gồm AJAX cho lượt chơi và nộp kết quả cuối cùng
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Thiết lập loại nội dung phản hồi là JSON và mã hóa UTF-8
        response.setContentType("application/json;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // Lấy trạng thái game từ session
        GameState gameState = (GameState) session.getAttribute("matchingGameState");
        if (gameState == null) {
            // Nếu không tìm thấy trạng thái game, trả về lỗi
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // Có thể là 400 hoặc 401/403 nếu có user session
            response.getWriter().write(gson.toJson(Map.of("error", "Game session not found or expired. Please restart the game.")));
            LOGGER.log(Level.WARNING, "Game session not found for POST request. User might have refreshed or session expired.");
            return;
        }

        String action = request.getParameter("action"); // Lấy hành động từ request

        if ("submitFinalResult".equals(action)) {
            // Xử lý khi người dùng nộp kết quả cuối cùng của game
            handleFinalResultSubmission(request, response, session, gameState);
        } else if ("matchAttempt".equals(action)) {
            // Xử lý khi người dùng thử nối một cặp từ
            handleMatchAttempt(request, response, gameState);
        } else {
            // Hành động không hợp lệ
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(Map.of("error", "Invalid action.")));
            LOGGER.log(Level.WARNING, "Invalid action received: {0}", action);
        }
    }

    /**
     * Xử lý một lần thử nối cặp từ từ frontend.
     * Đọc JSON từ request body, xác thực dữ liệu, cập nhật trạng thái game,
     * và trả về kết quả (đúng/sai) cùng với các từ đang hiển thị.
     */
    private void handleMatchAttempt(HttpServletRequest request, HttpServletResponse response, GameState gameState) throws IOException {
        // 1. Đọc JSON từ body của request
        StringBuilder sb = new StringBuilder();
        String line;
        try (java.io.BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error reading request body for matchAttempt", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            
            response.getWriter().write(gson.toJson(Map.of("error", "Failed to read request body.")));
            return;
        }
        String attemptJson = sb.toString();

        // 2. Ghi log JSON nhận được để debug
        LOGGER.log(Level.INFO, "Received JSON attempt: {0}", attemptJson);

        UserAttempt attempt = null;
        try {
            // 3. Kiểm tra chuỗi JSON có rỗng hoặc null không
            if (attemptJson == null || attemptJson.trim().isEmpty()) {
                LOGGER.log(Level.WARNING, "Received empty or null JSON string for match attempt.");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(gson.toJson(Map.of("error", "Received empty or invalid JSON data.")));
                return;
            }

            // 4. Phân tích JSON thành đối tượng UserAttempt
            attempt = gson.fromJson(attemptJson, UserAttempt.class);

            // 5. Kiểm tra nếu Gson trả về null (thường do JSON không thể mapping)
            if (attempt == null) {
                LOGGER.log(Level.WARNING, "Gson returned null after parsing JSON: {0}. Check UserAttempt class structure vs JSON.", attemptJson);
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(gson.toJson(Map.of("error", "Failed to parse JSON into UserAttempt object. Check JSON structure.")));
                return;
            }

            // 6. Xác thực các ID nhận được có tồn tại trong dữ liệu game gốc không
            if (!gameState.getVocabByIdMap().containsKey(attempt.getWordId()) || !gameState.getVocabByIdMap().containsKey(attempt.getMeaningId())) {
                LOGGER.log(Level.WARNING, "Attempt contains invalid vocabId(s) not found in game state. WordId: {0}, MeaningId: {1}",
                    new Object[]{attempt.getWordId(), attempt.getMeaningId()});
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(gson.toJson(Map.of("error", "Invalid word or meaning ID submitted.")));
                return;
            }

        } catch (JsonSyntaxException e) { // Bắt lỗi cú pháp JSON cụ thể
            LOGGER.log(Level.SEVERE, "JsonSyntaxException when parsing match attempt JSON: " + attemptJson, e);
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(Map.of("error", "Invalid JSON syntax. Please check data format.")));
            return;
        } catch (Exception e) { // Bắt các lỗi khác trong quá trình parsing
            LOGGER.log(Level.SEVERE, "Unexpected error parsing match attempt JSON: " + attemptJson, e);
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(Map.of("error", "Failed to process attempt data due to unexpected format.")));
            return;
        }

        // --- Nếu đến được đây, 'attempt' chắc chắn không null và chứa ID hợp lệ ---

        // 7. Tra cứu nghĩa đúng của từ và nghĩa được chọn bằng vocabByIdMap trong GameState
        Vocabulary wordVocab = gameState.getVocabByIdMap().get(attempt.getWordId());
        Vocabulary meaningVocab = gameState.getVocabByIdMap().get(attempt.getMeaningId());

        String wordMeaning = wordVocab.getMeaning(); // Không cần kiểm tra null nữa vì đã xác thực ở trên
        String submittedMeaning = meaningVocab.getMeaning(); // Không cần kiểm tra null nữa

        // 8. Xác định xem cặp nối có đúng hay không
        boolean isCorrect = (wordMeaning.equals(submittedMeaning));
        // attempt.setIsCorrect(isCorrect); // Nếu UserAttempt có trường này và muốn lưu trạng thái từ frontend

        gameState.getAllUserAttempts().add(attempt); // Thêm lần thử vào danh sách tất cả các lần thử

        if (!isCorrect) {
            // Nếu sai, tăng số lần sai cho từ đó trong GameState
            gameState.getWordIncorrectCounts().put(attempt.getWordId(), gameState.getWordIncorrectCounts().getOrDefault(attempt.getWordId(), 0) + 1);
        } else { // Nếu đúng
            // Loại bỏ từ đã khớp đúng khỏi danh sách các từ đang hiển thị
            gameState.removeMatchedVocabulary(attempt.getWordId());

            // Thêm một từ mới từ hàng đợi nếu còn từ và số lượng cặp đang chơi chưa đạt giới hạn
            if (!gameState.getRemainingVocabulariesQueue().isEmpty() && gameState.getCurrentPlayingVocabularies().size() < INITIAL_PAIRS_COUNT) {
                gameState.addNextVocabularyToCurrentPlaying(1, INITIAL_PAIRS_COUNT); // Thêm 1 từ mới
            }
        }

        // 9. Chuẩn bị dữ liệu phản hồi cho frontend
        Map<String, Object> responseData = new HashMap<>();
        responseData.put("isCorrect", isCorrect); // Kết quả của lần thử này (đúng/sai)
        responseData.put("remainingVocabCount", gameState.getRemainingVocabulariesQueue().size()); // Số từ còn lại trong hàng đợi
        responseData.put("currentPlayingCount", gameState.getCurrentPlayingVocabularies().size()); // Số từ đang hiển thị trên màn hình

        // 10. Luôn gửi về danh sách các từ đang chơi hiện tại để frontend render lại giao diện
        List<Vocabulary> wordsColumnForResponse = new ArrayList<>(gameState.getCurrentPlayingVocabularies());
        List<Vocabulary> meaningsColumnForResponse = new ArrayList<>(gameState.getCurrentPlayingVocabularies());
        Collections.shuffle(wordsColumnForResponse); // Xáo trộn để vị trí các từ không cố định
        Collections.shuffle(meaningsColumnForResponse); // Xáo trộn để vị trí các nghĩa không cố định

        responseData.put("wordsColumn", wordsColumnForResponse);
        responseData.put("meaningsColumn", meaningsColumnForResponse);

        // 11. Kiểm tra nếu game đã hoàn thành (không còn từ nào trong hàng đợi và không còn từ nào đang chơi)
        boolean gameFinished = gameState.getRemainingVocabulariesQueue().isEmpty() && gameState.getCurrentPlayingVocabularies().isEmpty();
        responseData.put("gameFinished", gameFinished);
        String finalResponseJson = gson.toJson(responseData);
        LOGGER.log(Level.INFO, "Sending response JSON to frontend: {0}", finalResponseJson);

        // 12. Gửi dữ liệu phản hồi về frontend dưới dạng JSON
        response.getWriter().write(gson.toJson(responseData));
    }

    /**
     * Xử lý việc nộp kết quả cuối cùng khi game kết thúc.
     * Tính toán điểm số, thống kê chi tiết và chuyển hướng đến trang kết quả.
     */
    private void handleFinalResultSubmission(HttpServletRequest request, HttpServletResponse response, HttpSession session, GameState gameState) throws IOException, ServletException {
        // Lấy tổng số lần sai từ frontend (frontend tính toán để có phản hồi tức thì cho người dùng)
        String totalIncorrectAttemptsStr = request.getParameter("totalIncorrectAttempts");
        int totalIncorrectAttempts = 0;
        if (totalIncorrectAttemptsStr != null && !totalIncorrectAttemptsStr.isEmpty()) {
            try {
                totalIncorrectAttempts = Integer.parseInt(totalIncorrectAttemptsStr);
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "NumberFormatException for totalIncorrectAttempts in final submission: {0}", totalIncorrectAttemptsStr);
            }
        }

        int finalScore = 0; // Điểm số cuối cùng (số cặp đúng duy nhất)
        // Lấy map số lần sai của mỗi từ từ GameState (đã được cập nhật trong suốt quá trình chơi)
        Map<Integer, Integer> finalWordIncorrectCounts = gameState.getWordIncorrectCounts();
        List<Map<String, Object>> incorrectPairsDetails = new ArrayList<>(); // Chi tiết các cặp bị nối sai
        List<Map<String, Object>> allCorrectPairs = new ArrayList<>(); // Tất cả các cặp được nối đúng cuối cùng

        // Map để theo dõi các từ đã được khớp đúng cuối cùng (để tính finalScore một cách chính xác)
        Map<Integer, Boolean> wordsCorrectlyMatchedFinal = new HashMap<>();
        // Khởi tạo tất cả các từ trong game là chưa được khớp đúng
        for (Vocabulary vocab : gameState.getAllGameVocabularies()) {
            wordsCorrectlyMatchedFinal.put(vocab.getVocabId(), false);
        }

        // Duyệt qua tất cả các lần thử của người dùng để tính toán kết quả cuối cùng
        for (UserAttempt attempt : gameState.getAllUserAttempts()) {
            // Tra cứu từ và nghĩa gốc bằng vocabByIdMap
            Vocabulary wordVocab = gameState.getVocabByIdMap().get(attempt.getWordId());
            Vocabulary meaningVocab = gameState.getVocabByIdMap().get(attempt.getMeaningId());

            // Kiểm tra null ở đây, mặc dù lý thuyết là đã được xác thực ở handleMatchAttempt
            // nhưng an toàn hơn khi kiểm tra lại hoặc đảm bảo dữ liệu trong allGameVocabularies là toàn vẹn.
            if (wordVocab == null || meaningVocab == null) {
                 LOGGER.log(Level.WARNING, "Skipping attempt with null vocab objects in final submission. WordId: {0}, MeaningId: {1}",
                     new Object[]{attempt.getWordId(), attempt.getMeaningId()});
                 continue; // Bỏ qua lần thử này nếu có vấn đề về dữ liệu gốc
            }

            String wordMeaning = wordVocab.getMeaning();
            String submittedMeaning = meaningVocab.getMeaning();

            boolean isCorrect = (wordMeaning != null && wordMeaning.equals(submittedMeaning));

            if (isCorrect) {
                // Nếu đây là một cặp đúng, đánh dấu từ của cặp này là đã được khớp đúng
                wordsCorrectlyMatchedFinal.put(attempt.getWordId(), true);

                // Thêm vào allCorrectPairs nếu cặp này chưa được thêm trước đó (để tránh trùng lặp trên báo cáo)
                Map<String, Object> correctDetail = new HashMap<>();
                correctDetail.put("wordId", attempt.getWordId());
                correctDetail.put("word", wordVocab.getWord());
                correctDetail.put("meaningId", attempt.getMeaningId());
                correctDetail.put("meaning", meaningVocab.getMeaning());

                // Kiểm tra trùng lặp dựa trên wordId và meaningId (cần cast sang Integer)
                if (!allCorrectPairs.stream().anyMatch(p ->
                    ((Integer)p.get("wordId")).intValue() == attempt.getWordId() && ((Integer)p.get("meaningId")).intValue() == attempt.getMeaningId()
                )) {
                    allCorrectPairs.add(correctDetail);
                }
            } else {
                // Nếu đây là một cặp sai, thêm vào danh sách chi tiết các cặp sai
                Map<String, Object> incorrectDetail = new HashMap<>();
                incorrectDetail.put("wordId", attempt.getWordId());
                incorrectDetail.put("word", wordVocab.getWord());
                incorrectDetail.put("meaningId", attempt.getMeaningId());
                incorrectDetail.put("meaning", meaningVocab.getMeaning());

                // Kiểm tra trùng lặp dựa trên wordId và meaningId (cần cast sang Integer)
                if (!incorrectPairsDetails.stream().anyMatch(p ->
                    ((Integer)p.get("wordId")).intValue() == attempt.getWordId() && ((Integer)p.get("meaningId")).intValue() == attempt.getMeaningId()
                )) {
                    incorrectPairsDetails.add(incorrectDetail);
                }
            }
        }
        // finalScore là số lượng từ đã được khớp đúng cuối cùng (mỗi từ chỉ tính 1 lần)
        finalScore = (int) wordsCorrectlyMatchedFinal.values().stream().filter(b -> b).count();

        // Xóa trạng thái game khỏi session sau khi hoàn thành để giải phóng bộ nhớ
        session.removeAttribute("matchingGameState");

        // Đặt các thuộc tính cần thiết vào request để gửi đến JSP kết quả
        request.setAttribute("finalScore", finalScore);
        // Tổng số từ vựng ban đầu của game (tổng số cặp cần khớp)
        request.setAttribute("totalPairs", gameState.getAllGameVocabularies().size());
        // Tổng số lần sai ghi nhận từ frontend
        request.setAttribute("totalIncorrectAttempts", totalIncorrectAttempts);
        // Chi tiết các cặp bị sai (đã lọc trùng)
        request.setAttribute("incorrectPairsDetails", incorrectPairsDetails);
        // Số lần sai của từng từ (map)
        request.setAttribute("wordIncorrectCount", finalWordIncorrectCounts);
        // Tất cả các cặp được nối đúng cuối cùng (đã lọc trùng)
        request.setAttribute("allCorrectPairs", allCorrectPairs);
        // ID bài học (hoặc 0) để có thể chơi lại/quay về đúng trang
        request.setAttribute("lessonId", (gameState.getLessonId() != null) ? gameState.getLessonId() : 0);

        // Chuyển tiếp request đến trang kết quả game
        request.getRequestDispatcher("/matchingGameResult.jsp").forward(request, response);
    }
}
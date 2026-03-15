package main

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"
)

type AskRequest struct {
	Question string `json:"question"`
}

type AskResponse struct {
	Answer string `json:"answer"`
}

type OllamaRequest struct {
	Model  string `json:"model"`
	Prompt string `json:"prompt"`
	Stream bool   `json:"stream"`
}

type OllamaResponse struct {
	Response string `json:"response"`
}

var (
	provider       = getEnv("PROVIDER", "ollama")
	geminiAPIKey   = os.Getenv("GEMINI_API_KEY")
	geminiModel    = getEnv("GEMINI_MODEL", "gemini-2.5-flash")
	ollamaURL      = getEnv("OLLAMA_URL", "http://localhost:11434")
	ollamaModel    = getEnv("OLLAMA_MODEL", "phi3")
	timeout        = 120 * time.Second
	maxRetries     = 3
	httpClient     = &http.Client{Timeout: timeout}
)

func main() {

	http.HandleFunc("/ask", askHandler)

	log.Println("Server started on :8000")

	// optional warmup
	go func() {
		log.Println("Warming up Ollama model...")
		_, _ = callOllama("hello")
	}()

	log.Fatal(http.ListenAndServe(":8000", nil))
}

func askHandler(w http.ResponseWriter, r *http.Request) {

	if r.Method != http.MethodPost {
		http.Error(w, "Only POST allowed", http.StatusMethodNotAllowed)
		return
	}

	var req AskRequest

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	log.Println("Question:", req.Question)

	prompt := buildPrompt(req.Question)

	var (
		answer string
		err    error
	)

	switch provider {

	case "gemini":
		answer, err = callGemini(prompt)

	case "ollama":
		answer, err = callOllama(prompt)

	default:
		http.Error(w, "Unsupported provider", http.StatusInternalServerError)
		return
	}

	if err != nil {
		log.Println("Error:", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	resp := AskResponse{Answer: answer}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(resp)
}

func buildPrompt(question string) string {
	return fmt.Sprintf(
		"You are a helpful customer support assistant. Answer clearly.\n\nUser question: %s",
		question,
	)
}

func callOllama(prompt string) (string, error) {

	reqBody := OllamaRequest{
		Model:  ollamaModel,
		Prompt: prompt,
		Stream: false,
	}

	body, err := json.Marshal(reqBody)
	if err != nil {
		return "", err
	}

	url := fmt.Sprintf("%s/api/generate", ollamaURL)

	for i := 0; i < maxRetries; i++ {

		ctx, cancel := context.WithTimeout(context.Background(), timeout)

		req, err := http.NewRequestWithContext(
			ctx,
			"POST",
			url,
			bytes.NewBuffer(body),
		)

		if err != nil {
			cancel()
			return "", err
		}

		req.Header.Set("Content-Type", "application/json")

		resp, err := httpClient.Do(req)
		cancel()

		if err != nil {
			log.Println("Retry Ollama:", err)
			time.Sleep(2 * time.Second)
			continue
		}

		defer resp.Body.Close()

		if resp.StatusCode != http.StatusOK {
			return "", fmt.Errorf("ollama error: %s", resp.Status)
		}

		var result OllamaResponse

		if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
			return "", err
		}

		return result.Response, nil
	}

	return "", fmt.Errorf("ollama failed after retries")
}

func callGemini(prompt string) (string, error) {
	return "", fmt.Errorf("Gemini not implemented in this clean version")
}

func getEnv(key, fallback string) string {

	val := os.Getenv(key)

	if val == "" {
		return fallback
	}

	return val
}
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

var (
	provider       = getEnv("PROVIDER", "gemini")
	geminiAPIKey   = os.Getenv("GEMINI_API_KEY")
	geminiModel    = getEnv("GEMINI_MODEL", "gemini-2.5-flash")
	ollamaURL      = getEnv("OLLAMA_URL", "http://localhost:11434")
	ollamaModel    = getEnv("OLLAMA_MODEL", "phi3")
	timeoutSeconds = 20
	maxRetries     = 3
)

func main() {

	http.HandleFunc("/ask", askHandler)

	log.Println("Server started on :8000")
	log.Fatal(http.ListenAndServe(":8000", nil))
}

func askHandler(w http.ResponseWriter, r *http.Request) {

	if r.Method != http.MethodPost {
		http.Error(w, "Only POST allowed", http.StatusMethodNotAllowed)
		return
	}

	var req AskRequest

	err := json.NewDecoder(r.Body).Decode(&req)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	log.Printf("Incoming question: %s\n", req.Question)

	prompt := buildPrompt(req.Question)

	var answer string

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
		http.Error(w, err.Error(), 500)
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

func callGemini(prompt string) (string, error) {

	url := fmt.Sprintf(
		"https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent?key=%s",
		geminiModel,
		geminiAPIKey,
	)

	payload := map[string]interface{}{
		"contents": []map[string]interface{}{
			{
				"parts": []map[string]string{
					{"text": prompt},
				},
			},
		},
	}

	body, _ := json.Marshal(payload)

	for i := 0; i < maxRetries; i++ {

		ctx, cancel := context.WithTimeout(context.Background(), time.Duration(timeoutSeconds)*time.Second)
		defer cancel()

		req, _ := http.NewRequestWithContext(ctx, "POST", url, bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")

		client := &http.Client{}

		resp, err := client.Do(req)
		if err != nil {
			log.Println("Retry Gemini:", err)
			continue
		}

		defer resp.Body.Close()

		var result map[string]interface{}

		err = json.NewDecoder(resp.Body).Decode(&result)
		if err != nil {
			continue
		}

		candidates := result["candidates"].([]interface{})
		content := candidates[0].(map[string]interface{})["content"].(map[string]interface{})
		parts := content["parts"].([]interface{})
		text := parts[0].(map[string]interface{})["text"].(string)

		return text, nil
	}

	return "", fmt.Errorf("Gemini failed after retries")
}

func callOllama(prompt string) (string, error) {

	url := fmt.Sprintf("%s/api/generate", ollamaURL)

	payload := map[string]interface{}{
		"model":  ollamaModel,
		"prompt": prompt,
		"stream": false,
	}

	body, _ := json.Marshal(payload)

	for i := 0; i < maxRetries; i++ {

		ctx, cancel := context.WithTimeout(context.Background(), time.Duration(timeoutSeconds)*time.Second)
		defer cancel()

		req, _ := http.NewRequestWithContext(ctx, "POST", url, bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")

		client := &http.Client{}

		resp, err := client.Do(req)
		if err != nil {
			log.Println("Retry Ollama:", err)
			continue
		}

		defer resp.Body.Close()

		var result map[string]interface{}

		err = json.NewDecoder(resp.Body).Decode(&result)
		if err != nil {
			continue
		}

		text := result["response"].(string)

		return text, nil
	}

	return "", fmt.Errorf("Ollama failed after retries")
}

func getEnv(key, fallback string) string {

	value := os.Getenv(key)

	if value == "" {
		return fallback
	}

	return value
}

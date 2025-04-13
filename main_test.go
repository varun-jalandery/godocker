package main

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

// Test the root route ("/")
func TestRootRoute(t *testing.T) {
	router := setupRouter()

	// Create a request to the root route
	req, _ := http.NewRequest("GET", "/", nil)
	w := httptest.NewRecorder()

	// Serve the request
	router.ServeHTTP(w, req)

	// Check the response status code and body
	assert.Equal(t, http.StatusOK, w.Code)
	assert.Equal(t, "Hello, Docker!!! <3", w.Body.String())
}

// Test the health check route ("/health")
func TestHealthRoute(t *testing.T) {
	router := setupRouter()

	// Create a request to the health route
	req, _ := http.NewRequest("GET", "/health", nil)
	w := httptest.NewRecorder()

	// Serve the request
	router.ServeHTTP(w, req)

	// Check the response status code
	assert.Equal(t, http.StatusOK, w.Code)

	// Check the response body
	expectedBody := `{"status":"OK"}`
	assert.JSONEq(t, expectedBody, w.Body.String())
}

// Test the users route ("/users")
func TestUsersRoute(t *testing.T) {
	router := setupRouter()

	// Create a request to the users route
	req, _ := http.NewRequest("GET", "/users", nil)
	w := httptest.NewRecorder()

	// Serve the request
	router.ServeHTTP(w, req)

	// Check the response status code
	assert.Equal(t, http.StatusOK, w.Code)

	// Check the response body
	expectedBody := `{"id":"1","name":"Varun"}`
	assert.JSONEq(t, expectedBody, w.Body.String())
}

// setupRouter is a helper function to initialize the router for testing
func setupRouter() *gin.Engine {
	// Create a Gin router
	router := gin.Default()

	// Register the API routes
	router.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "Hello, Docker!!! <3")
	})

	router.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status": "OK",
		})
	})

	router.GET("/users", func(c *gin.Context) {
		user := User{
			ID:   "1",
			Name: "Varun",
		}
		c.JSON(http.StatusOK, user)
	})

	return router
}

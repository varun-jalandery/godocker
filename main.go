package main

import (
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

// User struct represents a model for user data.
// The `json` tags define the JSON keys when the struct is serialized into JSON.
type User struct {
	ID   string `json:"id"`   // User ID (string)
	Name string `json:"name"` // User name (string)
}

func main() {
	// Initialize a new Gin router with default middleware (logger, recovery)
	router := gin.Default()

	// Root route
	// Responds with a plain text message for the root URL "/".
	router.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "Hello, Docker!!! <3")
	})

	// Health check route
	// Used to check if the server is running. Returns a JSON object with a status.
	router.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status": "OK", // "OK" indicates the service is healthy.
		})
	})

	// Users route
	// Responds with a JSON object representing a user.
	router.GET("/users", func(c *gin.Context) {
		// Create a sample User object
		user := User{
			ID:   "1",     // Assign "1" as the user's ID
			Name: "Varun", // Assign "Varun" as the user's name
		}

		// Respond with the serialized User struct as JSON
		c.JSON(http.StatusOK, user)
	})

	// Get the HTTP server port from the environment variable
	// If not set, defaults to port 8080.
	httpPort := os.Getenv("PORT")
	if httpPort == "" {
		httpPort = "8080" // Default port is 8080
	}

	// Start the Gin server on the specified port
	// Example: If PORT=3000, the server will run on port 3000 (http://localhost:3000).
	router.Run(":" + httpPort)
}

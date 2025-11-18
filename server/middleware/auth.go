package middleware

import (
	"context"
	"net/http"
	"strings"

	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/auth"
	"github.com/gin-gonic/gin"
)

var FirebaseAuth *auth.Client

func InitFirebase() {
	app, err := firebase.NewApp(context.Background(), nil)
	if err != nil {
		panic("Failed to init Firebase: " + err.Error())
	}

	FirebaseAuth, err = app.Auth(context.Background())
	if err != nil {
		panic("Failed to init Firebase Auth: " + err.Error())
	}
}

func FirebaseAuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" || !strings.HasPrefix(authHeader, "Bearer ") {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Missing token"})
			return
		}

		idToken := strings.TrimPrefix(authHeader, "Bearer ")

		token, err := FirebaseAuth.VerifyIDToken(context.Background(), idToken)
		if err != nil {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Invalid token"})
			return
		}

		// Store user info in context
		c.Set("uid", token.UID)

		c.Next()
	}
}

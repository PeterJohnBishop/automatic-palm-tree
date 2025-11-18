package server

import (
	"automatic-palm-tree/server/middleware"

	"github.com/gin-gonic/gin"
)

func AddDProtectedRoutes(r *gin.Engine) {
	auth := r.Group("/api", middleware.FirebaseAuthMiddleware())
	{
		auth.POST("/google/route")
		auth.POST("/google/geocode")
		auth.POST("/google/reverse_geocode")
		auth.POST("/resend/email")
	}
}

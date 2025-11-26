package server

import (
	"automatic-palm-tree/server/middleware"

	"github.com/gin-gonic/gin"
	"github.com/resend/resend-go/v2"
)

func AddEmailRoutes(r *gin.Engine, e *resend.Client) {
	r.POST("/resend/email", SendEmailHandler(e))
}

func AddDProtectedRoutes(r *gin.Engine) {
	auth := r.Group("/api", middleware.FirebaseAuthMiddleware())
	{
		auth.POST("/google/route")
		auth.POST("/google/geocode")
		auth.POST("/google/reverse_geocode")
	}
}

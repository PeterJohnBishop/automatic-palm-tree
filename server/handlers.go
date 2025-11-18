package server

import (
	"github.com/gin-gonic/gin"
	"github.com/resend/resend-go/v2"
)

func SendURLViaResend(client *resend.Client) gin.HandlerFunc {
	return func(c *gin.Context) {
	}
}

func SendQRViaResend(client *resend.Client) gin.HandlerFunc {
	return func(c *gin.Context) {
	}
}

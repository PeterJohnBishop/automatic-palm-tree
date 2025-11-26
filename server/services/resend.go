package services

import (
	"fmt"
	"os"

	"github.com/resend/resend-go/v2"
)

type EmailRequest struct {
	Alias      string   `json:"alias"`
	Sender     string   `json:"sender"`
	Recipients []string `json:"recipients"`
	Subject    string   `json:"subject"`
	Html       string   `json:"html"`
}

func InitResendClient() *resend.Client {
	apiKey := os.Getenv("RESEND_API_KEY")
	client := resend.NewClient(apiKey)
	return client
}

func SendEmail(client *resend.Client, email EmailRequest) error {

	sender := fmt.Sprintf("%s <%s>", email.Alias, email.Sender)

	params := &resend.SendEmailRequest{
		From:    sender,
		To:      email.Recipients,
		Subject: email.Subject,
		Html:    email.Html,
	}

	sent, err := client.Emails.Send(params)
	if err != nil {
		panic(err)
	}
	fmt.Println(sent.Id)
	return nil
}

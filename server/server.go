package server

import (
	"automatic-palm-tree/server/services"
	"log"
	"sync"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/resend/resend-go/v2"
	"googlemaps.github.io/maps"
)

type AppServices struct {
	ResendClient     *resend.Client
	GoogleMapsClient *maps.Client
}

func ServeGin() {
	r := gin.Default()

	config := cors.Config{
		AllowOrigins:     []string{"http://localhost:*"}, // development only
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Authorization", "Content-Type"},
		AllowCredentials: true,
		MaxAge:           12 * time.Hour,
	}

	config.AllowOriginFunc = func(origin string) bool {
		return len(origin) > 0 && (origin == "http://localhost" ||
			(len(origin) > 17 && origin[:17] == "http://localhost:"))
	}

	r.Use(cors.New(config))

	var (
		appServices AppServices
		wg          sync.WaitGroup
		errChan     = make(chan error, 3)
	)

	wg.Add(2)

	go func() {
		defer wg.Done()
		appServices.ResendClient = services.InitResendClient()
		log.Println("Resending email")
	}()

	go func() {
		defer wg.Done()
		client, err := services.GoogleMaps()
		if err != nil {
			errChan <- err
			return
		}
		appServices.GoogleMapsClient = client
	}()

	wg.Wait()
	close(errChan)

	for err := range errChan {
		if err != nil {
			log.Fatalf("Initialization failed: %v", err)
		}
	}

	AddEmailRoutes(r, appServices.ResendClient)
	log.Println("Now serving Gin.")
	r.Run(":8080")
}

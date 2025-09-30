package main

import (
	"fmt"

	"github.com/gin-gonic/gin"
)

func main(){
	gin.SetMode(gin.ReleaseMode)
	r := gin.Default()

	r.GET("/", func(c *gin.Context){
		c.File("./public/index.html")
	})


	fmt.Println("Server running on http://127.0.0.1:8080")
	r.Run(":8080")
}
package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

const microserviceId = "Microservice B v1"
const microserviceCUrl = "http://microservice-c:80" // Adjust this URL based on your network configuration

func callMicroserviceC() string {
	resp, err := http.Get(microserviceCUrl)
	if err != nil {
		log.Printf("%s. Failed to call Microservice C: %s", microserviceId, err)
		return "Error calling Microservice C"
	}
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Printf("Failed to read response from Microservice C: %s", err)
		return "Error reading response from Microservice C"
	}

	return string(body)
}

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		responseC := callMicroserviceC()
		response := fmt.Sprintf("%s -> %s", microserviceId, responseC)
		fmt.Println(response)
		w.Write([]byte(response))
	})

	port := ":80"
	log.Printf("%s listening on port %s", microserviceId, port)
	if err := http.ListenAndServe(port, nil); err != nil {
		log.Fatal(err)
	}
}

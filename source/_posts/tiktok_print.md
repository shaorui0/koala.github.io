---
title: Tiktok print in Golang 
date: 2024-10-28 10:00:00
tags: [goroutine, golang]
---

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	// Create a channel for synchronization
	tikTokChan := make(chan bool)

	// Start the goroutine for "tik"
	go func() {
		for {
			fmt.Println("tik")
			time.Sleep(1 * time.Second) // Wait for 1 second
			tikTokChan <- true          // Signal the "tok" goroutine
			<-tikTokChan                // Wait for the "tok" goroutine
		}
	}()

	time.Sleep(1 * time.Second)
	// Start the goroutine for "tok"
	go func() {
		for {
			<-tikTokChan                // Wait for the "tik" goroutine
			fmt.Println("tok")
			time.Sleep(1 * time.Second) // Wait for 1 second
			tikTokChan <- true          // Signal the "tik" goroutine
		}
	}()

	// Use a channel to wait indefinitely or until the program is terminated
	forever := make(chan bool)
	<-forever
}
```
---
title: Goroutine Leaks
date: 2024-10-29 20:57:00
tags: [golang, goroutine]
---

## **1. Common Causes of Goroutine Leaks**

Here are the most frequent reasons why goroutines **fail to exit gracefully**, causing leaks:

### **1.1 Blocking on Channel Operations**

- If a goroutine **waits indefinitely** on a channel that no one is writing to, it will never terminate.

### Example:

```go
func leakExample() {
    ch := make(chan int) // No writer on the channel.
    go func() {
        <-ch // Blocks forever.
    }()
}
```

- **Fix**: Ensure the channel is **closed or written to** in all paths, or use **timeouts** with `select`.

---

### **1.2 Forgotten Goroutines in Background Tasks**

- Goroutines spawned without any way to stop them may continue running indefinitely.

### Example:

```go
func startLeakyTask() {
    go func() {
        for {
            // Do some work.
            time.Sleep(1 * time.Second) // Keeps running forever.
        }
    }()
}
```

- **Fix**: Use **context cancellation** to control when the goroutine should exit.

---

### **1.3 Deadlocks (Blocked on Mutexes or Channels)**

- If two or more goroutines **block waiting on each other** (e.g., through channels or mutexes), they may never exit.

### Example:

```go
var mu sync.Mutex

func deadlock() {
    mu.Lock()
    defer mu.Unlock()
    go func() {
        mu.Lock() // Will block forever.
        defer mu.Unlock()
    }()
}
```

- **Fix**: Ensure that **locks and channels** are always released properly to avoid deadlocks.

---

### **1.4 Missing Exit Conditions in `select` Statements**

- Goroutines using `select` without a proper **exit condition** may block forever.

### Example:

```go
func leakInSelect() {
    ch := make(chan int)
    go func() {
        select {
        case val := <-ch:
            fmt.Println(val)
        // No way to exit the select block.
        }
    }()
}
```

- **Fix**: Add **timeouts or cancellation signals** to ensure the goroutine exits when appropriate.

---

### **1.5 Waiting on Network or I/O Operations Indefinitely**

- If a goroutine is **waiting for a network call or I/O operation** that never completes, it can leak.

### Example:

```go
func leakyNetworkCall() {
    go func() {
        _, err := http.Get("http://example.com") // Network may hang.
        if err != nil {
            fmt.Println("Request failed")
        }
    }()
}
```

- **Fix**: Use **timeouts** for network or I/O operations.


## **2. How to Prevent Goroutine Leaks**

### **2.1 Use Context Cancellation**

Use **`context.Context`** to control when a goroutine should exit.

```go
func startTaskWithContext(ctx context.Context) {
    go func() {
        for {
            select {
            case <-ctx.Done():
                fmt.Println("Goroutine exiting")
                return
            default:
                // Do some work.
                time.Sleep(1 * time.Second)
            }
        }
    }()
}
```

---

### **2.2 Ensure Channels Are Closed Properly**

Always **close channels** to avoid blocking goroutines.

```go
ch := make(chan int)

go func() {
    for val := range ch {
        fmt.Println(val)
    }
}()

close(ch) // Ensure the channel is closed to prevent blocking.
```

---

### **2.3 Use `sync.WaitGroup` to Manage Goroutines**

Use a **`sync.WaitGroup`** to ensure all goroutines complete before the program exits.

```go
var wg sync.WaitGroup

func task() {
    defer wg.Done()
    // Do some work.
}

func main() {
    wg.Add(1)
    go task()
    wg.Wait() // Wait for all goroutines to finish.
}
```


## Reference

[Code snippets](https://github.com/shaorui0/recipes/channel)
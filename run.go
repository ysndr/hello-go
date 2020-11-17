package main

import (
  library "github.com/flox-examples/go-library"
  "fmt"
)

func Run() {
  fmt.Println(library.HelloString(library.Language))
  library.DoWork()
}

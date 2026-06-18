// SPDX-License-Identifier: GPL-2.0
// Author: xunicatt
// Project: railm (railapi)
// Copyright (c) 2026 xunicatt <contact.aniket.biswas@gmail.com>

package main

import (
	"fmt"
	"log"
	"os"
	"railapi/internals/app"
	"strconv"
)

const (
	RANK_THRESHOLD uint = 3
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}

	url := os.Getenv("TURSO_DATABASE_URL")
	if url == "" {
		log.Fatal("No 'TURSO_DATABASE_URL' env provided")
	}

	token := os.Getenv("TURSO_DATABASE_TOKEN")
	if token == "" {
		log.Fatal("No 'TURSO_DATABASE_TOKEN' env provided")
	}

	threshold := RANK_THRESHOLD
	rankThres := os.Getenv("RANK_THRESHOLD")
	if len(rankThres) > 0 {
		t, err := strconv.ParseUint(rankThres, 10, 16)
		if err != nil {
			log.Printf(
				"Ignoring RANK_THRESHOLD env variable due to parse error: %v",
				err.Error(),
			)
		} else {
			threshold = uint(t)
		}
	}

	url = fmt.Sprintf("%v?authToken=%v", url, token)

	a, err := app.NewApp(
		url,
		port,
		threshold,
	)
	if err != nil {
		log.Fatalf(
			"failed to initialize app: %v",
			err.Error(),
		)
	}
	defer a.Deinit()

	err = a.Run()
	if err != nil {
		log.Fatalf(
			"failed to run app: %v",
			err.Error(),
		)
	}
}

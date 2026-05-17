// SPDX-License-Identifier: GPL-2.0
// Author: xunicatt
// Project: railm (railapi) 
// Copyright (c) 2026 xunicatt <contact.aniket.biswas@gmail.com>

package main

import (
	"log"
	"railapi/internals/app"
)

const (
	DB_PATH = "database.db"
	PORT = 8080
	RANK_THRESHOLD = 3
)

func main() {
	a, err := app.NewApp(
		DB_PATH,
		PORT,
		RANK_THRESHOLD,
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

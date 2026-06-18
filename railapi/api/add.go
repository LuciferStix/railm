// SPDX-License-Identifier: GPL-2.0
// Author: xunicatt
// Project: railm (railapi) 
// Copyright (c) 2026 xunicatt <contact.aniket.biswas@gmail.com>

package api

import (
	"encoding/json"
	"io"
	"log"
	"net/http"
	"railapi/internals/db"
	"railapi/internals/models"
)

func (c *Context) AddRoute(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()

	body, err := io.ReadAll(r.Body)
	if err != nil {
		log.Printf(
			"failed to read body: %v",
			err.Error(),
		)
		serverError(w)
		return
	}

	route := models.Route{}
	err = json.Unmarshal(body, &route)
	if err != nil {
		badRequest(w)
		return
	}

	err = db.InsertRoute(c.sql, &route)
	if err != nil {
		log.Printf(
			"failed to insert 'models.Route': %v",
			err.Error(),
		)
		serverError(w)
		return
	}

	success(w)
}

func (c *Context) AddStation(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()

	body, err := io.ReadAll(r.Body)
	if err != nil {
		log.Printf(
			"failed to read body: %v",
			err.Error(),
		)
		serverError(w)
		return
	}

	station := models.Station{}
	err = json.Unmarshal(body, &station)
	if err != nil {
		badRequest(w)
		return
	}

	s, err := db.GetStation(c.sql, station.Id)
	if err != nil {
		log.Printf(
			"failed to get 'models.Station': %v",
			err.Error(),
		)
		serverError(w)
		return
	}

	if s != nil {
		failed(w, "station with same id already exists")
		return
	}

	err = db.InsertStation(c.sql, &station)
	if err != nil {
		log.Printf(
			"failed to insert 'models.Station': %v",
			err.Error(),
		)
		serverError(w)
		return
	}

	success(w)
}

func (c *Context) AddTrain(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()

	body, err := io.ReadAll(r.Body)
	if err != nil {
		log.Printf(
			"failed to read body: %v",
			err.Error(),
		)
		serverError(w)
		return
	}

	train := models.Train{}
	err = json.Unmarshal(body, &train)
	if err != nil {
		badRequest(w)
		return
	}

	t, err := db.GetTrain(c.sql, train.Number)
	if err != nil {
		log.Printf(
			"failed to get 'models.Train': %v",
			err.Error(),
		)
		serverError(w)
		return
	}

	if t != nil {
		failed(w, "train with same number already exists")
		return
	}

	err = db.InsertTrain(c.sql, &train)
	if err != nil {
		log.Printf(
			"failed to insert 'models.Train': %v",
			err.Error(),
		)
		serverError(w)
		return
	}

	success(w)
}

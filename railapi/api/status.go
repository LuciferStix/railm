package api

import (
	"encoding/json"
	"log"
	"net/http"
	"railapi/internals/db"
	"railapi/internals/models"
	"railapi/internals/rank"
)

func (c *Context) GetStatus(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()

	number := r.PathValue("number")
	status, err := db.GetStatus(c.sql, number)
	if err != nil {
		log.Printf(
			"failed to get train 'status': %v",
			err.Error(),
		)
		serverError(w)
		return
	}

	if status == nil {
		failed(w, "unknown")
		return
	}

	data, err := json.Marshal(status)
	if err != nil {
		log.Printf(
			"failed to encode 'status': %v",
			err.Error(),
		)
		serverError(w)
		return
	}

	w.Write(data)
}

func (c *Context) UpdateStatus(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()

	number := r.PathValue("number")
	station := r.PathValue("station")

	if rank.Check(number, station) {
		status, err := db.GetStatus(c.sql, number)
		if err != nil {
			log.Printf(
				"failed to get train status: %v",
				err.Error(),
			)
			serverError(w)
			return
		}

		status2 := &models.Status{
			Number: number,	
			Station: station,
			State: models.STATUS_RUNNING,
		}

		if status == nil {
			err = db.InsertStatus(c.sql, status2)
			if err != nil {
				log.Printf(
					"failed to get train status: %v",
					err.Error(),
				)
				serverError(w)
				return
			}

			success(w)
			return
		}

		if status.Station == status2.Station &&
		   status.State == status2.State {
			success(w)
			return
		}

		err = db.UpdateStatus(c.sql, status2)
		if err != nil {
			log.Printf(
				"failed to update train status: %v",
				err.Error(),
			)
			serverError(w)
			return
		}
	}

	success(w)
}

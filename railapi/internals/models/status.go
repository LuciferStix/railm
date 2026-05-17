package models

type TrainStatus uint8

const (
	STATUS_RUNNING TrainStatus = iota
	STATUS_ARRIVED
	STATUS_LEFT
)

type Status struct {
	Number string `json:"number"`
	Station string `json:"station"`
	State TrainStatus `json:"state"`
}

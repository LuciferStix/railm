package rank

import (
	"sync"
)

type Rank map[string]uint

var (
	threshold uint
	ranks Rank
	mut sync.Mutex
)

func Init(t uint) {
	threshold = t 
	ranks = make(Rank)
}

func Check(number, station string) bool {
	mut.Lock()
	defer mut.Unlock()

	id := number + station

	_, ok := ranks[id]
	if !ok {
		ranks[id] = 1
		return false
	}

	ranks[id]++
	id2, rank := getWinner()

	return id2 == id && rank >= threshold
}

func getWinner() (string, uint) {
	var id string
	var rank uint

	for k, v := range ranks {
		if v >= rank {
			id = k
			rank = v
		}
	}

	return id, rank
}


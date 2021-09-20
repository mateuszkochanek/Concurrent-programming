package main

import "sync"

type Node struct{
	index          int
	routingEntries []*RoutingEntry
	neighbours     []int
	mutex          sync.Mutex
}

type RoutingEntry struct{ // RoutingEntry{nexthop: 0, cost: 0, changed: true}
	nexthop int
	cost int
	changed bool
}

func NewRatingEntry(nexthop int, cost int, changed bool) *RoutingEntry {
	return &RoutingEntry{nexthop: nexthop, cost: cost, changed: changed}
}


type Edge struct{
	beginNode int
	endNode int
}

type Package struct{
	neighbourIndex int
	nodeIndexes []int
	costs []int
}


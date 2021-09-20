package main

import "sync"

type Node struct{
	index          int
	routingEntries []*RoutingEntry
	neighbours     []int
	hosts		   []int
    queue		   []StandardPackage
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

type RoutingPackage struct{
	neighbourIndex int
	nodeIndexes []int
	costs []int
}

type StandardPackage struct{
	senderAdress          [2]int
	receiverAdress        [2]int
	visitedRouters     []int
}


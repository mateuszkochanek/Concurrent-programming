package main

import (
	"flag"
	"fmt"
	"math/rand"
	"sync"
	"time"
)

func main() {
	nodeCount := flag.Int("n", 10, "graph node number")
	shortcutCount := flag.Int("d", 3, "shortcuts number")
	hostCount := flag.Int("h", 2, "hosts near router")
	flag.Parse()


	var nodes = make([]Node, *nodeCount)
	var edges = make([]Edge, *nodeCount-1 + *shortcutCount)
	var routingInputChannels = make([]chan RoutingPackage, *nodeCount)
	var standardInputChannels = make([]chan StandardPackage, *nodeCount)
	var hostInputChannels = make([]chan StandardPackage, *nodeCount * *hostCount)
	var messageChannel = make(chan string, 10)

	prepareData(&nodes, *nodeCount, &edges, *shortcutCount, *hostCount, &routingInputChannels, &standardInputChannels, &hostInputChannels)
	printGraph(nodes)

	var wg sync.WaitGroup
	wg.Add(1)
	go messageAggregate(messageChannel, &wg)
	for i := 0; i < *nodeCount; i++ {
		wg.Add(1)
		go routingReceiver(&nodes[i], &routingInputChannels, messageChannel, &wg)
		wg.Add(1)
		go routingSender(&nodes[i], &routingInputChannels ,messageChannel, &wg)
		wg.Add(1)
		go standardReceiver(&nodes[i], &standardInputChannels, &wg)
		wg.Add(1)
		go standardSender(&nodes[i], &standardInputChannels, &hostInputChannels, messageChannel, &wg)
		for j := 0; j < *hostCount; j++ {
			go host(&nodes[i], j, *hostCount, &standardInputChannels, &hostInputChannels, messageChannel, &wg)
		}
	}
	wg.Wait()
}

func prepareData(
		nodes *[]Node,
		nodeCount int,
		edges *[]Edge,
		shortcutCount int,
		hostCount int,
		routingInputChannels *[]chan RoutingPackage,
		standardInputChannels *[]chan StandardPackage,
		hostInputChannels *[]chan StandardPackage) {
	var hostIndex = 0
	for i := 0; i < nodeCount-1; i++ {
		(*nodes)[i] = Node{index: i, routingEntries: make([]*RoutingEntry, nodeCount), hosts: make([]int, hostCount), queue: make([]StandardPackage, 0)}
		(*edges)[i] = Edge{beginNode: i, endNode: i + 1}
		(*routingInputChannels)[i] = make(chan RoutingPackage)
		(*standardInputChannels)[i] = make(chan StandardPackage)
		for j := 0; j < hostCount; j++ {
			(*hostInputChannels)[hostIndex] = make(chan StandardPackage)
			(*nodes)[i].hosts[j] = hostIndex
			hostIndex += 1
		}
	}
	(*nodes)[nodeCount-1] = Node{index: nodeCount - 1, routingEntries: make([]*RoutingEntry, nodeCount), hosts: make([]int, hostCount), queue: make([]StandardPackage, 0)}
	(*routingInputChannels)[nodeCount-1] = make(chan RoutingPackage)
	(*standardInputChannels)[nodeCount-1] = make(chan StandardPackage)
	for j := 0; j < hostCount; j++ {
		(*nodes)[nodeCount-1].hosts[j] = hostIndex
		hostIndex += 1
	}

	// creating shortcut channels
	rand.Seed(time.Now().UnixNano())
	for i := nodeCount - 1; i < nodeCount-1+shortcutCount; i++ {
		begin := rand.Intn(nodeCount - 1)                 // random number between 0 and *nodeCount-2, so if node Count is 7, 6 is outlet, we can pick 5
		end := rand.Intn(nodeCount-(begin+1)) + begin + 1 // random number between begin+1 and outlet
		(*edges)[i] = Edge{beginNode: begin, endNode: end}
	}
	// extracting neighbours from eges table
	for i := 0; i < len(*edges); i++ {
		(*nodes)[(*edges)[i].beginNode].neighbours = append((*nodes)[(*edges)[i].beginNode].neighbours, (*edges)[i].endNode)
		(*nodes)[(*edges)[i].endNode].neighbours = append((*nodes)[(*edges)[i].endNode].neighbours, (*edges)[i].beginNode)
	}

	var neighbourIndex = 0
	var nextHop = 0
	var cost = 0
	for i := 0; i < nodeCount; i++ {
		for j := 0; j < len((*nodes)[i].neighbours); j++ {
			neighbourIndex = (*nodes)[i].neighbours[j]
			(*nodes)[i].routingEntries[neighbourIndex] = NewRatingEntry(neighbourIndex, 1, true)
		}
		for j := 0; j < nodeCount; j++ {
			if((*nodes)[i].routingEntries[j] == nil){
				if(i <= j){
					nextHop = i+1
					cost = -(i-j)
				} else {
					nextHop = i-1
					cost = i-j
				}
				(*nodes)[i].routingEntries[j] = NewRatingEntry(nextHop, cost, true)
			}
		}
	}
}

func printGraph(nodes []Node){
	for i := 0; i < len(nodes); i++ {
		fmt.Print(nodes[i].index, "-->")
		for j := 0; j < len(nodes[i].neighbours); j++ {
			fmt.Print(nodes[i].neighbours[j], " ")
		}
		fmt.Println(" --> hosts: ", len(nodes[i].hosts))
	}
	fmt.Println("_________________________")
}
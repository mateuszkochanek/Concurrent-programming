package main

import (
	"fmt"
	"math/rand"
	"strconv"
	"strings"
	"sync"
	"time"
)

func sender(node *Node, inputChannels *[]chan Package, messageChannel chan string, wg *sync.WaitGroup){
	defer wg.Done()
	for {
		sleepTime := rand.Intn(10)
		time.Sleep(time.Duration(sleepTime) * time.Second)
		pack := Package{neighbourIndex: node.index,nodeIndexes: nil, costs:nil,}
		node.mutex.Lock()
		for i := 0; i < len(node.routingEntries); i++ {
			if node.routingEntries[i].changed {
				pack.nodeIndexes = append(pack.nodeIndexes, i)
				pack.costs = append(pack.costs, node.routingEntries[i].cost)
				node.routingEntries[i].changed = false
			}
		}
		node.mutex.Unlock()
		if pack.nodeIndexes != nil && len(pack.nodeIndexes) > 0{
			var sb strings.Builder
			for i := 0; i < len(node.neighbours); i++ {
				sb.WriteString(strconv.Itoa(node.neighbours[i]) + " ")
			}
			messageChannel <- "Pakiet został wysłany z " + strconv.Itoa(node.index) + " do " + sb.String()
			sb.Reset()
			for i := 0; i < len(node.neighbours); i++ {
				(*inputChannels)[node.neighbours[i]] <- pack
			}
		}
	}
}

func receiver(node *Node, inputChannels *[]chan Package, messageChannel chan string, wg *sync.WaitGroup){
	defer wg.Done()
	var pack Package
	for {
		pack = <-(*inputChannels)[node.index]
		messageChannel <- "Pakiet został odebrany w " + strconv.Itoa(node.index) + " z " + strconv.Itoa(pack.neighbourIndex)
		node.mutex.Lock()
		for i := 0; i < len(pack.nodeIndexes); i++ {
			newcost := pack.costs[i]+1
			if newcost < node.routingEntries[pack.nodeIndexes[i]].cost {
				messageChannel <- "Routing Table w: " + strconv.Itoa(node.index) +
					", dla: " + strconv.Itoa(pack.nodeIndexes[i]) +
					", stary koszt: " + strconv.Itoa(node.routingEntries[pack.nodeIndexes[i]].cost) +
					", nowy koszt: " + strconv.Itoa(newcost) +
					", stary hop: " + strconv.Itoa(node.routingEntries[pack.nodeIndexes[i]].nexthop) +
					", nowyhop: " + strconv.Itoa(pack.neighbourIndex)
				node.routingEntries[pack.nodeIndexes[i]].cost = newcost
				node.routingEntries[pack.nodeIndexes[i]].nexthop = pack.neighbourIndex
				node.routingEntries[pack.nodeIndexes[i]].changed = true
			}
		}
		node.mutex.Unlock()
	}
}

func messageAggregate(messageChannel chan string, wg *sync.WaitGroup){
	defer wg.Done()
	notTimeout := true
	for notTimeout {
		select {
		case msg := <-messageChannel:
			fmt.Println(msg)
		case <-time.After(20 * time.Second):
			notTimeout = false
		}
	}
}
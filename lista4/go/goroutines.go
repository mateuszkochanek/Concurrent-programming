package main

import (
	"fmt"
	"math/rand"
	"strconv"
	"strings"
	"sync"
	"time"
)

func routingSender(node *Node, inputChannels *[]chan RoutingPackage, messageChannel chan string, wg *sync.WaitGroup){
	defer wg.Done()
	time.Sleep(time.Duration(15) * time.Second)
	for {
		sleepTime := rand.Intn(10)
		time.Sleep(time.Duration(sleepTime) * time.Second)
		pack := RoutingPackage{neighbourIndex: node.index,nodeIndexes: nil, costs:nil,}
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
			sb.Reset()
			for i := 0; i < len(node.neighbours); i++ {
				(*inputChannels)[node.neighbours[i]] <- pack
			}
		}
	}
}

func routingReceiver(node *Node, inputChannels *[]chan RoutingPackage, messageChannel chan string, wg *sync.WaitGroup){
	defer wg.Done()
	time.Sleep(time.Duration(15) * time.Second)
	var pack RoutingPackage
	for {
		pack = <-(*inputChannels)[node.index]
		node.mutex.Lock()
		for i := 0; i < len(pack.nodeIndexes); i++ {
			newcost := pack.costs[i]+1
			if newcost < node.routingEntries[pack.nodeIndexes[i]].cost {
				messageChannel <- "ROUTING: Routing Table w: " + strconv.Itoa(node.index) +
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

func host(routerNode *Node, hostIndex int, hostCount int, outputChannels *[]chan StandardPackage, hostInputChannels *[]chan StandardPackage,
	messageChannel chan string, wg *sync.WaitGroup){
	routerAdress := routerNode.index
	for routerAdress == routerNode.index {
		routerAdress = rand.Intn(len(*outputChannels))
	}
	hostAdress := rand.Intn(hostCount)
	pack := StandardPackage{senderAdress: [2]int{routerNode.index, hostIndex}, receiverAdress: [2]int{routerAdress, hostAdress}, visitedRouters:nil}
	(*outputChannels)[routerNode.index] <- pack
	for {
		pack = <- (*hostInputChannels)[routerNode.hosts[hostIndex]]
		if pack.senderAdress[0] == 0 && pack.senderAdress[1] == 0 && pack.receiverAdress[0] == 0 && pack.receiverAdress[1] == 0{
			messageChannel <- strconv.Itoa(routerNode.index)
		}
		var sb strings.Builder
		for i := 0; i < len(pack.visitedRouters); i++ {
			sb.WriteString(strconv.Itoa(pack.visitedRouters[i]) + " ")
		}
		messageChannel <- "HOSTS: Odebrano! Nadawca: " + strconv.Itoa(pack.senderAdress[0]) + strconv.Itoa(pack.senderAdress[1]) +
			" do " + "Odbiorca: " + strconv.Itoa(pack.receiverAdress[0]) + strconv.Itoa(pack.receiverAdress[1]) + " Przez: " + sb.String()
		sb.Reset()

		sleepTime := rand.Intn(10)
		time.Sleep(time.Duration(sleepTime) * time.Second)

		sendPack := StandardPackage{
			senderAdress: [2]int{routerNode.index, hostIndex},
			receiverAdress: [2]int{pack.senderAdress[0], pack.senderAdress[1]},
			visitedRouters:nil}
		(*outputChannels)[routerNode.index] <- sendPack
	}
}

func standardSender(node *Node, inputChannels *[]chan StandardPackage, hostInputChannels *[]chan StandardPackage, messageChannel chan string, wg *sync.WaitGroup){
	defer wg.Done()
	for {
		if len(node.queue) != 0 {
			time.Sleep(time.Duration(1) * time.Second)
			pack := node.queue[0]
			node.queue = node.queue[1:]
			if pack.receiverAdress[0] == node.index && pack.visitedRouters != nil {
				pack.visitedRouters = append(pack.visitedRouters, node.index)
				(*hostInputChannels)[node.hosts[pack.receiverAdress[1]]] <- pack
			} else {
				pack.visitedRouters = append(pack.visitedRouters, node.index)
				nextRouter := node.routingEntries[pack.receiverAdress[0]].nexthop
				(*inputChannels)[nextRouter] <- pack
			}
		}
	}
}

func standardReceiver(node *Node, inputChannels *[]chan StandardPackage, wg *sync.WaitGroup){
	defer wg.Done()
	var pack StandardPackage
	for {
		pack = <-(*inputChannels)[node.index]
		node.queue = append(node.queue, pack)
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
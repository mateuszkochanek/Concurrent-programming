package main

import (
	"flag"
	"fmt"
	"math/rand"
	"sync"
	"time"
)

func main() {
	nodeCount := flag.Int("n", 2, "graph node number")
	shortcutCount := flag.Int("d", 0, "shortcuts number")
	msgCount := flag.Int("k", 5, "number of messages")
	flag.Parse()

	var info = make([]string, 0)
	var nodes = make([]Node, *nodeCount)
	var channels = make([]Channel, *nodeCount-1 + *shortcutCount)
	var packets = make([]Package, *msgCount)
	var messageChannel = make(chan string, 10)

	prepareData(msgCount, &packets, nodeCount, &nodes, shortcutCount, &channels)
	printGraph(nodes)

	// run goroutines
	var wg sync.WaitGroup
	wg.Add(1)
	go messageAggregate(messageChannel, &info, &wg)
	wg.Add(1)
	go source(&nodes[0],&packets,messageChannel, &wg)
	for i := 1; i < *nodeCount-1; i++{
		wg.Add(1)
		go junction(&nodes[i],messageChannel, &wg)
	}
	wg.Add(1)
	go outlet(&nodes[*nodeCount-1],messageChannel, &wg)
	wg.Wait()
	printResults(nodes, packets, info)
}

func printResults(nodes []Node, packets []Package, info []string) {
	for i := 0; i < len(info); i++ {
		fmt.Println(info[i])
	}
	fmt.Println("_________________________")
	fmt.Println("Node : packages")
	for i := 0; i < len(nodes); i++ {
		fmt.Print(nodes[i].index, " : ")
		for j := 0; j < len(nodes[i].serverdPackages); j++ {
			fmt.Print(nodes[i].serverdPackages[j], " ")
		}
		fmt.Println()
	}
	fmt.Println("_________________________")

	fmt.Println("Package : nodes travelled")
	for i := 0; i < len(packets); i++ {
		fmt.Print(packets[i].index, " : ")
		for j := 0; j < len(packets[i].visitedNodes); j++ {
			fmt.Print(packets[i].visitedNodes[j], " ")
		}
		fmt.Println()
	}
	fmt.Println("_________________________")
}


func prepareData(msgCount *int, packets *[]Package, nodeCount *int, nodes *[]Node, shortcutCount *int, channels *[]Channel) {
	// creating Packages to send
	for i := 0; i < *msgCount; i++ {
		(*packets)[i] = Package{index: i}
	}
	// creating nodes and basic channels
	for i := 0; i < *nodeCount-1; i++ {
		(*nodes)[i] = Node{index: i}
		(*channels)[i] = Channel{pipe: make(chan *Package), beginNode: i, endNode: i + 1}
	}
	(*nodes)[*nodeCount-1] = Node{index: *nodeCount - 1}
	// creating shortcut channels
	rand.Seed(time.Now().UnixNano())
	for i := *nodeCount - 1; i < *nodeCount-1+*shortcutCount; i++ {
		begin := rand.Intn(*nodeCount - 1)                 // random number between 0 and *nodeCount-2, so if node Count is 7, 6 is outlet, we can pick 5
		end := rand.Intn(*nodeCount-(begin+1)) + begin + 1 // random number between begin+1 and outlet
		(*channels)[i] = Channel{pipe: make(chan *Package), beginNode: begin, endNode: end}
	}
	// connecting channels to nodes
	for i := 0; i < len(*channels); i++ {
		(*nodes)[(*channels)[i].beginNode].outputPipes = append((*nodes)[(*channels)[i].beginNode].outputPipes, &(*channels)[i])
		(*nodes)[(*channels)[i].endNode].inputPipes = append((*nodes)[(*channels)[i].endNode].inputPipes, &(*channels)[i])
	}
}

func printGraph(nodes []Node){
	for i := 0; i < len(nodes); i++ {
		fmt.Print(nodes[i].index, "-->")
		for j := 0; j < len(nodes[i].outputPipes); j++ {
			fmt.Print(nodes[i].outputPipes[j].endNode, " ")
		}
		fmt.Println()
	}
	fmt.Println("_________________________")
}
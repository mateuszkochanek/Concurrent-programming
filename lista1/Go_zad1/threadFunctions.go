package main

import (
	"fmt"
	"math/rand"
	"reflect"
	"strconv"
	"sync"
	"time"
)

func source(node *Node, messages *[]Package, messageChannel chan string, wg *sync.WaitGroup){
	defer wg.Done()
	outputChannelsCount := len(node.outputPipes)
	var cond int
	var sleepTime int
	for i := 0; i < len(*messages); i++ {
		(*messages)[i].visitedNodes = append((*messages)[i].visitedNodes, 0)
		node.serverdPackages = append(node.serverdPackages, (*messages)[i].index)
		messageChannel <- "Pakiet " + strconv.Itoa((*messages)[i].index) + " jest w wierzchołku 0"

		cond = rand.Intn(outputChannelsCount)
		node.outputPipes[cond].pipe <- &(*messages)[i]

		sleepTime = rand.Intn(5)
		time.Sleep(time.Duration(sleepTime) * time.Second)
	}
}

func junction(node *Node, messageChannel chan string, wg *sync.WaitGroup){
	defer wg.Done()
	outputChannelsCount := len(node.outputPipes)
	tc := time.After(100 * time.Second)
	timeoutId := len(node.inputPipes)

	cases := make([]reflect.SelectCase, len(node.inputPipes))
	for i, c := range node.inputPipes {
		cases[i] = reflect.SelectCase{
			Dir:  reflect.SelectRecv,
			Chan: reflect.ValueOf(c.pipe),
		}
	}
	cases = append(cases,reflect.SelectCase{Dir: reflect.SelectRecv, Chan: reflect.ValueOf(tc)})

	var msg *Package
	for {
		sleepTime := rand.Intn(5)
		time.Sleep(time.Duration(sleepTime) * time.Second)
		i, v, ok := reflect.Select(cases)
		if i == timeoutId && ok {
			break
		}

		msg = v.Interface().(*Package)
		msg.visitedNodes = append(msg.visitedNodes, node.index)
		node.serverdPackages = append(node.serverdPackages, msg.index)
		messageChannel <- "Pakiet " + strconv.Itoa(msg.index) + " jest w wierzchołku " + strconv.Itoa(node.index)

		cond := rand.Intn(outputChannelsCount)
		node.outputPipes[cond].pipe <- msg
	}
}

func outlet(node *Node, messageChannel chan string, wg *sync.WaitGroup){
	defer wg.Done()
	tc := time.After(100 * time.Second)
	timeoutId := len(node.inputPipes)
	var sleepTime int

	cases := make([]reflect.SelectCase, len(node.inputPipes))
	for i, c := range node.inputPipes {
		cases[i] = reflect.SelectCase{
			Dir:  reflect.SelectRecv,
			Chan: reflect.ValueOf(c.pipe),
		}
	}
	cases = append(cases,reflect.SelectCase{Dir: reflect.SelectRecv, Chan: reflect.ValueOf(tc)})

	var msg *Package
	for {
		sleepTime = rand.Intn(5)
		time.Sleep(time.Duration(sleepTime) * time.Second)
		i, v, _ := reflect.Select(cases)
		if i == timeoutId {
			break
		}

		msg = v.Interface().(*Package)
		msg.visitedNodes = append(msg.visitedNodes, node.index)
		node.serverdPackages = append(node.serverdPackages, msg.index)
		messageChannel <- "Pakiet " + strconv.Itoa(msg.index) + " został odebrany"
	}
}

func messageAggregate(messageChannel chan string, info *[]string, wg *sync.WaitGroup){
	defer wg.Done()
	notTimeout := true
	for notTimeout {
		select {
		case msg := <-messageChannel:
			fmt.Println(msg)
		case <-time.After(5 * time.Second):
			notTimeout = false
		}
	}
}
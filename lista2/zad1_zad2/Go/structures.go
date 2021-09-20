package main

type Node struct{
	index int
	serverdPackages []int
	hunterPipe chan bool
	inputPipes []*Channel
	outputPipes []*Channel
}

type Channel struct{ // Channel{pipe: channels[i], beginNode: 0, endNode: 1)}
	pipe chan *Package
	beginNode int
	endNode int
}

type Package struct{ // Package{index: 0, visitedNodes: make([]int, 0)}
	index int
	visitedNodes []int
	timeToLive int
}

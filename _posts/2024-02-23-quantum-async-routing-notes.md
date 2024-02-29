---
title: "Notes on two papers on routing in quantum internet"
categories: [quantum computing, routing, quantum routing] 
tags: [quantum, routing, theory, notes]
classes: wide
---

# Overview

Goal of this post is to describe [Asynchronous Entanglement Routing for the Quantum Internet](https://arxiv.org/abs/2312.14300) with focus on the results _and_ open problems. To provide full picture I will compare it with approach described in [Distributed Routing in a Quantum Internet](https://arxiv.org/abs/1907.11630). The post will be structured in a following way -- in the first section I will describe (on a high level) problem that is being addressed in the main article, in the second section we will go through foundational blocks and context required to understand the paper, in third section I will describe main contribution from the paper, fourth section will contain comparison with the approach from the second paper, fifth section will contain open problems as described in the paper.

## Why this particular structure?

I believe this approach facilitate better understand - both for reader and for me as a writer of this notes. Having clear picture of _what particular problem_ authors are trying to solve is critical to understanding the solution and somewhat appreciate it. Then, before diving into main contribution (which is a solution to a stated problem), we need to ensure that we are standing on solid foundation. Usually parts like ''Section II'' are bit boring, yet they are helpful to fully grasp solution described in ''Section III''.

# Section I: Problem definition

Given set of ''quantum devices'' (capable of entanglement generation and swapping) connected via network capable of qubit transmission -- how we can _efficiently_ create entanglement between any two devices in the network?

## Context

In the article it is Section 3. ''Quantum network'' is a network -- mathematically represented by a graph -- which leverages some quantum specific properties, in this case [entanglement](https://en.wikipedia.org/wiki/Quantum_entanglement). Graph $G(V, E)$ consists of a set of _vertices_ $V$ (nodes, ''quantum devices'') and a set of _edges_ $E$ (fibers, connection between nodes). Entanglement gives us possibility to create also _virtual edges_ between particular vertices. Let us focus on that - what is a virtual edge? We will consider simple graph consisting of three nodes - $A, B, C$. The solid lines represents physical link between two devices.

```mermaid
graph LR;
    A---B;
    B---C;
```  

Now, each node represents quantum device. Each device can communicate _qubits_ to its neighbour (so another node that is directly connected). Such pair of nodes can create entanglement between their states. In our graph we (in theory) entangle states of $A, B$ and $B, C$. We will represent entanglement between nodes with dotted line.
```mermaid
graph LR;
    A---B;
    B---C;
    A-.-B;
    B-.-C;

``` 

By using technique called _entanglement swapping_ we can "sacrifice" entanglements between $A, B$ and $B, C$ to create entanglement between $A, C$!

```mermaid
graph LR;
    A---B;
    B---C;
    A-.-C;
```

What's the benefit? Now pair $A, C$ is entangled and they can leverage ''quantum effects'' - for example in quantum key distribution. Of course as networks grow larger, keeping in mind intermittent and delicate nature of entanglement between nodes, the question of how to create entanglement between any two particular nodes in a network gets harder and harder. Hence, we get our original problem statement.

# Section II: Prerequisites and problem statement refinement

Before we can fully jump into contribution of the paper we need to understand what _building blocks_ are leveraged in proposed approach. First we will describe processes or ''functions'', then we will describe components that leverage these.

## Entanglement generation between adjacent nodes

Most basic capability is to entangle qubits between two adjacent nodes in a network. Simplest way would be to generate [EPR pair](https://en.wikipedia.org/wiki/Bell_state#Creating_Bell_states_via_quantum_circuits) between in node $A$ and then send one of the entangled qubits to connected (via physical link) node $B$.

## Entanglement swapping

With the information above we can generate entanglement between physically connected nodes, but what about situation where we have intermediary node? 

```mermaid
graph LR;
  subgraph PRE[from this]
     A-.-B
     A---B
     B-.-C
     B---C
   end
   subgraph POST[to this]
     D[A]---E[B]
     E---F[C]
     D-.-F
   end

PRE --> POST
```

There is existing technique called [entanglement swapping](https://en.wikipedia.org/wiki/Quantum_teleportation#Entanglement_swapping), which allows us to do exactly that. In linked example there is a 
algorithmic description of the process, whereas in the paper you can find circuit-level realisation.

## Fidelity

Fidelity between two quantum states can be intuited as "similarity" between those two states. Higher fidelity between two states means that two states are more similar to each other. In case of pure states fidelity can be thought as angle between two vector states.

## Entanglement purification

This is a procedure that takes a number of partially entangled states and produces a smaller number (not rarely - just one) state with higher measure of entanglement.

## Global and local (node-level) knowledge of direct links

First - what is a direct link? Given two nodes in the network, "direct link" is an edge realised by entanglement between those two nodes.
The "global knowledge" is information about states of all direct links between all nodes in the network. It completely describes entanglement between all nodes. In a perfect (yet somewhat imaginary) world every node would have access to that global knowledge, but in a distributed scenario - the state information in any node might be outdated hence it has a "local knowledge". If you are coming from CS perspective - this simply means [eventual consistency](https://en.wikipedia.org/wiki/Eventual_consistency)

## Link capacity

This is a number representing how many entangled qubit pairs can be generated between two nodes. If we would have ''prefect'' technology it would simply be equal to number of pairs between two nodes, but physical realisation within current state of the art implies that  -- if we want to achieve specific fidelity with EPR pair -- we might need multiple entangled pairs and leverage purification techniques.

## Synchronous and asynchronous

Title of the article contains "asynchronous", hence it would be good to explain what does it mean. From a programmer perspective (or _thread_ perspective) synchronous means that you wait for task to finish before working on next task. When you execute some task asynchronously - you can delegate the work to another ''thread'' (or other entity of similar type) and work on something else between you get the result back.

Overall, this is a very deep ocean, especially in world of algorithm analysis -- so let us try to narrow down what it does mean in context of the paper. It simply means that nodes in the network can perform operations (for example - creating entanglement) simultaneously, without any "global" coordination. 

## Refined problem statement

With all those information, now we will try to refine the problem statement, make it more mathematically precise.

# Section III: Main contribution

# Section IV: Comparison with ''Distributed Routing in a Quantum Internet''

# Section V: Open problems, future work and potential direction
	

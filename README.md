# Graph Algorithm Project in Elixir

## Overview

This project implements fundamental graph algorithms in Elixir, focusing on graph generation, shortest path computation using Dijkstra's algorithm, and graph metrics like eccentricity, radius, and diameter.

## Modules

### 1. Graph Generator (`graph/lib/graph.ex`)

This module provides functions to create and manipulate graphs with weighted edges.

#### Features:

- `extend_graph/0`: Defines a sample graph with weighted edges.
- `make_graph/2`: Generates a random directed graph with a specified number of nodes and edges.
  - Ensures connectivity using a spanning tree.
  - Assigns random weights to edges.
  - Returns an adjacency list representation.

### 2. Dijkstra's Algorithm (`graph/lib/dijkstra.ex`)

This module implements **Dijkstra's Algorithm** to compute the shortest path between two nodes in a weighted graph.

#### Features:

- `shortest_path/3`: Computes the shortest path between a given start and target node.
- Utilizes a priority queue for efficient pathfinding.
- Returns the shortest path as a list of nodes or an error if no path exists.

### 3. Graph Metrics (`graph/lib/graph_metrics.ex`)

This module computes key graph metrics related to distances between nodes.

#### Features:

- `eccentricity/2`: Determines the longest shortest-path distance from a given node.
- `radius/1`: Computes the smallest eccentricity among all nodes.
- `diameter/1`: Computes the largest eccentricity among all nodes.

## Testing

Unit tests are implemented using **ExUnit** (`graph/test/graph_test.exs`).

#### Features:

- Validates graph generation correctness.
- Tests shortest path calculations using different graph structures.
- Verifies eccentricity, radius, and diameter computations.

## Getting Started

### Installation

Ensure you have Elixir installed, then clone the repository and navigate to the project directory:

```sh
mix deps.get  # Install dependencies
```

### Running Tests

Run the ExUnit tests to verify correctness:

```sh
mix test
```

## Future Enhancements

- Implement alternative shortest path algorithms (e.g., A\* search).
- Support for undirected and weighted graphs.
- Visualization tools for generated graphs.

## License

This project is open-source and available under the MIT License.

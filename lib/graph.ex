defmodule GraphGenerator do
  @moduledoc """
  Graph generation module with weighted edges.
  """

  @doc """
  1. Extend the graph definition to include a weight between graph edges
  """
  def extend_graph do
    %{
      :node_1 => [{:node_2, 1}, {:node_3, 2}],
      :node_2 => [{:node_4, 4}],
      :node_3 => [{:node_4, 2}],
      :node_4 => []
    }
  end

  @doc """
  Generates a random simple directed graph.

  ## Parameters:
    - `n`: Number of nodes.
    - `s`: Number of directed edges (must be between `n-1` and `n*(n-1)`).

  ## Returns:
    - A graph represented as an adjacency list with weights.
  """
  def make_graph(n, s) when s >= n - 1 and s <= n * (n - 1) do
    # Generate node names like :node_1, :node_2
    nodes = Enum.map(1..n, &:"node_#{&1}")

    # Step 1: Ensure connectivity with a spanning tree (linear chain)
    required_edges = Enum.zip(nodes, tl(nodes))

    # Step 2: Generate all possible edges and ensure no duplicate self-loops
    all_edges =
      for a <- nodes, b <- nodes, a != b, do: {a, b}

    # Step 3: Shuffle and select additional edges to reach `s` total edges
    additional_edges =
      Enum.take(Enum.shuffle(all_edges -- required_edges), s - length(required_edges))

    # Step 4: Assign random weights (1 to 10) and build the final edge list
    final_edges = required_edges ++ additional_edges
    weighted_edges = Enum.map(final_edges, fn {from, to} -> {from, {to, :rand.uniform(10)}} end)

    # Step 5: Convert to adjacency list format, ensuring all nodes exist
    Enum.reduce(nodes, %{}, fn node, acc ->
      edges =
        Enum.filter(weighted_edges, fn {from, _} -> from == node end)
        |> Enum.map(fn {_, edge} -> edge end)

      Map.put(acc, node, edges)
    end)
  end
end

ExUnit.start()

defmodule GraphTest do
  use ExUnit.Case
  alias GraphGenerator
  alias Dijkstra
  alias GraphMetrics

  @tag :graph
  test "Graph generation produces expected number of nodes and edges" do
    n = 5
    s = 7
    graph = GraphGenerator.make_graph(n, s)

    assert length(Map.keys(graph)) == n
    assert Enum.reduce(graph, 0, fn {_k, v}, acc -> acc + length(v) end) == s
  end

  @tag :dijkstra
  test "Dijkstra finds shortest path in a simple graph" do
    graph = %{
      :a => [{:b, 1}, {:c, 2}],
      :b => [{:d, 4}],
      :c => [{:d, 2}],
      :d => []
    }

    assert Dijkstra.shortest_path(graph, :a, :d) == [:a, :c, :d]
    assert Dijkstra.shortest_path(graph, :b, :d) == [:b, :d]
    assert Dijkstra.shortest_path(graph, :d, :a) == {:error, "No path found"}
  end

  defmodule DijkstraTest do
    use ExUnit.Case
    doctest Dijkstra

    test "Dijkstra finds shortest path in a simple graph" do
      graph = %{
        :a => [{:b, 1}, {:c, 2}],
        :b => [{:d, 4}],
        :c => [{:d, 2}],
        :d => []
      }

      assert Dijkstra.shortest_path(graph, :a, :d) == [:a, :c, :d]
      assert Dijkstra.shortest_path(graph, :b, :d) == [:b, :d]
      assert Dijkstra.shortest_path(graph, :d, :a) == {:error, "No path found"}
    end

    test "Dijkstra handles a graph with multiple paths" do
      graph = %{
        :a => [{:b, 1}, {:c, 5}],
        :b => [{:c, 1}, {:d, 4}],
        :c => [{:d, 1}],
        :d => []
      }

      # Shortest path should be [:a, :b, :c, :d] (total cost: 1+1+1=3)
      assert Dijkstra.shortest_path(graph, :a, :d) == [:a, :b, :c, :d]

      # Shortest path should be [:a, :b, :c] (total cost: 1+1=2)
      assert Dijkstra.shortest_path(graph, :a, :c) == [:a, :b, :c]
    end

    test "Dijkstra works on a cyclic graph" do
      graph = %{
        :a => [{:b, 2}, {:c, 1}],
        :b => [{:d, 3}],
        :c => [{:a, 1}, {:d, 5}],
        :d => [{:b, 2}]
      }

      assert Dijkstra.shortest_path(graph, :a, :d) == [:a, :b, :d]
      assert Dijkstra.shortest_path(graph, :c, :b) == [:c, :a, :b]
      assert Dijkstra.shortest_path(graph, :d, :a) == {:error, "No path found"}
    end

    test "Dijkstra works on a fully connected graph" do
      graph = %{
        :a => [{:b, 1}, {:c, 3}, {:d, 7}],
        :b => [{:c, 1}, {:d, 5}],
        :c => [{:d, 2}],
        :d => []
      }

      assert Dijkstra.shortest_path(graph, :a, :d) == [:a, :b, :c, :d]
      assert Dijkstra.shortest_path(graph, :b, :d) == [:b, :c, :d]
      assert Dijkstra.shortest_path(graph, :c, :d) == [:c, :d]
    end

    test "Dijkstra returns error when start and target are the same" do
      graph = %{
        :a => [{:b, 2}, {:c, 3}],
        :b => [{:c, 1}, {:d, 4}],
        :c => [{:d, 1}],
        :d => []
      }

      assert Dijkstra.shortest_path(graph, :a, :a) == [:a]
      assert Dijkstra.shortest_path(graph, :d, :d) == [:d]
    end

    test "Dijkstra works when the graph has only one node" do
      graph = %{
        :a => []
      }

      assert Dijkstra.shortest_path(graph, :a, :a) == [:a]
      assert Dijkstra.shortest_path(graph, :a, :b) == {:error, "No path found"}
    end

    test "Dijkstra works when all edges have the same weight" do
      graph = %{
        :a => [{:b, 1}, {:c, 1}],
        :b => [{:c, 1}, {:d, 1}],
        :c => [{:d, 1}],
        :d => []
      }

      assert Dijkstra.shortest_path(graph, :a, :d) == [:a, :b, :d]
    end
  end

  @tag :eccentricity
  test "Eccentricity is correctly calculated" do
    graph = %{
      :a => [{:b, 1}, {:c, 2}],
      :b => [{:d, 4}],
      :c => [{:d, 2}],
      :d => []
    }

    assert GraphMetrics.eccentricity(graph, :a) == 4
    assert GraphMetrics.eccentricity(graph, :b) == 4
  end

  @tag :radius
  test "Graph radius is calculated correctly" do
    graph = %{
      :a => [{:b, 1}, {:c, 2}],
      :b => [{:d, 4}],
      :c => [{:d, 2}],
      :d => []
    }

    assert GraphMetrics.radius(graph) == 2
  end

  @tag :diameter
  test "Graph diameter is calculated correctly" do
    graph = %{
      :a => [{:b, 1}, {:c, 2}],
      :b => [{:d, 4}],
      :c => [{:d, 2}],
      :d => []
    }

    assert GraphMetrics.diameter(graph) == 4
  end
end

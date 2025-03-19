defmodule GraphMetrics do
  alias Dijkstra

  @doc """
  Computes the eccentricity of a given vertex in the graph.
  Eccentricity is the longest shortest path from the vertex to any other vertex.
  """
  def eccentricity(graph, vertex) do
    distances =
      graph
      |> Map.keys()
      |> Enum.map(fn target ->
        case Dijkstra.shortest_path(graph, vertex, target) do
          {:error, _} -> :infinity
          path -> calculate_path_weight(graph, path)
        end
      end)

    # Filter out the distance to itself (which is always 0)
    distances_without_self =
      distances
      # Pair distances with their corresponding nodes
      |> Enum.zip(Map.keys(graph))
      # Exclude the vertex itself
      |> Enum.reject(fn {_, node} -> node == vertex end)
      # Extract distances
      |> Enum.map(fn {distance, _} -> distance end)
      |> Enum.filter(&(&1 != :infinity))

    # If all distances (excluding itself) are :infinity, the vertex is disconnected
    if distances_without_self == [] do
      {:error, "Disconnected vertex"}
    else
      # Compute the maximum distance (excluding itself)
      Enum.max(distances_without_self)
    end
  end

  defp calculate_path_weight(graph, path) do
    path
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(0, fn [from, to], acc ->
      weight = graph[from] |> Enum.find(fn {node, _} -> node == to end) |> elem(1)
      acc + weight
    end)
  end

  @doc """
  Computes the radius of the graph, which is the smallest eccentricity among all vertices.
  """
  def radius(graph) do
    graph
    |> Map.keys()
    |> Enum.map(&eccentricity(graph, &1))
    |> Enum.reject(&match?({:error, _}, &1))
    |> Enum.min()
  end

  @doc """
  Computes the diameter of the graph, which is the largest eccentricity among all vertices.
  """
  def diameter(graph) do
    graph
    |> Map.keys()
    |> Enum.map(&eccentricity(graph, &1))
    |> Enum.reject(&match?({:error, _}, &1))
    |> Enum.max()
  end
end

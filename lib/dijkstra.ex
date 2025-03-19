defmodule Dijkstra do
  @doc """
  Implements Dijkstra's algorithm to find the shortest path between two vertices.
  """
  def shortest_path(graph, start, target) do
    # If start and target are the same, return immediately
    if start == target do
      [start]
    else
      # Initialize distances with infinity, except for the start node
      distances = Map.new(graph, fn {node, _} -> {node, :infinity} end) |> Map.put(start, 0)

      # Priority queue (list of {distance, node})
      queue = [{0, start}]

      # Previous nodes for path reconstruction
      previous = %{}

      # Run Dijkstra's algorithm
      {final_distances, final_previous} = dijkstra(graph, queue, distances, previous)

      # If the target node has an infinite distance, there's no path to it
      if Map.get(final_distances, target, :infinity) == :infinity do
        {:error, "No path found"}
      else
        reconstruct_path(final_previous, target, [])
      end
    end
  end

  defp dijkstra(_graph, [], distances, previous), do: {distances, previous}

  defp dijkstra(graph, [{current_dist, current_node} | rest], distances, previous) do
    neighbors = Map.get(graph, current_node, [])

    {new_distances, new_previous, new_queue} =
      Enum.reduce(neighbors, {distances, previous, rest}, fn {neighbor, weight},
                                                             {dists, prev, q} ->
        alt = current_dist + weight

        if alt < Map.get(dists, neighbor, :infinity) do
          {
            Map.put(dists, neighbor, alt),
            Map.put(prev, neighbor, current_node),
            insert_sorted(q, {alt, neighbor})
          }
        else
          {dists, prev, q}
        end
      end)

    dijkstra(graph, new_queue, new_distances, new_previous)
  end

  defp insert_sorted(queue, {dist, node}) do
    Enum.sort([{dist, node} | queue], fn {d1, _}, {d2, _} -> d1 < d2 end)
  end

  defp reconstruct_path(_previous, nil, _path), do: {:error, "No path found"}

  defp reconstruct_path(previous, target, path) do
    case Map.get(previous, target) do
      nil when path == [] -> {:error, "No path found"}
      nil -> [target | path]
      prev -> reconstruct_path(previous, prev, [target | path])
    end
  end
end

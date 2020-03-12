defmodule SoilMeasurement do
  @moduledoc """
  Documentation for SoilMeasurement.
  """

  @metadata_count 2
  @starting_index 0
  @increment 1
  @default_start_pos_x 0
  @default_start_pos_y 0

  defstruct data: %{}, size: 0

  @doc """
  Get all most water-saturated areas for given map of water locations.

  ## Examples
      ex> SoilMeasurement.solve([1, 5, 5, 3, 1, 2, 0, 4, 1, 1, 3, 2, 2, 3, 2, 4, 3, 0, 2, 3, 3, 2, 1, 0, 2, 4, 3])
      [{3, 3, [score: 26]}]

  """
  @spec solve(list()) :: list()
  def solve(water_info) when is_list(water_info) do
    with true <- check_data(water_info),
         {[results_number, matrix_size], water_map} =
           extract_values(water_info, [], @metadata_count),
         true <- is_valid_metadata?(results_number, matrix_size) do
      matrix = build_matrix(matrix_size, water_map)
      sum = sum(matrix)
      prepare_results(sum, results_number, [])
    else
      false -> {:error, "#{__MODULE__}: Invalid water areas information!"}
    end
  end

  def solve(data) do
    {:error,
     "#{__MODULE__}: Invalid water areas information: #{inspect(data)} has to be in list format!"}
  end

  defp extract_values(data, acc, 0) do
    {Enum.reverse(acc), data}
  end

  defp extract_values([meta | rest_data], acc, metadata_count) do
    extract_values(rest_data, [meta | acc], metadata_count - 1)
  end

  defp build_matrix(size, data) do
    chunked_data = Enum.chunk_every(data, size)
    fields = transform_chunked_data(chunked_data, %{}, @starting_index)
    %SoilMeasurement{data: fields, size: size}
  end

  defp transform_chunked_data([], acc, _final_index) do
    acc
  end

  defp transform_chunked_data([x_val | rest], acc, index) do
    transform_chunked_data(rest, Map.put(acc, index, x_val), index + @increment)
  end

  defp sum(%SoilMeasurement{data: data, size: size}) do
    beginning_row = Map.get(data, @default_start_pos_y)
    sum_neighbours(@default_start_pos_x, beginning_row, @default_start_pos_y, data, [], size)
  end

  defp sum_neighbours(current_pos_y, _, _current_pos_x, _matrix, acc, size)
       when current_pos_y > size do
    Enum.sort(acc, fn {_, _, score1}, {_, _, score2} -> score1 >= score2 end)
  end

  defp sum_neighbours(current_pos_y, [], _current_pos_x, matrix, acc, size) do
    next_pos_y = current_pos_y + 1
    next = Map.get(matrix, next_pos_y, [])
    sum_neighbours(next_pos_y, next, @default_start_pos_x, matrix, acc, size)
  end

  defp sum_neighbours(current_pos_y, [x | rows], current_pos_x, matrix, acc, size) do
    upper_row = Map.get(matrix, current_pos_y - 1, [])
    current_row = Map.get(matrix, current_pos_y, [])
    lower_row = Map.get(matrix, current_pos_y + 1, [])

    sum =
      x +
        get_val(upper_row, current_pos_x - 1, 0) + get_val(upper_row, current_pos_x, 0) +
        get_val(upper_row, current_pos_x + 1, 0) +
        get_val(current_row, current_pos_x - 1, 0) +
        get_val(current_row, current_pos_x + 1, 0) +
        get_val(lower_row, current_pos_x - 1, 0) +
        get_val(lower_row, current_pos_x, 0) +
        get_val(lower_row, current_pos_x + 1, 0)

    sum_neighbours(
      current_pos_y,
      rows,
      current_pos_x + 1,
      matrix,
      [
        {current_pos_y, current_pos_x, score: sum} | acc
      ],
      size
    )
  end

  defp get_val(_, index, acc) when index < 0 do
    acc
  end

  defp get_val([], index, _acc) when index >= 0 do
    0
  end

  defp get_val([h | t], index, _acc) when index >= 0 do
    get_val(t, index - 1, h)
  end

  defp prepare_results(_res, 0, acc) do
    Enum.reverse(acc)
  end

  defp prepare_results([], _, acc) do
    Enum.reverse(acc)
  end

  defp prepare_results([top | rest], counter, acc) do
    prepare_results(rest, counter - 1, [top | acc])
  end

  defp check_data(data) when is_list(data) do
    Enum.all?(data, fn a ->
      is_integer(a) && a >= 0
    end)
  end

  defp is_valid_metadata?(results_number, matrix_size)
       when results_number > 0 and matrix_size > 0 do
    true
  end

  defp is_valid_metadata?(_results_number, _matrix_size), do: false
end

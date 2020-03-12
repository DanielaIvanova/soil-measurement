defmodule SoilMeasurementTest do
  use ExUnit.Case
  doctest SoilMeasurement

  test "calculation" do
    assert SoilMeasurement.solve([
             1,
             5,
             5,
             3,
             1,
             2,
             0,
             4,
             1,
             1,
             3,
             2,
             2,
             3,
             2,
             4,
             3,
             0,
             2,
             3,
             3,
             2,
             1,
             0,
             2,
             4,
             3
           ]) == [{3, 3, [score: 26]}]

    assert SoilMeasurement.solve([3, 4, 2, 3, 2, 1, 4, 4, 2, 0, 3, 4, 1, 1, 2, 3, 4, 4]) == [
             {2, 1, [score: 27]},
             {1, 1, [score: 25]},
             {2, 2, [score: 23]}
           ]
  end
end

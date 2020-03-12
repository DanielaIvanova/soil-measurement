# Soil Measurement

## Description
### Detecting Water on Mars 

NASA wishes to analyse soil on the surface of the planet Mars for the presence of water, using on-board instruments of the Curiosity rover. 
The sensors on the rover output raw data which can visualised as a grid representing the concentration of water in soil sample at 2D (x,y) coordinates on a map.

The raw measurements will always range from `0` (no water detected) to `9` (lots of water detected).

This data must be processed to find concentrated areas of water presence. The analysis consists of generating a score for each location on the grid.
The score is determined by adding the location's own raw water concentration value to its surrounding raw values. For instance, the score of location `(1,1)` in the following grid is determined as follows:

```
5 + 3 + 1 + 4 + 1 + 1 + 2 + 3 + 2 = 22
```

```
|---|---|---|---|---|
| 5 | 3 | 1 | 2 | 0 |
| 4 | 1 | 1 | 3 | 2 |
| 2 | 3 | 2 | 4 | 3 |
| 0 | 2 | 3 | 3 | 2 |
| 1 | 0 | 2 | 4 | 3 |
```

When dealing with locations around the edge of the grid the score should ignore values outside the grid. For instance the score of location `(0,0)` is as follows:

```
5 + 3 + 4 + 1 = 13
```


Please create programs which provide the following outputs:

1. Primary task: an ordered list of locations containing the t highest rated locations and their respective scores (~2h).
2. Bonus task: visualise the scores as an interactive two-dimensional heatmap where clicking an item will present the score numerically at the clicked location. (~1h).

Please track the version history of your solution using Git or Mercurial, and submit back a ZIP archive containing the version controlled solution, along with a README file with any possible running instructions.

<!--BREAK-->

### Input and Output

The input provided to the sensor data processor will be in the form of a list of numbers of the form: *t n Grid*

```
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 3 | 4 | 2 | 3 | 2 | 2 | 1 | 3 | 2 | 1 |
```

Where *t* is the number of results requested, *n* is the size of the grid and *grid* is a space delimited list of numbers that form the grid, starting with row 0.

The list of numbers above therefore represent a request for the single top score from a `3x3` grid that looks like so:
```
|---|---|---|
| 4 | 2 | 3 |
| 2 | 2 | 1 |
| 3 | 2 | 1 |
```

Output should be a list of locations and their scores in the following form:

```
 (x, y, score: score)
```

i.e. the result that should be returned for the above input is:

```
 (1, 1, score: 20)
```
## Usage
1. Clone the project and get the dependencies:
```
git clone https://github.com/DanielaIvanova/soil-measurement
cd soil-measurement
mix deps.get
```

2. Now you have to start the elixir app:
```
iex -S mix
```

3. To calculate water sensor data:
``` elixir
sensor_data = [4, 5, 5, 3, 1, 2, 0, 4, 1, 1, 3, 2, 2, 3, 2, 4, 3, 0, 2, 3, 3, 2, 1, 0, 2, 4, 3]
SoilMeasurement.solve(sensor_data)
[
  {3, 3, [score: 26]},
  {3, 2, [score: 23]},
  {2, 3, [score: 23]},
  {2, 2, [score: 22]}
]
```

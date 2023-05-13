# `START_TIME` and `END_TIME`

The `START_TIME` and `END_TIME` constants represent the start and end time of a selected day range as Unix timestamps.

## Constants

- `START_TIME` (type: `uint`): The Unix timestamp representing the start time of the selected day range.
- `END_TIME` (type: `uint`): The Unix timestamp representing the end time of the selected day range.

## Description

The `START_TIME` constant holds the Unix timestamp that corresponds to the start time of the selected day range. Similarly, the `END_TIME` constant holds the Unix timestamp for the end time of the selected day range.

These constants can be used in your script to reference the specific time range and perform calculations or comparisons with other timestamps or events.

## Example Usage

```cpp
// Get the current time
var eventTime: uint = getEvents(0)[0].startsAt;

if (eventTime = START_TIME && eventTime <= END_TIME)
{
    // The current time falls within the selected day range
    // Perform specific actions or logic
}
else
{
    // The current time is outside the selected day range
    // Handle accordingly
}
```

In the example above, the `START_TIME` and `END_TIME` constants are used to compare the start time of an event with the selected day range. Based on the comparison result, different actions can be performed.
# Function `getEvents`

The `getEvents` function allows you to retrieve a list of events for a specific day. This function takes a `dayIndex` parameter to specify the day for which you want to retrieve the events.

## Method Signature

```grimoire
getEvents(dayIndex: int) (list<pure Event>)
```

## Parameters

- `dayIndex` (type: `int`): Specifies the index of the day. It represents the position of the day in the day range ZODIAC was invoked with, starting from 0 for the first day.

## Return Value

The `getEvents` function returns a list of `Event` objects representing the events for the specified day.

## Example Usage

```grimoire
var events: list<pure Event> = getEvents(2);
```

In this example, the `getEvents` function is called with `dayIndex` 2 to retrieve the events for the third day. The events are stored in the `events` variable as a list of `Event` objects.

## Notes

- The `dayIndex` parameter should be a valid index within the range of available days.
- The events contained in the list are immutable and therefore cannot be changed.
- The returned list of `Event` objects can be empty if there are no events for the specified day.
- The `Event` objects can contain various properties such as event title, description, start time, end time, etc.

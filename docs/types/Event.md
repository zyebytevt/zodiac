# Class `Event`

The `Event` class is a data structure that represents an event. It contains properties such as the event's name, description, start time, and end time.

## Class Declaration

```grimoire
class Event {
    name: string;
    description: string;
    startsAt: uint;
    endsAt: uint;
    userdata1: string;
    userdata2: string;
}
```

## Properties

- `name` (type: `string`): Represents the name or title of the event.
- `description` (type: `string`): Represents a description or additional information about the event.
- `startsAt` (type: `uint`): Represents the start time of the event. It is stored as a 32-bit Unix timestamp, indicating the number of seconds since January 1, 1970, 00:00:00 UTC.
- `endsAt` (type: `uint`): Represents the end time of the event. It is also stored as a 32-bit Unix timestamp.
- `userdata1` (type: `string`): Represents a custom user-set string value.
- `userdata2` (type: `string`): Represents a custom user-set string value.

## Example Usage

```grimoire
var event: Event = @Event {
    name = "Birthday Party";
    description = "Celebrate my birthday with friends and family.";
    startsAt = 1677321600;  // March 27, 2023, 00:00:00 UTC
    endsAt = 1677343200;    // March 27, 2023, 06:00:00 UTC
};
```

In this example, an `Event` object is created and initialized with a name, description, start time, and end time.

## Notes

- The start and end times of the event are represented as 32-bit Unix timestamps. These timestamps are commonly used to store and manipulate date and time information.
- The `startsAt` and `endsAt` properties can be converted to human-readable date and time strings using the `formatTime` function.
- `userdata1` and `userdata2` are set while creating events.
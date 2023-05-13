# `formatTime` Function

The `formatTime` function is used to format a Unix timestamp into a human-readable time string according to the provided format string.

## Function Signature

```grimoire
formatTime(formatString: string, unixTimestamp: uint) (string);
```

## Parameters

- `formatString` (type: `string`): The format string that specifies how the Unix timestamp should be formatted into a time string.
- `unixTimestamp` (type: `uint`): The Unix timestamp representing a point in time.

## Format String Options

The format string can contain various placeholders that will be replaced with the corresponding values from the Unix timestamp. Here are the available options:

- `yy`: Last two digits of the year.
- `yyy`: Last three digits of the year.
- `yyyy`: Full year.
- `YYY`: Absolute value of the year, always positive.
- `b`: `bc` if the year is negative, otherwise nothing.
- `bb`: `bc` if the year is negative, `ad` otherwise.
- `bbb`: `ce` if the year is negative, `bce` otherwise.
- `bbbb`: `bce` if the year is negative, otherwise nothing.
- `m`: Month as a number.
- `mm`: Month as a zero-padded number.
- `mmm`: Short name of the month.
- `mmmm`: Full name of the month.
- `d`: Day as a number.
- `dd`: Day as a zero-padded number.
- `t`: Ordinal suffix for the day number in English (e.g., "st", "nd", "rd", "th").
- `www`: Short name of the weekday.
- `wwww`: Full name of the weekday.
- `h`: Hour in 12-hour format.
- `hh`: Hour in 12-hour format, zero-padded.
- `H`: Hour in 24-hour format.
- `HH`: Hour in 24-hour format, zero-padded.
- `a`: `a` for AM, `p` for PM.
- `aa`: `am` for AM, `pm` for PM.
- `i`: Minute.
- `ii`: Minute, zero-padded.
- `s`: Second.
- `ss`: Second, zero-padded.
- `f`: Fraction of seconds.
- `ff` and `fff`: Fraction of seconds, zero-padded.

## Example Usage

```grimoire
var timestamp: uint = 1620954321;
var formattedTime: string = formatTime("yyyy-mm-dd HH:ii:ss", timestamp);
```

In the example above, the `formatTime` function is called with a Unix timestamp and a format string of `"yyyy-mm-dd HH:ii:ss"`. This format string will result in a time string like `"2021-05-14 10:25:21"`.

## Notes

- The format options allow you to customize the output format according to your requirements.
- It is important to ensure that the format string is constructed correctly to match the desired output.

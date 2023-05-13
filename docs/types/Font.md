# Class `Font`

The `Font` class is a data structure that represents a font. It is used for specifying the path to a font file and the pixel size of the font.

## Constructor

- `@Font(path: string, size: int)`: Constructs a `Font` object with the specified font file path and pixel size.

## Constructor Parameters

- `path` (type: `string`): Represents the path to the font file. It should be a valid string representing the file path.
- `size` (type: `int`): Represents the pixel size of the font.

## Example Usage

```d
var font: Font = @Font("path/to/font.ttf", 16);
```

In this example, a `Font` object is created using the font file located at "path/to/font.ttf" with a pixel size of 16.

## Notes

- The `Font` class is used for specifying the font to be used in text rendering operations.
- The font file specified in the `path` parameter should be a valid font file format supported by ZODIAC (otf/ttf etc.)
- The `size` parameter determines the size of the font in pixels. It affects the visual appearance of the rendered text.

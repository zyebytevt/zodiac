# Function `drawText`

The `drawText` function allows you to draw text onto the generated image. This function takes several parameters to specify the text position, font, color, and alignment.

## Method Signature

```grimoire
drawText(x: int, y: int, text: pure string, font: pure Font, color: pure string, alignment: Align)
```

## Parameters

- `x` (type: `int`): Specifies the horizontal position of the text. It represents the X-coordinate on the canvas.
- `y` (type: `int`): Specifies the vertical position of the text. It represents the Y-coordinate on the canvas.
- `text` (type: `string`): Specifies the actual text content to be drawn on the screen.
- `font` (type: `Font`): Specifies the font used for rendering the text. It should be a valid `Font` object.
- `color` (type: `string`): Specifies the color of the text. It should be a valid color value.
- `alignment` (type: `Align`): Specifies the alignment of the text within the bounding box. It should be a valid `Align` value.

## Example Usage

```grimoire
const font: pure Font = @Font("path/to/font.ttf", 32);

drawText(100, 200, "Hello, World!", font, "#FF0000", Align.middleCenter);
```

In this example, the text "Hello, World!" will be drawn at the position (100, 200) using the specified font, red color, and middle-center alignment.

## Notes

- The `Font` object should be created and initialized before calling the `drawText` function.
- The `alignment` parameter determines how the text is aligned within the bounding box. Use one of the alignment values from the `Align` enum to specify the desired alignment.

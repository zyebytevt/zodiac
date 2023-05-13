# `prepare` Function

The `prepare` function is used to set up a drawing canvas before performing graphical operations. It has two overloaded variants: one that creates a new drawing canvas with the specified width and height, and another that uses an existing image as the base for the drawing canvas.

## Method Signatures

```cpp
prepare(width: int, height: int);
prepare(path: string);
```

## Overload Details

### Overload 1: `prepare(width: int, height: int)`

This overload creates a new drawing canvas with the specified width and height.

- `width` (type: `int`): Specifies the width of the drawing canvas in pixels.
- `height` (type: `int`): Specifies the height of the drawing canvas in pixels.

### Overload 2: `prepare(path: string)`

This overload uses an existing image as the base for the drawing canvas.

- `path` (type: `string`): Specifies the path to an existing image file that will serve as the base for the drawing canvas.

## Example Usage

```cpp
// Variant 1: Create a new drawing canvas
prepare(800, 600);

// Variant 2: Use an existing image as the base
prepare("path/to/image.png");
```

In the first example, `prepare` is called with the width of 800 pixels and height of 600 pixels to create a new drawing canvas.

In the second example, `prepare` is called with the path to an existing image file to use that image as the base for the drawing canvas.

## Notes

- It is essential to call the `prepare` function before performing any graphical operations in order to set up the drawing canvas properly. Failure to do so results in a crash.
- The `prepare` function can be called only once, and subsequent calls will overwrite the previous drawing canvas.
- The first variant creates a blank drawing canvas, while the second variant uses an existing image as the starting point for the drawing canvas.
- The specified image file in the second variant should be a valid image file format supported by ZODIAC.

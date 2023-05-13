# Function `drawImage`

The `drawImage` function is used to draw an image onto the drawing canvas at the specified coordinates. It allows scaling and specifying a sub-region of the source image to be drawn.

## Function Signature

```grimoire
drawImage(x: int, y: int, image: pure Image, [width: int, height: int,] [srcX: int, srcY: int, srcW: int, srcH: int]);
```

## Parameters

- `x` (type: `int`): The x-coordinate of the top-left corner of the drawn image on the canvas.
- `y` (type: `int`): The y-coordinate of the top-left corner of the drawn image on the canvas.
- `image` (type: `Image`): The image to be drawn on the canvas.
- `width` (optional, type: `int`): The width of the drawn image on the canvas. Defaults to the original image width if not specified.
- `height` (optional, type: `int`): The height of the drawn image on the canvas. Defaults to the original image height if not specified.
- `srcX` (optional, type: `int`): The x-coordinate of the top-left corner of the sub-region in the source image to be drawn. Defaults to 0 if not specified.
- `srcY` (optional, type: `int`): The y-coordinate of the top-left corner of the sub-region in the source image to be drawn. Defaults to 0 if not specified.
- `srcW` (optional, type: `int`): The width of the sub-region in the source image to be drawn. Defaults to the full width of the source image if not specified.
- `srcH` (optional, type: `int`): The height of the sub-region in the source image to be drawn. Defaults to the full height of the source image if not specified.

## Function Details

- `x` and `y` specify the coordinates on the canvas where the top-left corner of the drawn image will be positioned.
- `image` is the image to be drawn on the canvas. It should be an instance of the `Image` class.
- `width` and `height` determine the dimensions of the drawn image on the canvas. They can be used to scale the image. If not provided, the original dimensions of the image will be used.
- `srcX`, `srcY`, `srcW`, and `srcH` define a sub-region within the source image that will be drawn. These parameters allow drawing only a portion of the image. If not specified, the entire source image will be drawn.

## Example Usage

```grimoire
const image: pure Image = @Image("path/to/image.png");

// Draw the entire image at position (100, 100) without scaling
drawImage(100, 100, image);

// Draw a scaled version of the image at position (200, 200) with width of 150 and height of 100
drawImage(200, 200, image, 150, 100);

// Draw a sub-region of the image at position (300, 300) with a source rectangle of (50, 50, 100, 100)
drawImage(300, 300, image, 300, 300, 50, 50, 100, 100);
```

In the first example, the entire `image` is drawn at the position `(100, 100)` on the canvas without any scaling.

In the second example, a scaled version of the `image` is drawn at the position `(200, 200)` on the canvas with a width of `150` and a height of `100`.

In the third example, a sub-region of the `image` is drawn at the position `(300, 300)` and size `(300, 300)` on the canvas. The sub-region is specified using the source rectangle `(50, 50, 100, 100)`.
# Class `Image`

The `Image` class is a data structure represents an image. It is used for loading an image into memory, to be used for graphical operations.

## Constructor

- `@Image(path: string)`: Constructs an `Image` object with the specified image file path.

## Constructor Parameters

- `path` (type: `string`): Represents the path to the image file. It should be a valid file path.

## Example Usage

```grimoire
var image: Image = @Image("path/to/image.png");
```

In this example, an `Image` object is instantiated using the image file located at `path/to/image.png`. The `image` variable is assigned the newly created `Image` object.

## Notes

- The `Image` class is used for specifying an image to be used in graphical operations.
- The image file specified in the `path` parameter should be a valid image file format supported by ZODIAC.

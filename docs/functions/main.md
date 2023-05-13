# Script Entry Point: `event main()`

The `event main()` function serves as the entry point for executing the drawing script. When the script is run, the code inside the `event main()` function will be executed.

## Event Signature

```grimoire
event main();
```

## Description

The `event main()` function is a special event function that acts as the starting point for script execution. It is called automatically when the script is run, and any code inside this function will be executed in sequence.

## Usage

The `event main()` function can be used to define the logic of what should be drawn onto the canvas. You can include any desired code within the function to perform specific tasks or trigger further actions.

## Example

Here's an example of a basic `event main()` function:

```grimoire
event main()
{
    prepare(400, 300);
    const font: Font = @Font("example.ttf", 20);

    drawText(100, 100, "Hello world!", font, "#ffffff", Align.topCenter);
}
```

In the example above, the `event main()` function is defined to create a canvas of the size 400x300, load a font and draw "Hello world!" onto it. You can customize the contents of the function to suit your specific script requirements.

## Notes

- `event main()` can only be defined once, and may not have any overloads.
- The `main()` function is a common convention in many programming languages and frameworks as the entry point for program execution.

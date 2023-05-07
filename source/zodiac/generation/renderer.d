/*
 * This file is part of the ZODIAC project.
 * Copyright © 2023 ZyeByteVT
 *
 * This program is free software.
 * You should have received a copy of the GNU General Public License v3
 * along with this program and source code.
 */
module zodiac.generation.renderer;

import std.string : toStringz, fromStringz, format;
import std.path : extension;
import std.exception : enforce;
import std.conv : to;
import std.traits : isNumeric;

import bindbc.sdl;

import zodiac.app : logVerbose;

enum TextAlignment
{
    topLeft, topCenter, topRight,
    middleLeft, middleCenter, middleRight,
    bottomLeft, bottomCenter, bottomRight
}

struct Point2(T)
    if (isNumeric!T)
{
public:
    T x, y;
}

alias Position = Point2!int;

struct Rectangle(T)
{
public:
    Point2!T position;
    Point2!T size;
}

alias Region = Rectangle!int;

struct Color
{
public:
    enum white = Color(255, 255, 255, 255);

    ubyte red = 255;
    ubyte green = 255;
    ubyte blue = 255;
    ubyte alpha = 255;

    this(ubyte r, ubyte g, ubyte b, ubyte a = 255)
    {
        red = r;
        green = g;
        blue = b;
        alpha = a;
    }

    this(string code)
    {
        enforce(code.length >= 7 && code[0] == '#', "Invalid color code.");

        red = code[1 .. 3].to!ubyte(16);
        green = code[3 .. 5].to!ubyte(16);
        blue = code[5 .. 7].to!ubyte(16);

        if (code.length >= 9)
            alpha = code[7 .. 9].to!ubyte(16);
    }

    SDL_Color opCast(SDL_Color)() const
    {
        return SDL_Color(red, green, blue, alpha);
    }
}

class Font
{
protected:
    TTF_Font* mFont;
    string mPath;

public:
    this(string path, int size)
    {
        logVerbose("Loading font %s with size %d...", path, size);

        mPath = path;
        mFont = TTF_OpenFont(path.toStringz, size);
        enforce(mFont, format!"Failed to open font '%s': %s"(path, SDL_GetError().fromStringz));
    }

    ~this()
    {
        if (mFont)
            TTF_CloseFont(mFont);
    }

    string path() @safe pure nothrow
    {
        return mPath;
    }
}

class Image
{
protected:
    SDL_Surface* mSurface;
    string mPath;

public:
    this(string path)
    {
        logVerbose("Loading image %s...", path);

        mPath = path;
        mSurface = IMG_Load(path.toStringz);
        enforce(mSurface, format!"Failed to load image '%s': %s"(path, SDL_GetError().fromStringz));
    }

    ~this()
    {
        if (mSurface)
            SDL_FreeSurface(mSurface);
    }

    Point2!int size() @safe pure nothrow
    {
        return Point2!int(mSurface.w, mSurface.h);
    }

    string path() @safe pure nothrow
    {
        return mPath;
    }
}

class Renderer
{
protected:
    SDL_Surface* mWorkbench;

public:
    ~this()
    {
        if (mWorkbench)
            SDL_FreeSurface(mWorkbench);
    }

    void initialize(int width, int height)
    {
        logVerbose("Initializing renderer with empty canvas size %dx%d...", width, height);

        if (mWorkbench)
            SDL_FreeSurface(mWorkbench);
        mWorkbench = SDL_CreateRGBSurface(0, width, height, 32, 0, 0, 0, 0);
    }

    void initialize(string baseImage)
    {
        logVerbose("Initializing renderer with canvas image %s...", baseImage);

        if (mWorkbench)
            SDL_FreeSurface(mWorkbench);
        mWorkbench = IMG_Load(baseImage.toStringz);
        enforce(mWorkbench, format!"Failed to initialize renderer with '%s': %s"(baseImage, SDL_GetError().fromStringz));
    }

    void drawImage(Image image, Position position)
    {
        logVerbose("Renderer::drawImage(\"%s\", %s)", image.path, position);

        enforce(mWorkbench, "Renderer has not been initialized.");

        auto dst = SDL_Rect(position.x, position.y, 0, 0);

        SDL_BlitSurface(image.mSurface, null, mWorkbench, &dst);
    }

    void drawImage(Image image, Region destination)
    {
        logVerbose("Renderer::drawImage(\"%s\", %s)", image.path, destination);

        enforce(mWorkbench, "Renderer has not been initialized.");

        auto dst = SDL_Rect(destination.position.x, destination.position.y, destination.size.x, destination.size.y);

        SDL_BlitScaled(image.mSurface, null, mWorkbench, &dst);
    }

    void drawImage(Image image, Region source, Region destination)
    {
        logVerbose("Renderer::drawImage(\"%s\", %s, %s)", image.path, source, destination);

        enforce(mWorkbench, "Renderer has not been initialized.");

        auto src = SDL_Rect(source.position.x, source.position.y, source.size.x, source.size.y);
        auto dst = SDL_Rect(destination.position.x, destination.position.y, destination.size.x, destination.size.y);

        SDL_BlitScaled(image.mSurface, &src, mWorkbench, &dst);
    }

    void drawText(Font font, Position position, string text,
	    Color color = Color.white, TextAlignment textAlign = TextAlignment.topLeft)
    {
        logVerbose("Renderer::drawText(\"%s\", %s, \"%s\", %s, %s)", font.path, position, text, color, textAlign);

        enforce(mWorkbench, "Renderer has not been initialized.");

        SDL_Surface* textSurface = TTF_RenderUTF8_Blended(font.mFont, text.toStringz, cast(SDL_Color) color);
        enforce(textSurface, "Failed to render text: " ~ SDL_GetError().fromStringz);
        scope (exit) SDL_FreeSurface(textSurface);
        
        switch (textAlign % 3)
        {
        case 1:
            position.x -= textSurface.w / 2;
            break;

        case 2:
            position.x -= textSurface.w;
            break;

        default:
        }

        switch (textAlign / 3)
        {
        case 1:
            position.y -= textSurface.h / 2;
            break;

        case 2:
            position.y -= textSurface.h;
            break;

        default:
        }

        auto rect = SDL_Rect(position.x, position.y, textSurface.w, textSurface.h);
        SDL_BlitSurface(textSurface, null, mWorkbench, &rect);
    }

    void save(string path)
    {
        logVerbose("Saving image to %s...", path);

        enforce(mWorkbench, "Renderer has not been initialized.");

        immutable string ext = path.extension;
        int errorCode;

        switch (ext)
        {
        case ".png":
            errorCode = IMG_SavePNG(mWorkbench, path.toStringz);
            break;

        default:
            throw new Exception("Unsupported image type " ~ ext);
        }

        if (errorCode != 0)
            throw new Exception("Could not save image: " ~ SDL_GetError().fromStringz.idup);
    }
}
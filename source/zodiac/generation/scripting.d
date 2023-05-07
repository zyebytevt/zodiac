/*
 * This file is part of the ZODIAC project.
 * Copyright © 2023 ZyeByteVT
 *
 * This program is free software.
 * You should have received a copy of the GNU General Public License v3
 * along with this program and source code.
 */
module zodiac.generation.scripting;

import std.datetime;
import std.typecons : Nullable;

import grimoire;

import zodiac.database;
import zodiac.generation.renderer;
import zodiac.utils.datetimeformat;

struct Scripting
{
private static:
    GrLibrary sGrStdLib;
    RenderLibrary sGrRenderLib;
    EventDTO[][int] sEvents;
    DateTime sScheduleStart;
    DateTime sScheduleEnd;

    Renderer sRenderer;

    void grFontCtor(GrCall call)
    {
        immutable string path = call.getString(0).str;
        immutable int size = call.getInt(1);

        try call.setNative(new Font(path, size));
        catch (Exception ex) call.raise(new GrString(ex.msg));
    }

    void grImageCtor(GrCall call)
    {
        immutable string path = call.getString(0).str;

        try call.setNative(new Image(path));
        catch (Exception ex) call.raise(new GrString(ex.msg));
    }

    void grDrawText(GrCall call)
    {
        immutable int x = call.getInt(0);
        immutable int y = call.getInt(1);
        immutable string text = call.getString(2).str;
        Font font = call.getNative!Font(3);
        immutable Color color = Color(call.getString(4).str);
        immutable TextAlignment textAlign = call.getEnum!TextAlignment(5);

        try sRenderer.drawText(font, Position(x, y), text, color, textAlign);
        catch (Exception ex) call.raise(new GrString(ex.msg));
    }

    void grFormatTime(GrCall call)
    {
        immutable string fmtString = call.getString(0).str;
        immutable uint timestamp = call.getUInt(1);

        try
        {
            SysTime time = SysTime.fromUnixTime(timestamp, UTC());
            immutable string result = format(time, fmtString);

            call.setString(result);
        }
        catch (Exception ex) call.raise(new GrString(ex.msg));
    }

    void grGetEvents(GrCall call)
    {
        EventDTO[] events = sEvents.get(call.getInt(0), []);

        GrObject convertDTO(EventDTO dto)
        {
            GrObject obj = call.createObject("Event");
            obj.setString("name", dto.name);
            obj.setString("description", dto.description);
            obj.setUInt("startsAt", cast(uint) SysTime(dto.starts_at, UTC()).toUnixTime());
            obj.setUInt("endsAt", cast(uint) SysTime(dto.ends_at, UTC()).toUnixTime());

            return obj;
        }

        GrList result = new GrList();
        foreach (EventDTO ev; events)
            result.pushBack(GrValue(convertDTO(ev)));

        call.setList(result);
    }

    void grPrepareSize(GrCall call)
    {
        immutable int x = call.getInt(0);
        immutable int y = call.getInt(1);

        try sRenderer.initialize(x, y);
        catch (Exception ex) call.raise(new GrString(ex.msg));
    }

    void grPrepareImage(GrCall call)
    {
        immutable string path = call.getString(0).str;

        try sRenderer.initialize(path);
        catch (Exception ex) call.raise(new GrString(ex.msg));
    }

    void grDrawImageSimple(GrCall call)
    {
        immutable int x = call.getInt(0);
        immutable int y = call.getInt(1);
        Image image = call.getNative!Image(2);

        try sRenderer.drawImage(image, Point2!int(x, y));
        catch (Exception ex) call.raise(new GrString(ex.msg));
    }

    void grDrawImageScaled(GrCall call)
    {
        immutable int x = call.getInt(0);
        immutable int y = call.getInt(1);
        Image image = call.getNative!Image(2);
        immutable int w = call.getInt(3);
        immutable int h = call.getInt(4);

        try sRenderer.drawImage(image, Region(Point2!int(x, y), Point2!int(w, h)));
        catch (Exception ex) call.raise(new GrString(ex.msg));
    }

    void grDrawImageRegion(GrCall call)
    {
        immutable int dstX = call.getInt(0);
        immutable int dstY = call.getInt(1);
        Image image = call.getNative!Image(2);
        immutable int dstW = call.getInt(3);
        immutable int dstH = call.getInt(4);

        immutable int srcX = call.getInt(5);
        immutable int srcY = call.getInt(6);
        immutable int srcW = call.getInt(7);
        immutable int srcH = call.getInt(8);

        try
        {
            sRenderer.drawImage(image, Region(Point2!int(srcX, srcY), Point2!int(srcW, srcH)),
                Region(Point2!int(dstX, dstY), Point2!int(dstW, dstH)));
        }
        catch (Exception ex) call.raise(new GrString(ex.msg));
    }

    GrLibrary createCustomStdLib()
    {
        GrLibrary stdlib = new GrLibrary();
        
        foreach (loader; [&grLoadStdLibConstraint, &grLoadStdLibIo, &grLoadStdLibSystem, &grLoadStdLibOptional, &grLoadStdLibList,
            &grLoadStdLibRange, &grLoadStdLibString, &grLoadStdLibChannel, &grLoadStdLibMath, &grLoadStdLibError,
            &grLoadStdLibTypecast, &grLoadStdLibPair, &grLoadStdLibBitmanip, &grLoadStdLibHashMap,
            &grLoadStdLibQueue, &grLoadStdLibCircularBuffer])
            loader(stdlib);
        
        return stdlib;
    }

    RenderLibrary createRenderLib()
    {
        RenderLibrary lib;

        lib.grLibrary = new GrLibrary();

        lib.grAlign = lib.grLibrary.addEnum("Align", ["topLeft", "topCenter", "topRight",
            "middleLeft", "middleCenter", "middleRight",
            "bottomLeft", "bottomCenter", "bottomRight"]);

        lib.grFont = lib.grLibrary.addNative("Font");
        lib.grEvent = lib.grLibrary.addClass("Event", ["name", "description", "startsAt", "endsAt"],
            [grString, grString, grUInt, grUInt]);
        lib.grImage = lib.grLibrary.addNative("Image");

        lib.grLibrary.addConstructor(&grFontCtor, lib.grFont, [grString, grInt]);
        lib.grLibrary.addConstructor(&grImageCtor, lib.grImage, [grString]);

        lib.grLibrary.addFunction(&grPrepareSize, "prepare", [grInt, grInt]);
        lib.grLibrary.addFunction(&grPrepareImage, "prepare", [grString]);
        lib.grLibrary.addFunction(&grDrawText, "drawText", [grInt, grInt, grString, lib.grFont, grString, lib.grAlign]);
        lib.grLibrary.addFunction(&grFormatTime, "formatTime", [grString, grUInt], [grString]);
        lib.grLibrary.addFunction(&grGetEvents, "getEvents", [grInt], [grList(lib.grEvent)]);
        lib.grLibrary.addFunction(&grDrawImageSimple, "drawImage", [grInt, grInt, lib.grImage]);
        lib.grLibrary.addFunction(&grDrawImageScaled, "drawImage", [grInt, grInt, lib.grImage, grInt, grInt]);
        lib.grLibrary.addFunction(&grDrawImageRegion, "drawImage", [grInt, grInt, lib.grImage, grInt, grInt,
            grInt, grInt, grInt, grInt]);

        immutable startUnixTime = cast(uint) SysTime(sScheduleStart, UTC()).toUnixTime();
        immutable endUnixTime = cast(uint) SysTime(sScheduleEnd, UTC()).toUnixTime();

        lib.grLibrary.addVariable("START_TIME", grUInt, GrValue(startUnixTime), true);
        lib.grLibrary.addVariable("END_TIME", grUInt, GrValue(endUnixTime), true);

        return lib;
    }

public static:
    void initialize(Renderer renderer, EventDTO[] events, DateTime scheduleStart, DateTime scheduleEnd)
    {
        sRenderer = renderer;

        sScheduleStart = scheduleStart;
        sScheduleEnd = scheduleEnd;

        sGrStdLib = createCustomStdLib();
        sGrRenderLib = createRenderLib();

        foreach (EventDTO event; events)
        {
            immutable int index = cast(int) (event.starts_at - scheduleStart).total!"days";

            if (index in sEvents)
                sEvents[index] ~= event;
            else
                sEvents[index] = [event];
        }
    }

    void execute(string file)
    {
        GrCompiler compiler = new GrCompiler();

        compiler.addLibrary(sGrStdLib);
        compiler.addLibrary(sGrRenderLib.grLibrary);

        compiler.addFile(file);

        GrBytecode bytecode = compiler.compile(GrOption.symbols, GrLocale.en_US);
        if (!bytecode)
            throw new Exception(compiler.getError().prettify(GrLocale.en_US));

        GrEngine engine = new GrEngine();
        
        engine.addLibrary(sGrStdLib);
        engine.addLibrary(sGrRenderLib.grLibrary);
        engine.load(bytecode);

        engine.callEvent("main");

        while (engine.hasTasks)
		    engine.process();

        if (engine.isPanicking)
        {
            import std.stdio : stderr;
            stderr.writeln("panic: " ~ engine.panicMessage);
            foreach (trace; engine.stackTraces)
            {
                stderr.writeln("    in ", trace.name, " at ", trace.file,
                    "(", trace.line, ",", trace.column, ")");
            }
        }
    }
}

struct RenderLibrary
{
    GrLibrary grLibrary;
    GrType grAlign, grFont, grEvent, grImage;
}
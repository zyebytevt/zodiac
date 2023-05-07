/*
 * This file is part of the ZODIAC project.
 * Copyright © 2023 ZyeByteVT
 *
 * This program is free software.
 * You should have received a copy of the GNU General Public License v3
 * along with this program and source code.
 */
module zodiac.app;

import core.time;
import std.getopt;
import std.stdio;
import std.string : fromStringz;
import std.datetime;

import bindbc.sdl;
import bindbc.loader;

import zodiac.database;
import zodiac.generation.renderer;
import zodiac.generation.scripting;

bool verbose = false;

int main(string[] args)
{
	string databaseFile = "zodiac.db";
	string mainScriptFile = "main.gr";
	string outputFile = "out.png";
	string startDateString;
	int amountOfDays = 7;

	try
	{
		GetoptResult helpInfo = getopt(
			args,
			"database|b", "The database file to use.", &databaseFile,
			"script|i", "The script file to execute for image generation.", &mainScriptFile,
			"output|o", "The path of the image to generate.", &outputFile,
			"verbose|v", "Verbose output.", &verbose,
			"days|d", "Amount of days to use in the scheudle.", &amountOfDays,

			std.getopt.config.required,
			"start-date|s", "Day to start the schedule on.", &startDateString
		);

		if (helpInfo.helpWanted)
		{
			defaultGetoptPrinter("ZODIAC Schedule Image Generation Tool © ZyeByte 2023", helpInfo.options);
			return 0;
		}

		immutable Date startDate = Date.fromISOExtString(startDateString);

		Database.open(databaseFile);
		scope (exit) Database.close();

		if (!initDynamicLibraries())
			return 1;
		
		renderScheduleImage(mainScriptFile, outputFile, startDate, amountOfDays);

		return 0;
	}
	catch (Exception ex)
	{
		stderr.writeln(ex.msg);
		stderr.writeln("Use -h or --help for more information.");
		return 1;
	}
}

void renderScheduleImage(string scriptFile, string outputFile, Date startDay, int amountOfDays)
{
	immutable DateTime start = DateTime(startDay, TimeOfDay(0, 0, 0));
	immutable DateTime end = DateTime(startDay + dur!"days"(amountOfDays), TimeOfDay(23, 59, 59));

	EventDTO[] events = Database.getEventsInRange(start, end);

	Renderer renderer = new Renderer();
	Scripting.initialize(renderer, events, start, end);

	Scripting.execute(scriptFile);
	renderer.save(outputFile);
}

bool initDynamicLibraries()
{
	void writeLoaderLogs()
	{
		import loader = bindbc.loader.sharedlib;

		foreach(info; loader.errors)
			stderr.writefln("%s: %s", info.error.fromStringz, info.message.fromStringz);
	}

	SDLSupport sdlResult = loadSDL();
	SDLImageSupport sdlImageResult = loadSDLImage();
	SDLTTFSupport sdlTtfResult = loadSDLTTF();

	if (loadSDL() != sdlSupport)
	{
		stderr.writeln("This application requires at least SDL v2.0.0.");
		writeLoaderLogs();
		return false;
	}

	if (loadSDLImage() != sdlImageSupport)
	{
		stderr.writeln("This application requires at least SDL Image v2.0.0.");
		writeLoaderLogs();
		return false;
	}

	if (loadSDLTTF() != sdlTTFSupport)
	{
		stderr.writeln("This application requires at least SDL TTF v2.0.12.");
		writeLoaderLogs();
		return false;
	}

	if (SDL_Init(SDL_INIT_VIDEO) != 0)
	{
		stderr.writefln("SDL_Init failed: %s", SDL_GetError().fromStringz);
		return false;
	}

	immutable int imgFlags = IMG_INIT_PNG;
	if ((IMG_Init(imgFlags) & imgFlags) != imgFlags)
	{
		stderr.writefln("IMG_Init failed: %s", SDL_GetError().fromStringz);
		return false;
	}

	if (TTF_Init() != 0)
	{
		stderr.writefln("TTF_Init failed: %s", SDL_GetError().fromStringz);
		return false;
	}

	return true;
}

void logVerbose(Args...)(string msg, Args args)
{
	if (!verbose)
		return;

	writefln(msg, args);
}
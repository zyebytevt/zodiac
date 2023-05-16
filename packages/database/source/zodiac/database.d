/*
 * This file is part of the ZODIAC project.
 * Copyright © 2023 ZyeByteVT
 *
 * This program is free software.
 * You should have received a copy of the GNU General Public License v3
 * along with this program and source code.
 */
module zodiac.database;

import std.datetime;
import std.string : format;

import ddbc;

struct Database
{
protected static:
    Connection mConnection;

    EventDTO[] convertResultSetToEventDTO(ResultSet set)
    {
        EventDTO[] result;

        while (set.next())
            result ~= set.get!EventDTO();

        return result;
    }

    pragma(inline, true)
    string toSQLiteDateTimeString(DateTime datetime)
    {
        return format!"%d-%02d-%02d %02d:%02d:%02d"(datetime.year, datetime.month, datetime.day,
            datetime.hour, datetime.minute, datetime.second);
    }

public static:
    void open(string path)
    {
        mConnection = createConnection("ddbc:sqlite:" ~ path);
        
        Statement stmt = mConnection.createStatement();
        scope (exit) stmt.close();

        stmt.executeUpdate(`CREATE TABLE IF NOT EXISTS event (
            id INTEGER PRIMARY KEY,
            name VARCHAR(100) NOT NULL,
            description VARCHAR(200) NULL,
            starts_at DATETIME NOT NULL,
            ends_at DATETIME NOT NULL,
            userdata1 VARCHAR(255) NULL,
            userdata2 VARCHAR(255) NULL
        );`);
    }

    void close()
    {
        mConnection.close();
    }

    EventDTO[] getAllEvents()
    {
        Statement stmt = mConnection.createStatement();
        ResultSet set = stmt.executeQuery(`SELECT * FROM event ORDER BY starts_at ASC;`);
        
        scope (exit)
        {
            set.close();
            stmt.close();
        }

        return convertResultSetToEventDTO(set);
    }

    EventDTO[] getEventsInRange(DateTime begin, DateTime end)
    {
        PreparedStatement ps = mConnection.prepareStatement(`SELECT * FROM event
        WHERE starts_at BETWEEN ? AND ?
        ORDER BY starts_at ASC;`);

        ps.setString(1, toSQLiteDateTimeString(begin));
        ps.setString(2, toSQLiteDateTimeString(end));

        ResultSet set = ps.executeQuery();
        scope (exit)
        {
            set.close();
            ps.close();
        }

        return convertResultSetToEventDTO(set);
    }
}

struct EventDTO
{
    int id;
    string name;
    string description;
    DateTime starts_at;
    DateTime ends_at;
    string userdata1;
    string userdata2;
}
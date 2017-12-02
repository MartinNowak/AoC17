#!/usr/bin/env rdmd
import std.algorithm, std.conv, std.range, std.stdio;

void main()
{
    stdin
        .byLine
        .map!((line) @safe {
            auto mm = line.splitter.map!(to!uint).fold!(max, min);
            return mm[0] - mm[1];
        })
        .sum
        .writeln;
}

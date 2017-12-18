#!/usr/bin/env rdmd
import std.algorithm, std.conv, std.range, std.stdio;

void main()
{
    ubyte[256] data;
    foreach (i, ref d; data)
        d = cast(ubyte)i;
    auto rng = data[].cycle;
    foreach (skip, len; stdin.readln.splitter(",").map!(to!uint).enumerate)
    {
        reverse(rng[0 .. len]);
        rng.popFrontN(len + skip);
    }
    writeln(data[0] * data[1]);
}

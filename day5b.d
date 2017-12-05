#!/usr/bin/env rdmd
import std.algorithm, std.conv, std.range, std.stdio;

void main()
{
    auto jumps = stdin
        .byLine
        .map!(to!int)
        .array;
    size_t cnt;
    for (int ip = 0; ip >= 0 && ip < jumps.length; ++cnt)
    {
        immutable off = jumps[ip];
        jumps[ip] += off >= 3 ? -1 : 1;
        ip += off;
    }
    writeln(cnt);
}

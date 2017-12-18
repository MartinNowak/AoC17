#!/usr/bin/env rdmd
import std.algorithm, std.conv, std.range, std.stdio;

void main()
{
    import std.string : representation;

    ubyte[256] data;
    foreach (i, ref d; data)
        d = cast(ubyte)i;
    auto rng = data[].cycle;
    auto lens = stdin.readln.representation.chain([17, 31, 73, 47, 23]);
    foreach (skip, len; lens.cycle.take(lens.length * 64).enumerate)
    {
        reverse(rng[0 .. len]);
        rng.popFrontN(len + skip);
    }
    writefln!"%(%02x%)"(data[].chunks(16).map!(chk => chk.fold!((a, b) => a ^ b)));
}

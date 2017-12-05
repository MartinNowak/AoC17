#!/usr/bin/env rdmd
import std.algorithm, std.conv, std.range, std.stdio;

void main()
{
    stdin
        .byLine
        .map!((line) {
            char[][16] buf;
            auto words = buf[0 .. $ - line.splitter.copy(buf[]).length];
            auto groups = words.sort().groupBy();
            return groups.all!(grp => grp.dropOne.empty);
        })
        .cache
        .filter!(p => p == true)
        .sum
        .writeln;
}

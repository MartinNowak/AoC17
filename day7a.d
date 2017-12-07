#!/usr/bin/env rdmd
import std.algorithm, std.conv, std.format, std.range, std.stdio;

void main()
{
    uint[string] weights;
    string[string] parents;
    stdin
        .byLine
        .each!((char[] line) {
            auto parts = line.findSplit(" -> ");
            string name;
            uint weight;
            parts[0].formattedRead!"%s (%u)"(name, weight);
            weights[name] = weight;
            foreach (child; parts[2].splitter(", "))
                parents[child.idup] = name;
        });
    auto node = parents.byKey.front;
    for (auto p = node in parents; p; p = node in parents)
        node = *p;
    writeln("root ", node);
}

#!/usr/bin/env rdmd
import std.algorithm, std.conv, std.format, std.range, std.stdio;

void main()
{
    uint[string] weights;
    string[string] parents;
    string[][string] children;

    uint weight(string node)
    {
        auto pcs = node in children;
        if (pcs is null)
            return weights[node];
        auto balance1 = weight((*pcs)[0]);
        uint balance2;
        auto sum = balance1;
        foreach (i, c; (*pcs)[1 .. $])
        {
            immutable w = weight(c);
            if (balance2)
            {
                immutable cunb = w == balance2 ? (*pcs)[i] : (*pcs)[i - 1];
                immutable wunb = weight(cunb);
                writeln("unbalanced ", cunb, " balanced ", w, " cum. weight ", wunb, " weight ", weights[cunb],
                        " should be ", w - wunb + weights[cunb]);
                balance2 = 0;
            }
            else if (w != balance1)
            {
                balance2 = balance1;
                balance1 = w;
            }
            sum += w;
        }
        return sum + weights[node];
    }

    stdin
        .byLine
        .each!((char[] line) {
            auto parts = line.findSplit(" -> ");
            string name;
            uint weight;
            parts[0].formattedRead!"%s (%u)"(name, weight);
            weights[name] = weight;
            foreach (child; parts[2].splitter(", ").map!(c => c.idup))
            {
                parents[child] = name;
                children[name] ~= child;
            }
        });
    auto node = parents.byKey.front;
    for (auto p = node in parents; p; p = node in parents)
        node = *p;
    writeln("root ", node, " ", weight(node));
}

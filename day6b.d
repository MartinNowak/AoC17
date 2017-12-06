#!/usr/bin/env rdmd
import std.algorithm, std.conv, std.range, std.stdio;

size_t wrap(size_t a, size_t max)
{
    return a == max ? 0 : a;
}

void redistribute(ubyte[] blocks)
{
    immutable maxIndex = blocks.enumerate.maxElement!(t => t.value).index;
    auto val = blocks[maxIndex];
    blocks[maxIndex] = 0;
    for (size_t idx = wrap(maxIndex + 1, blocks.length); val--; idx = wrap(idx + 1, blocks.length))
        ++blocks[idx];
}

void main()
{
    auto blocks = stdin
        .readln
        .splitter("\t")
        .map!(to!ubyte)
        .array;
    size_t[immutable(ubyte)[]] seen;
    for (size_t n; ; ++n)
    {
        if (auto p = blocks in seen)
        {
            writeln(n - *p);
            break;
        }
        seen[blocks.idup] = n;
        redistribute(blocks);
    }
}

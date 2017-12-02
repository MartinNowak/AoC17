#!/usr/bin/env rdmd
import std.algorithm, std.conv, std.range, std.stdio;

void main()
{
    stdin
        .byLine
        .map!((line) {
            auto nums = line.splitter.map!(to!uint);
            auto pair = cartesianProduct(nums, nums)
                .filter!(p => p[0] != p[1])
                .find!(p => p[0] / p[1] * p[1] == p[0])
                .front;
            return pair[0] / pair[1];
        })
        .sum
        .writeln;
}

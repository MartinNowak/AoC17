#!/usr/bin/env rdmd
import std.algorithm, std.conv, std.range, std.stdio;

void main(string[] args) @safe
{
    auto captcha = args[1];
    auto nums = captcha.map!(d => d - '0');
    nums
        .zip(nums.cycle.drop(nums.walkLength / 2))
        .fold!((sum, pair) => sum + (pair[0] == pair[1] ? pair[0] : 0))(0)
        .writeln;
}

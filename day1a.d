#!/usr/bin/env rdmd
import std.algorithm, std.conv, std.range, std.stdio;

void main(string[] args) @safe
{
    auto captcha = args[1];
    captcha.chain(captcha.take(1))
        .map!(d => d - '0')
        .group
        .fold!((sum, grp) => sum + (grp[1] > 1 ? grp[0] * (grp[1] - 1) : 0))(0)
        .writeln;
}

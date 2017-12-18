#!/usr/bin/env rdmd
import std.algorithm, std.conv, std.range, std.stdio;

// b inc 5 if a > 1
enum Op : string { inc = "inc", dec = "dec", }
enum Cmp : string { gt = ">", ge = ">=", eq = "==", le = "<=", lt = "<", ne = "!=", }
struct Inst { const(char)[] e1; const(char)[] op; int e2; const(char)[] c1; const(char)[] cmp; int c2; }

bool eat(ref /*in*/ scope const(ubyte)[] inp, ubyte exp)
{
    immutable res = inp.front == exp;
    if (res)
        inp.popFront;
    return res;
}

uint parseElement(ref /*in*/ scope const(ubyte)[] inp, uint score = 0)
{
    if (inp.front == '<')
        return parseGarbage(inp, score);
    assert(inp.front == '{');
    return parseGroup(inp, score + 1);
}

uint parseGarbage(ref /*in*/ scope const(ubyte)[] inp, uint score)
{
    uint cnt;
    inp.eat('<');
    while (true)
    {
        switch (inp.front)
        {
        case '!':
            inp.popFrontN(2);
            break;
        case '>':
            inp.popFront;
            return 0;
        default:
            ++cnt;
            inp.popFront;
            break;
        }
    }
}

uint parseGroup(ref /*in*/ scope const(ubyte)[] inp, uint score)
{
    uint sum;
    assert(inp.front == '{');
    inp.popFront;
    if (inp.front != '}')
    {
        do
        {
            sum += parseElement(inp, score);
        } while (inp.eat(','));
    }
    inp.popFront;
    return sum + score;
}

void main()
{
    import std.string : representation;

    const(ubyte)[] inp = stdin.readln.representation;
    inp
        .parseElement
        .writeln;
}

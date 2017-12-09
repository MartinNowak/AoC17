#!/usr/bin/env rdmd
import std.algorithm, std.conv, std.range, std.stdio;

// b inc 5 if a > 1
enum Op : string { inc = "inc", dec = "dec", }
enum Cmp : string { gt = ">", ge = ">=", eq = "==", le = "<=", lt = "<", ne = "!=", }
struct Inst { const(char)[] e1; const(char)[] op; int e2; const(char)[] c1; const(char)[] cmp; int c2; }

Inst parse(return scope const(char)[] line)
{
    import std.format : formattedRead;

    Inst inst;
    line.formattedRead!"%s %s %d if %s %s %d"(inst.tupleof);
    return inst;
}

void interpret(scope ref Inst inst, scope ref int[const char[]] regs)
{
    import std.traits : EnumMembers;

    immutable c1 = regs.get(inst.c1, 0);

    bool cond;
    final switch (cast(Cmp) inst.cmp)
    {
        foreach (cmp; EnumMembers!Cmp)
        case cmp:
        {
            cond = mixin("c1 " ~ cmp ~ " inst.c2");
            break;
        }
    }
    if (!cond)
        return;

    final switch (cast(Op) inst.op)
    {
    case Op.inc:
        regs[inst.e1] += inst.e2;
        break;
    case Op.dec:
        regs[inst.e1] -= inst.e2;
        break;
    }
}

void main()
{
    int[const char[]] registers;
    auto max = int.min;
    foreach (inst; stdin.byLine.map!parse)
    {
        inst.interpret(registers);
        max = registers.values.fold!(.max)(max);
    }
    writeln(max);
}

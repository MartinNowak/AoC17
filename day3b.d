#!/usr/bin/env rdmd
import std.algorithm, std.conv, std.math, std.range, std.stdio;

@safe:

struct Coords
{
    Coords opBinary(string op:"+")(in Coords rhs) const
    {
        return Coords(x + rhs.x, y + rhs.y);
    }

    int x, y;
}

// 0 -> 0, 1-8 -> 1, 9-24 -> 2
uint indexToRing(uint value)
{
    auto val = sqrt(double(value)).floor.lrint.to!uint;
    return (val + 1) / 2;
}

Coords toCoords(uint idx)
{
    if (idx == 0)
        return Coords(0, 0);
    immutable ring = indexToRing(idx);
    immutable inner = (2 * (ring - 1) + 1) ^^ 2;
    immutable ringidx = idx - inner;
    immutable leglen = 2 * ring;
    switch (ringidx / leglen)
    {
        /*
         *---*---*---*---*---*
         |   | p | o | t | t |
         *---*---*---*---*---*
         | l |   |   |   | h |
         *---*---*---*---*---*
         | e |   |   |   | g |
         *---*---*---*---*---*
         | f |   |   |   | r |
         *---*---*---*---*---*
         | t | b | t | t | m |
         *---*---*---*---*---*
         */
    case 0: // right
        return Coords(ring, -ring + 1 + ringidx);
    case 1: // top
        return Coords(ring - 1 - ringidx % leglen, ring);
    case 2: // left
        return Coords(-ring, ring - 1 - ringidx % leglen);
    case 3: // bottom
        return Coords(-ring + 1 + ringidx % leglen, -ring);
    default:
        assert(0);
    }
}

unittest
{
    assert(toCoords(0) == Coords(0, 0));
    assert(toCoords(1) == Coords(1, 0));
    assert(toCoords(2) == Coords(1, 1));
    assert(toCoords(3) == Coords(0, 1));
    assert(toCoords(4) == Coords(-1, 1));
    assert(toCoords(5) == Coords(-1, 0));
    assert(toCoords(6) == Coords(-1, -1));
    assert(toCoords(7) == Coords(0, -1));
    assert(toCoords(8) == Coords(1, -1));
    assert(toCoords(9) == Coords(2, -1));
    assert(toCoords(11) == Coords(2, 1));
    assert(toCoords(12) == Coords(2, 2));
    assert(toCoords(13) == Coords(1, 2));
}

struct Grid(T)
{
    this(size_t w, size_t h)
    {
        _w = w;
        _h = h;
        _data = new uint[](w * h);
    }

    ref T opIndex(in Coords coords)
    {
        return _data[toIndex(coords)];
    }

private:
    size_t toIndex(Coords coords)
    {
        immutable center = Coords(_w.to!int / 2, _h.to!int / 2);
        auto lookup = coords + center;
        assert(lookup.x < _w);
        assert(lookup.y < _h);
        immutable idx = lookup.y * _w + lookup.x;
        return idx;
    }

    T[] _data;
    size_t _w, _h;
}

static immutable neighbours = [
    Coords(1, 0),
    Coords(1, 1),
    Coords(0, 1),
    Coords(-1, 1),
    Coords(-1, 0),
    Coords(-1, -1),
    Coords(0, -1),
    Coords(1, -1),
];

void main(string[] args) @safe
{
    immutable num = args[1].to!uint - 1;
    immutable ring = indexToRing(num);
    immutable width = 2 * ring + 1;
    auto grid = Grid!uint(width, width);
    grid[Coords(0, 0)] = 1;
    foreach (uint idx; 1 .. grid._data.length.to!uint)
    {
        immutable coords = idx.toCoords;
        immutable val = neighbours
            .map!(n => grid[coords + n])
            .cache
            .filter!(v => v != 0)
            .sum;
        if (val > num + 1)
        {
            writeln("result ", val);
            break;
        }
        grid[coords] = val;
    }
}

#include "UINT100.h"

// constructor
UINT100::UINT100(unsigned int v) noexcept : value(norm(v)) {}

// explicit conversion
UINT100::operator unsigned int() const noexcept { return value; }

// compound assignment
UINT100& UINT100::operator+=(unsigned int v) noexcept {
    value = norm(static_cast<unsigned int>(value) + v);
    return *this;
}

UINT100& UINT100::operator-=(unsigned int v) noexcept {
    value = norm(static_cast<unsigned int>(value) + 100u - (v % 100u));
    return *this;
}

// prefix / postfix increment and decrement
UINT100& UINT100::operator++() noexcept { return (*this += 1u); }
UINT100 UINT100::operator++(int) noexcept { UINT100 tmp = *this; ++(*this); return tmp; }

UINT100& UINT100::operator--() noexcept { return (*this -= 1u); }
UINT100 UINT100::operator--(int) noexcept { UINT100 tmp = *this; --(*this); return tmp; }

// raw value
unsigned int UINT100::raw() const noexcept { return value; }

// arithmetic operators
UINT100 operator+(const UINT100& a, const UINT100& b) noexcept {
    return UINT100(static_cast<unsigned int>(a.value) + static_cast<unsigned int>(b.value));
}

UINT100 operator+(const UINT100& a, unsigned int b) noexcept {
    return UINT100(static_cast<unsigned int>(a.value) + b);
}

UINT100 operator+(unsigned int a, const UINT100& b) noexcept {
    return UINT100(a + static_cast<unsigned int>(b.value));
}

UINT100 operator-(const UINT100& a, const UINT100& b) noexcept {
    return UINT100(static_cast<unsigned int>(a.value) + 100u - static_cast<unsigned int>(b.value));
}

UINT100 operator-(const UINT100& a, unsigned int b) noexcept {
    return UINT100(static_cast<unsigned int>(a.value) + 100u - (b % 100u));
}

UINT100 operator-(unsigned int a, const UINT100& b) noexcept {
    return UINT100((a % 100u + 100u) - static_cast<unsigned int>(b.value));
}

// comparisons
bool operator==(const UINT100& a, const UINT100& b) noexcept { return a.value == b.value; }
bool operator!=(const UINT100& a, const UINT100& b) noexcept { return !(a == b); }
bool operator<(const UINT100& a, const UINT100& b) noexcept { return a.value < b.value; }
bool operator<=(const UINT100& a, const UINT100& b) noexcept { return a.value <= b.value; }
bool operator>(const UINT100& a, const UINT100& b) noexcept { return a.value > b.value; }
bool operator>=(const UINT100& a, const UINT100& b) noexcept { return a.value >= b.value; }
// stream output
std::ostream& operator<<(std::ostream& os, const UINT100& x) {
    return os << static_cast<unsigned int>(x.value);
}

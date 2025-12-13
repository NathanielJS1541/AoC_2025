#ifndef UINT100_H
#define UINT100_H

#include <cstdint>
#include <iostream>

class UINT100 {
private:
    uint8_t value; // stores 0..99

    static constexpr uint8_t norm(unsigned int v) noexcept {
        return static_cast<uint8_t>(v % 100u);
    }

public:
    // constructor
    UINT100(unsigned int v = 0u) noexcept;

    // explicit conversion to unsigned int
    explicit operator unsigned int() const noexcept;

    // compound assignment
    UINT100& operator+=(unsigned int v) noexcept;
    UINT100& operator-=(unsigned int v) noexcept;

    // prefix/postfix increment and decrement
    UINT100& operator++() noexcept;
    UINT100 operator++(int) noexcept;
    UINT100& operator--() noexcept;
    UINT100 operator--(int) noexcept;

    // access raw value
    unsigned int raw() const noexcept;

    // friend arithmetic operators
    friend UINT100 operator+(const UINT100& a, const UINT100& b) noexcept;
    friend UINT100 operator+(const UINT100& a, unsigned int b) noexcept;
    friend UINT100 operator+(unsigned int a, const UINT100& b) noexcept;

    friend UINT100 operator-(const UINT100& a, const UINT100& b) noexcept;
    friend UINT100 operator-(const UINT100& a, unsigned int b) noexcept;
    friend UINT100 operator-(unsigned int a, const UINT100& b) noexcept;

    // comparisons
    friend bool operator==(const UINT100& a, const UINT100& b) noexcept;
    friend bool operator!=(const UINT100& a, const UINT100& b) noexcept;
    friend bool operator<(const UINT100& a, const UINT100& b) noexcept;

    // stream output
    friend std::ostream& operator<<(std::ostream& os, const UINT100& x);
};

#endif // UINT100_H
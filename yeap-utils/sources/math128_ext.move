// SPDX-License-Identifier: BUSL-1.1
module yeap_utils::math128_ext {
    /// Returns a * b + (c-1) / c
    /// going through u256 to prevent intermediate overflow
    public fun mul_div_roundup(a: u128, b: u128, c: u128): u128 {
        // Inline functions cannot take constants, as then every module using it needs the constant
        assert!(c != 0, std::error::invalid_argument(4));
        // TODO: what if a*b + c-1 overflows u256?
        ((((a as u256) * (b as u256) + ((c as u256) - 1)) / (c as u256)) as u128)
    }

    spec mul_div_roundup {
        pragma opaque;
        // Explicit abort condition from assert
        aborts_if c == 0;

        // Overflow condition when result doesn't fit in u128
        aborts_if ((a as u256) * (b as u256) + ((c as u256) - 1)) / (c as u256) > max_u128();

        ensures result == spec_mul_div_roudup(a, b, c);
    }

    spec fun spec_mul_div_roudup(a: num, b: num, c: num): num {
        (a * b + (c - 1)) / c
    }

    spec fun max_u128(): u256 {
        340282366920938463463374607431768211455u256
    }
}

// SPDX-License-Identifier: BUSL-1.1
module yeap_irm::kinked_irm {
    use aptos_std::math128;

    #[test_only]
    use aptos_std::debug;
    #[test_only]
    use aptos_std::fixed_point64;
    #[test_only]
    use aptos_std::fixed_point64::FixedPoint64;
    #[test_only]
    use aptos_std::math_fixed64;

    // Number of seconds in a year: 86400*365.2425
    const SECONDS_IN_YEAR: u128 = 31556952;
    /// The scale for the interest rate: 2**64
    const IR_SCALE: u128 = 1 << 64;
    // Maximum value for utilization precision (using 32-bit scale)
    const UTILZATION_SCALE: u128 = 1 << 32;

    struct KinkedIRM has store, copy, drop {
        min_borrow_rate: u128,
        optimal_borrow_rate: u128,
        max_borrow_rate: u128,
        optimal_utilization: u128,
    }

    public fun new(
        min_borrow_rate: u128,
        optimal_borrow_rate: u128,
        max_borrow_rate: u128,
        optimal_utilization: u128
    ): KinkedIRM {
        KinkedIRM {
            min_borrow_rate, optimal_utilization, max_borrow_rate, optimal_borrow_rate
        }
    }

    public fun compute_ir(self: &KinkedIRM, borrowed: u128, cash: u128): u128 {
        let total_assets = borrowed + cash;

        let utilization =
            if (total_assets == 0) { 0 }
            else {
                math128::mul_div(borrowed, UTILZATION_SCALE, total_assets)
            };
        if (utilization <= self.optimal_utilization) {
            self.min_borrow_rate + math128::mul_div(
                self.optimal_borrow_rate - self.min_borrow_rate,
                utilization,
                self.optimal_utilization
            )
        } else {
            let utilization_over_kink = utilization - self.optimal_utilization;
            self.optimal_borrow_rate + math128::mul_div(
                self.max_borrow_rate - self.optimal_borrow_rate,
                utilization_over_kink,
                UTILZATION_SCALE - self.optimal_utilization
            )
        }
    }

    public fun max_borrow_rate(self: &KinkedIRM): u128 {
        self.max_borrow_rate
    }

    public fun min_borrow_rate(self: &KinkedIRM): u128 {
        self.min_borrow_rate
    }

    public fun optimal_borrow_rate(self: &KinkedIRM): u128 {
        self.optimal_borrow_rate
    }

    public fun optimal_utilization(self: &KinkedIRM): u128 {
        self.optimal_utilization
    }

    public fun set_optimal_utilization(self: &mut KinkedIRM, optimal_utilization: u128) {
        self.optimal_utilization = optimal_utilization;
    }

    public fun set_min_borrow_rate(self: &mut KinkedIRM, min_borrow_rate: u128) {
        self.min_borrow_rate = min_borrow_rate;
    }

    public fun set_optimal_borrow_rate(self: &mut KinkedIRM, optimal_borrow_rate: u128) {
        self.optimal_borrow_rate = optimal_borrow_rate;
    }

    public fun set_max_borrow_rate(self: &mut KinkedIRM, max_borrow_rate: u128) {
        self.max_borrow_rate = max_borrow_rate;
    }


    #[test_only]
    public fun generate_params(
        annual_base_rate: FixedPoint64,
        kink: FixedPoint64,
        annual_kink_rate: FixedPoint64,
        annual_full_rate: FixedPoint64
    ): KinkedIRM {
        KinkedIRM {
            min_borrow_rate: fixed_point64::multiply_u128(IR_SCALE, annual_base_rate) / SECONDS_IN_YEAR,
            optimal_borrow_rate: fixed_point64::multiply_u128(IR_SCALE, annual_kink_rate) / SECONDS_IN_YEAR,
            optimal_utilization: fixed_point64::multiply_u128(UTILZATION_SCALE, kink),
            max_borrow_rate: fixed_point64::multiply_u128(IR_SCALE, annual_full_rate) / SECONDS_IN_YEAR,
        }
    }


    #[test_only]
    /// base_rate = 0, kink = 90%, kink_rate = 10%, full_rate = 100%
    public fun genereate_test_irm(): KinkedIRM {
        let irm = generate_params(
            fixed_point64::create_from_u128(0),
            fixed_point64::create_from_rational(90, 100),
            fixed_point64::create_from_rational(10, 100),
            fixed_point64::create_from_rational(100, 100)
        );
        irm
    }

    #[test]
    fun test_kink_irm() {
        // base_rate = 0, kink = 90%, kink_rate = 10%, full_rate = 100%
        let irm = generate_params(fixed_point64::create_from_u128(0),
            fixed_point64::create_from_rational(90, 100),
            fixed_point64::create_from_rational(10, 100),
            fixed_point64::create_from_rational(100, 100)
        );
        debug::print(&irm);
        let rate = irm.compute_ir(90, 10);
        let multiplier = math_fixed64::pow(
            fixed_point64::create_from_raw_value(rate).add(fixed_point64::create_from_u128(1)),
            SECONDS_IN_YEAR as u64
        );
        debug::print(&multiplier);
    }
}

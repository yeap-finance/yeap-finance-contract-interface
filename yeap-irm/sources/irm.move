// SPDX-License-Identifier: BUSL-1.1
module yeap_irm::irm {
    use std::signer::address_of;

    use yeap_irm::kinked_irm::KinkedIRM;

    enum IRM has store, copy, drop {
        KINKED(KinkedIRM)
    }

    public fun kinked(irm: KinkedIRM): IRM {
        IRM::KINKED(irm)
    }

    public fun create_kinked_irm(
        creator: &signer,
        kinked: KinkedIRM
    ): address {
        address_of(creator)
    }


    #[view]
    /// Compute the interest rate for a vault. the interest rate must be scaled by (1<<64)
    /// vault: the address of the vault
    /// borrowed: the amount borrowed from the vault
    /// cash: the amount of cash in the vault
    public fun compute_interest_rate(irm_object: address, borrowed: u128, cash: u128): u128 { 0 }
}

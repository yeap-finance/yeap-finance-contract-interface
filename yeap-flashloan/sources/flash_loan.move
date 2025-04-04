// SPDX-License-Identifier: BUSL-1.1
module yeap_flashloan::flash_loan {
    use aptos_framework::fungible_asset;
    use aptos_framework::fungible_asset::{FungibleAsset, Metadata};
    use aptos_framework::object::address_to_object;

    use yeap_utils::object_refs::ObjRefs;

    struct FlashLoanMetadata has key, store {
        fee_rate: u128,
        obj_ref: ObjRefs,
    }

    // 1e6
    const FEE_RATE_SCALE: u128 = 1_000_000;

    // 1%
    const MAX_FEE_RATE: u128 = 10_000;

    const E_FEE_RATE_TOO_HIGH: u64 = 1;

    /// temporary struct to hold the flashloan data
    /// borrower has to call payback to resolve the loan in the same transaction
    struct FlashLoan {
        vault: address,
        debt: FungibleAsset,
        amount: u128,
        fee_rate: u128,
    }

    /// create a new flashloan object with fee rate setting
    public fun create(
        signer: &signer,
        flashloan_fee_rate: u128
    ): address {
        @0x0
    }

    public fun set_flashloan_fee_rate(
        account: &signer,
        flashloan_object: address,
        new_fee_rate: u128
    ) {}

    /// Flashloan from the vault
    public fun loan(
        vault_object: address,
        amount: u128,
    ): (FlashLoan, FungibleAsset) acquires FlashLoanMetadata {
        let flashloan = FlashLoan {
            vault: vault_object,
            debt: fungible_asset::zero(address_to_object<Metadata>(vault_object)),
            amount,
            fee_rate: 0
        };
        (flashloan, fungible_asset::zero(address_to_object<Metadata>(vault_object)))
    }

    /// Payback the flashloan
    public fun payback(
        flashloan: FlashLoan,
        asset: FungibleAsset
    ): FungibleAsset {
        asset
    }
}

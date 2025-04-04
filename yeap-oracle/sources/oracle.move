// SPDX-License-Identifier: BUSL-1.1
module yeap_oracle::oracle {
    use std::option;
    use std::signer::address_of;
    use aptos_std::smart_table::SmartTable;

    use yeap_utils::object_refs::ObjRefs;

    use pyth::i64;
    use pyth::price_identifier::PriceIdentifier;

    struct PythConfig has copy, drop, store {
        pyth_id: PriceIdentifier,
        max_age_in_seconds: u64
    }

    struct FixedPrice has store, drop, copy {
        price: u128,
        expo: i64::I64
    }

    struct OracleConfiguration has key, store {
        object_refs: ObjRefs,
        config_map: SmartTable<address, PythConfig>,
        fixed_price: SmartTable<address, FixedPrice>
    }

    #[event]
    struct OracleConfigUpdated has store, drop {
        oracle: address,
        asset_object_address: address,
        pyth_id: PriceIdentifier,
        max_age_in_seconds: u64
    }

    const E_PRICE_FEED_NOT_FOUND: u64 = 1;
    const E_NOT_OWNER: u64 = 2;


    public fun create(account: &signer): address {
        address_of(account)
    }


    public fun set_pyth_oracle(
        account: &signer,
        oracle_object_address: address,
        asset_object_address: address,
        pyth_id: vector<u8>,
        max_age_in_seconds: u64
    ) {}

    #[test_only]
    public fun set_fixed_price(
        oracle_object_address: address,
        asset_object_address: address,
        price: u128,
        expo: i64::I64
    ) {}

    /// Get the price of an asset from the oracle.
    /// returns quote price
    public fun get_quote(
        oracle_address: address,
        asset_object_address: address,
        unit_decimals: u8,
        amount: u128
    ): option::Option<u128> {
        option::none()
    }

    #[view]
    public fun get_quote_view(
        oracle_address: address,
        asset_object_address: address,
        unit_decimals: u8,
        amount: u128
    ): option::Option<u128> {
        get_quote(oracle_address, asset_object_address, unit_decimals, amount)
    }


    #[view]
    public fun get_pyth_id(
        oracle_object_address: address,
        asset_object_address: address
    ): vector<u8> {
        vector[]
    }
}

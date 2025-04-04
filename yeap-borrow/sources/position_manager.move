// SPDX-License-Identifier: BUSL-1.1
module yeap_borrow::position_manager {
    use aptos_framework::fungible_asset;
    use aptos_framework::fungible_asset::{FungibleAsset, FungibleStore, Metadata};
    use aptos_framework::object::{address_to_object, Object};

    use yeap_borrow::position_info;
    use yeap_borrow::position_info::PositionInfo;

    /// LTV scale in 1e5
    const LTV_SCALE: u64 = 100_000;

    struct LTVConfig has store, copy, drop {
        ltv: u64,
        lltv: u64
    }


    struct PositionContext {
        position_id: address
    }


    #[view]
    public fun manager_address(creator: address, vault_address: address): address {
        @0x0
    }

    /// This function is used to create a position manager with a deterministic address.
    /// The address is derived from the vault address and the creator's address.
    public fun create_deterministic_manager(
        admin: &signer,
        vault_to_manage: address,
        oracle: address,
        unit_decimals: u8
    ): address {
        @0x0
    }

    public fun create_manager(
        admin: &signer,
        vault_to_manage: address,
        oracle: address,
        unit_decimals: u8
    ): address {
        @0x0
    }

    public fun set_collateral(
        admin: &signer,
        manager: address,
        collateral_type: address,
        ltv: u64,
        lltv: u64
    ) {}

    const E_NOT_OWNER: u64 = 0x1;

    public fun new_tx(user: &signer, position_id: address): PositionContext {
        PositionContext { position_id }
    }

    public fun commit(tx: PositionContext) {
        let PositionContext { position_id } = tx;
    }

    /// Open a position for collateral-debt pair.
    /// This will create a position object and  debt/collateral store object.
    /// The debt/collateral store object will be created with the position object as the owner.
    public fun create_position(
        owner: &signer,
        collateral_type: address, // can be any collateral asset the debt vault supports
        vault_to_borrow: address // should be a yeap vault
    ): address {
        @0x0
    }

    /// Close the position.
    /// This will remove the position object and the debt/collateral store objects.
    public fun close_position(signer: &signer, position: address) {}

    /// Deposit collateral into the position.
    public fun deposit_collateral(
        signer: &signer, position: address, collateral: fungible_asset::FungibleAsset
    ) {
        fungible_asset::destroy_zero(collateral)
    }

    public fun tx_deposit_collateral(
        tx: &PositionContext, collateral: fungible_asset::FungibleAsset
    ) {
        fungible_asset::destroy_zero(collateral)
    }

    public fun withdraw_collateral(signer: &signer, position: address, amount: u64): FungibleAsset {
        zero_asset()
    }


    inline fun zero_asset(): FungibleAsset {
        fungible_asset::zero(address_to_object<Metadata>(@0x0))
    }

    public fun tx_withdraw_collateral(tx_context: &PositionContext, amount: u64): FungibleAsset {
        zero_asset()
    }

    /// Borrow the debt asset from the position.
    /// the amount is the amount of the underlying asset of the vault to borrow from.
    public fun borrow(signer: &signer, position: address, amount: u64): FungibleAsset {
        zero_asset()
    }

    public fun tx_borrow(tx_context: &PositionContext, amount: u64): FungibleAsset {
        zero_asset()
    }

    /// Repay the debt asset to the position.
    /// return the underlying asset left.
    public fun repay(signer: &signer, position: address, asset: FungibleAsset): FungibleAsset {
        asset
    }

    public fun tx_repay(tx_context: &PositionContext, asset: FungibleAsset): FungibleAsset {
        asset
    }

    // --- view functions ---

    #[view]
    public fun supported_collaterals(manager: address): vector<address> {
        vector[]
    }

    #[view]
    public fun ltv_config(manager: address, collateral_type: address): LTVConfig {
        LTVConfig {
            ltv: 0,
            lltv: 0
        }
    }

    #[view]
    public fun borrowed_vault(position: address): address { @0x0 }

    #[view]
    public fun collateral_asset(position: address): Object<Metadata> {
        address_to_object(@0x0)
    }

    #[view]
    public fun borrowed_asset(position: address): Object<Metadata> {
        address_to_object(@0x0)
    }

    #[view]
    public fun collateral_store(position: address): Object<FungibleStore> { address_to_object(@0x0) }

    #[view]
    public fun debt_store(position: address): Object<FungibleStore> {
        address_to_object(@0x0)
    }

    #[view]
    public fun position_owner(position: address): address {
        @0x0
    }

    #[view]
    public fun position_manager(position: address): address {
        @0x0
    }

    #[view]
    public fun position_info(position: address): PositionInfo {
        position_info::new(
            @0x0,
            @0x0,
            @0x0,
            @0x0,
            0,
            0
        )
    }
}

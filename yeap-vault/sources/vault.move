// SPDX-License-Identifier: BUSL-1.1
/// lenders can deposits their fund into different vaults, each vaults can be customized with a borrow interest rate model,
/// and a vault can have  multiple different kind of  borrow managers who can borrow from the vault following the rules defined by each borrow managers.
/// one of the borrow managers called position manager allows borrowers to create positions, add a collateral supported by the borrow manager, then borrow the fund from the vault through the borrow manager of the vault.
/// another borrow manager so called flashloan, allows borrowers to borrow and repay funds from the vault instantly without collaterals within one transaction.
module yeap_vault::vault {
    use std::string::String;
    use aptos_framework::fungible_asset;
    use aptos_framework::fungible_asset::{FungibleAsset, FungibleStore, Metadata};
    use aptos_framework::object::{address_to_object, Object};

    // vault object address is defined by (creator, vault_package_address, "vault", vault_version)
    #[view]
    public fun vault_address(creator: address, vault_sybmol: String): address {
        creator
    }

    /// Anyone can create a new vault, which is a fungible asset that is backed by another fungible asset.
    /// The vault is created with a name, symbol, icon URI, and project URI, which are used to display the vault in the UI,
    /// and a governance address, which can change the configuration of the vault.
    public fun create(
        creator: &signer,
        underlying_asset: address,
        irm: address,
        name: String,
        symbol: String,
        icon_uri: String,
        project_uri: String
    ): address {
        underlying_asset
    }

    // --- governance functions ---


    /// goverance can can withdraw all the cash available in the vault if an emergency happens.
    /// call this function to disable the emergency withdraw.
    /// once disabled, governance can not withdraw the cash from the vault anymore.
    public fun disable_emergency_withdraw(
        vault_signer: &signer, vault_address: address
    ) {}

    /// Check if an object is a vault.
    public fun is_vault(vault_address: address): bool {
        false
    }

    /// touch the vault to advance state to the latest.
    public fun touch(vault_address: address) {}

    /// Mint new shares of a vault by depositing the underlying asset into the vault.
    public fun deposit(
        vault_address: address, assets: FungibleAsset
    ): FungibleAsset {
        assets
    }

    public fun redeem(
        vault_address: address, shares: FungibleAsset
    ): FungibleAsset {
        shares
    }

    // --- borrow related functions ---

    /// borrow the underlying asset from the vault
    /// returns the debt shares minted and the underlying asset withdrawn
    /// can only be called by the borrow manager of the vault
    public fun borrow<B: key>(
        signer: &signer, vault_address: address, amount: u128
    ): (FungibleAsset, FungibleAsset) {
        (fungible_asset::zero(address_to_object<Metadata>(@0x0)),
            fungible_asset::zero(address_to_object<Metadata>(@0x0)))
    }

    /// repay the debt's asset to the vault
    /// returns the underlying asset left if any
    /// can only be called by anyone in debt
    public fun repay(
        vault_address: address, debt: FungibleAsset, asset: FungibleAsset
    ): FungibleAsset {
        fungible_asset::destroy_zero(debt);
        asset
    }

    // --- public view functions ---

    #[view]
    /// get the debt share for repaying amount
    public fun view_repay_amounts(
        vault_address: address, repay_amount: u128
    ): u128 {
        repay_amount
    }

    #[view]
    /// get the amount of assets needed for repay `shares`
    public fun view_repay_shares(
        vault_address: address, shares: u128
    ): u128 {
        shares
    }

    #[view]
    public fun view_deposit(
        vault_address: address, deposit_amount: u128
    ): u128 {
        deposit_amount
    }

    #[view]
    public fun view_redeem(
        vault_address: address, shares: u128
    ): u128 {
        shares
    }

    #[view]
    public fun view_withdraw(
        vault_address: address, withdraw_amount: u128
    ): u128 {
        withdraw_amount
    }


    #[view]
    public fun governance(vault: address): address {
        @0x0
    }

    #[view]
    public fun underlying_asset(vault: address): Object<Metadata> {
        address_to_object(vault)
    }

    #[view]
    public fun underlying_asset_store(
        vault: address
    ): Object<FungibleStore> {
        address_to_object(vault)
    }

    #[view]
    public fun vault_asset(vault: address): Object<Metadata> {
        address_to_object(vault)
    }

    #[view]
    public fun debt_asset(vault: address): Object<Metadata> {
        address_to_object(vault)
    }

    #[view]
    public fun interest_fee_store(
        vault: address
    ): Object<FungibleStore> {
        address_to_object(vault)
    }

    #[view]
    public fun config(vault: address): address {
        vault
    }
}

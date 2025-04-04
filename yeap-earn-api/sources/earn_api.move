// SPDX-License-Identifier: BUSL-1.1
module yeap_earn_api::earn_api {

    use std::signer::address_of;
    use std::string::String;
    use aptos_framework::fungible_asset::Metadata;
    use aptos_framework::object;
    use aptos_framework::primary_fungible_store;

    use yeap_vault::vault;

    /// 2^64 - 1
    const U64_MAX: u64 = 18446744073709551615;

    /// create a vault
    /// the `creator` is the signer of the transaction
    /// the `underlying_asset` is the asset type of the underlying asset
    /// the `irm` is the IRMConfig object
    /// the `name` is the name of the vault
    /// the `symbol` is the symbol of the vault
    /// the `icon_uri` is the icon URI of the vault
    /// the `project_uri` is the project URI of the vault
    public entry fun create_vault(
        creator: &signer,
        underlying_asset: address,
        irm: address,
        name: String,
        symbol: String,
        icon_uri: String,
        project_uri: String
    ) {
        vault::create(creator, underlying_asset, irm, name, symbol, icon_uri, project_uri);
    }

    /// deposit underlying assets into the vault
    /// the amount is the amount of underlying assets
    /// if the amount is u64::MAX, it will withdraw all the underlying assets from the user's account
    public entry fun deposit(
        user: &signer,
        vault: address,
        amount: u64
    ) {
        let underlying_asset = vault::underlying_asset(vault);
        if (amount == U64_MAX) {
            amount = primary_fungible_store::balance(address_of(user), underlying_asset);
        };

        let assets = primary_fungible_store::withdraw(user, underlying_asset, amount);

        let shares = vault::deposit(
            vault,
            assets
        );
        primary_fungible_store::deposit(address_of(user), shares);
    }

    /// redeem shares from the vault
    /// the shares is the amount of shares to redeem
    /// if the shares is u64::MAX, it will redeem all the shares from the user's account
    public entry fun redeem(
        user: &signer,
        vault: address,
        shares: u64
    ) {
        let vault_asset = vault::vault_asset(vault);
        if (shares == U64_MAX) {
            shares = primary_fungible_store::balance(address_of(user), vault_asset);
        };

        let shares = primary_fungible_store::withdraw(user, vault_asset, shares);

        let underlyings = vault::redeem(vault, shares);

        primary_fungible_store::deposit(address_of(user), underlyings);
    }

    /// withdraw shares from the vault
    /// the amount is the amount of assets to withdraw
    /// if the amount is u64::MAX, it will withdraw all the shares from the user's account
    /// the shares are burned and the underlying assets are redeemed
    public entry fun withdraw(
        user: &signer,
        vault: address,
        amount: u64
    ) {
        let shares_to_burn = if (amount == U64_MAX) {
            primary_fungible_store::balance(address_of(user), vault::vault_asset(vault)) as u128
        } else {
            vault::view_withdraw(vault, amount as u128)
        };

        let shares = primary_fungible_store::withdraw(
            user,
            object::address_to_object<Metadata>(vault),
            shares_to_burn as u64
        );

        let underlyings = vault::redeem(vault, shares);

        primary_fungible_store::deposit(address_of(user), underlyings);
    }
}

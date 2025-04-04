// SPDX-License-Identifier: BUSL-1.1
module yeap_borrow_api::borrow_api {
    use std::signer::address_of;
    use aptos_framework::fungible_asset;
    use aptos_framework::fungible_asset::{FungibleAsset, Metadata};
    use aptos_framework::object::Object;
    use aptos_framework::primary_fungible_store;

    use yeap_borrow::position_manager;

    const U64_MAX: u64 = 18446744073709551615;

    /// Adds collateral and borrows an asset.
    /// The `user` is the signer of the transaction.
    /// The `borrowed_vault` is the vault from which the asset is borrowed.
    /// The `collateral_asset_type` is the asset type of the collateral.
    /// The `collateral_amount` is the amount of collateral to be added.
    /// The `borrrow_amount` is the amount of asset to be borrowed.
    /// This will create a new position.
    public entry fun add_collateral_and_borrow(
        user: &signer,
        collateral_asset_type: address,
        borrowed_vault: address,
        collateral_amount: u64,
        borrrow_amount: u64
    ) {
        let position = yeap_borrow::position_manager::create_position(user, collateral_asset_type, borrowed_vault);

        add_collateral_and_borrow_more(user, position, collateral_amount, borrrow_amount);
    }

    /// Adds collateral and borrows more of an asset.
    /// The `user` is the signer of the transaction.
    /// The `position` is the position object.
    /// The `collateral_amount` is the amount of collateral to be added.
    /// The `borrrow_amount` is the amount of asset to be borrowed.
    public entry fun add_collateral_and_borrow_more(
        user: &signer,
        position: address,
        collateral_amount: u64,
        borrrow_amount: u64
    ) {
        let collateral = withdraw_asset(
            user,
            position_manager::collateral_asset(position),
            collateral_amount
        );
        yeap_borrow::position_manager::deposit_collateral(user, position, collateral);

        if (borrrow_amount != 0) {
            primary_fungible_store::deposit(
                address_of(user),
                yeap_borrow::position_manager::borrow(user, position, borrrow_amount)
            );
        }
    }


    /// Repays the borrowed asset and withdraws the collateral.
    /// The `user` is the signer of the transaction.
    /// The `position` is the position object.
    /// The `repayAmount` is the amount of asset to be repaid.
    /// The `withdarawalAmount` is the amount of collateral to be withdrawn.
    public entry fun repay_and_withdraw_collateral(
        user: &signer,
        position: address,
        repayAmount: u64,
        withdarawalAmount: u64
    ) {
        repay(user, position, repayAmount);
        withdraw_collateral(user, position, withdarawalAmount)
    }

    /// Withdraws the collateral from the user's account.
    /// If the amount is `u64::MAX`, it withdraws the entire balance.
    /// The `user` is the signer of the transaction.
    /// The `position` is the position object.
    /// The `amount` is the amount of collateral to be withdrawn.
    /// This will withdraw the collateral from the position and deposit it into the user's account.
    /// The `position` must be a valid position object.
    /// The `amount` must be less than or equal to the balance of the collateral asset in the position.
    public entry fun withdraw_collateral(
        user: &signer,
        position: address,
        amount: u64
    ) {
        let withdraw_amount = if (amount == U64_MAX) {
            fungible_asset::balance(yeap_borrow::position_manager::collateral_store(position))
        } else {
            amount
        };

        if (withdraw_amount == 0) {
            return
        };
        let collateral = yeap_borrow::position_manager::withdraw_collateral(user, position, withdraw_amount);
        primary_fungible_store::deposit(address_of(user), collateral);
    }

    /// Repays the borrowed asset.
    /// The `user` is the signer of the transaction.
    /// The `position` is the position object.
    /// The `amount` is the amount of asset to be repaid.
    /// This will withdraw the asset from the user's account and repay the borrowed amount.
    /// The `position` must be a valid position object.
    /// The `amount` must be less than or equal to the balance of the borrowed asset in the position.
    /// The `amount` can be set to `u64::MAX` to repay the entire borrowed amount.
    public entry fun repay(
        user: &signer,
        position: address,
        amount: u64
    ) {
        if (amount == 0) {
            return
        };
        let borrowed_asset = yeap_borrow::position_manager::borrowed_asset(position);
        let asset = withdraw_asset(user, borrowed_asset, amount);

        primary_fungible_store::deposit(address_of(user), yeap_borrow::position_manager::repay(user, position, asset));
    }

    /// Withdraws the asset from the user's account.
    /// If the amount is `u64::MAX`, it withdraws the entire balance.
    fun withdraw_asset(
        user: &signer,
        asset: Object<Metadata>,
        amount: u64
    ): FungibleAsset {
        if (amount == U64_MAX) {
            amount = primary_fungible_store::balance(address_of(user), asset);
        };
        primary_fungible_store::withdraw(user, asset, amount)
    }
}

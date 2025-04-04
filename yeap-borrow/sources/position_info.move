// SPDX-License-Identifier: BUSL-1.1
module yeap_borrow::position_info {
    struct PositionInfo has copy, drop {
        /// The address of the owner.
        owner: address,
        /// The address of the vault.
        borrowed_vault: address,
        borrowed_asset: address,
        collateral_asset: address,
        collateral_amount: u128,
        /// The amount of debt shares owned by the position.
        debt_shares: u128,
    }

    public fun new(
        owner: address,
        borrowed_vault: address,
        borrowed_asset: address,
        collateral_asset: address,
        collateral_amount: u128,
        debt_shares: u128
    ): PositionInfo {
        PositionInfo {
            owner,
            borrowed_vault,
            borrowed_asset,
            collateral_asset,
            collateral_amount,
            debt_shares
        }
    }

    public fun owner(self: &PositionInfo): address {
        self.owner
    }
    public fun borrowed_vault(self: &PositionInfo): address {
        self.borrowed_vault
    }
    public fun borrowed_asset(self: &PositionInfo): address {
        self.borrowed_asset
    }

    public fun collateral_asset(self: &PositionInfo): address {
        self.collateral_asset
    }
    public fun collateral_amount(self: &PositionInfo): u128 {
        self.collateral_amount
    }
    public fun debt_shares(self: &PositionInfo): u128 {
        self.debt_shares
    }
}

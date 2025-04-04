module yeap_leverage::leverager_api {

    const E_AMOUNT_OUT_NOT_ENOUGH: u64 = 0x1;

    /// Create a leverage position by borrowing an asset and swapping it for collateral.
    public entry fun open_leverage_position_by_hyper(
        user: &signer,
        collateral_vault: address,
        debt_vault: address,
        collateral_amount: u64,
        short_amount: u64,
        swap_path: vector<address>,
        amount_out_min: u64,
    ) {}
}

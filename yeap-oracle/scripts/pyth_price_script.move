// SPDX-License-Identifier: BUSL-1.1
script {
    use pyth::price_identifier;
    use pyth::pyth;

    fun show_pyth_price(feed_id: vector<u8>) {
        // Fetch the price from the Pyth oracle
        let pyth_price = pyth::get_price_unsafe(price_identifier::from_byte_vec(feed_id));
        aptos_std::debug::print(&pyth_price);
    }
}

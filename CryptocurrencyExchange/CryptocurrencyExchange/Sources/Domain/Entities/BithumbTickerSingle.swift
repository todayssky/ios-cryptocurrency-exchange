//
//  BithumbTickerSingle.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/05.
//

import Foundation

struct BithumbTickerSingle {
    let name: String
    let closingPrice: Double
    let changeRate: Double
}

extension BithumbTickerSingle {
    func toCoinItemState(isLiked: Bool) -> CoinItemState {
        return CoinItemState(
            name: name,
            price: closingPrice,
            changeRate: changeRate,
            isLiked: isLiked,
            symbol: name + "_KRW"
        )
    }
}

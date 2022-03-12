//
//  CoinListView.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/01.
//

import Combine
import SwiftUI

import ComposableArchitecture
import IdentifiedCollections

struct CoinListView: View {
    let store: Store<CoinListState, CoinListAction>
    
    var body: some View {
        ZStack(alignment: .top) {
            List {
                ForEachStore(
                    self.store.scope(
                        state: \.items,
                        action: CoinListAction.coinItem(id:action:)
                    ),
                    content: { itemStore in
                        NavigationLink(destination: {
                            WithViewStore(itemStore.scope(state: \.symbol)) { viewItemStore in
                                CoinDetailView(
                                    store: Store(
                                        initialState: CoinDetailState(symbol: viewItemStore.state),
                                        reducer: coinDetailReducer,
                                        environment: CoinDetailEnvironment()
                                    )
                                )
                            }
                        }) {
                            CoinItemView(store: itemStore)
                        }
                    }
                )
            }
            .listStyle(.plain)
            .buttonStyle(.plain)
            .onAppear {
                ViewStore(store).send(.onAppear)
            }
            .onDisappear {
                ViewStore(store).send(.onDisappear)
            }
            WithViewStore(
                store.scope(state: \.toastMessage)
            ) { viewStore in
                if let toastMessage = viewStore.state {
                    ToastView(message: toastMessage)
                }
            }
        }
        .navigationTitle("목록")
    }
}

extension IdentifiedArray where ID == CoinItemState.ID, Element == CoinItemState {
    static let mock: Self = [
        CoinItemState(
            rank: nil,
            name: "비트코인",
            price: 78427482.42,
            changeRate: 1.24,
            isLiked: false,
            symbol: "BTC_USD"
        ),
        CoinItemState(
            rank: nil,
            name: "이더리움",
            price: 78427482.42,
            changeRate: -1.24,
            isLiked: true,
            symbol: "ETH_USD"
        )
    ]
}

struct CoinListView_Previews: PreviewProvider {
    static var previews: some View {
        CoinListView(
            store: Store(
                initialState: CoinListState(items: .mock),
                reducer: coinListReducer,
                environment: CoinListEnvironment(
                    coinListUseCase: {
                        CoinListUseCase()
                    },
                    toastClient: .live
                )
            )
        )
            .preferredColorScheme(.dark)
    }
}

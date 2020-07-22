//
//  LeaderboardPage.swift
//  Undersea
//
//  Created by Vekety Robin on 2020. 07. 21..
//  Copyright © 2020. Vekety Robin. All rights reserved.
//

import SwiftUI

extension Leaderboard {

    struct LeaderboardPage: View {
        
        lazy var interactor: Interactor = setInteractor()
        var setInteractor: (()->Interactor)!
        
        @ObservedObject var viewModel: ViewModelType
        
        var usecaseHandler: ((Leaderboard.Usecase) -> Void)?
        
        @State private var userName: String = ""
        
        private var closeButton: some View {
            LeaderboardCloseButton(action: {
                RootPageManager.shared.leaderboardVisible = false
            })
        }
        
        private var attackButton: some View {
            LeaderboardAttackButton(action: {
                RootPageManager.shared.currentSubPage = TabPage.attack
                RootPageManager.shared.leaderboardVisible = false
            })
        }
        
        private var loadingIndicator: some View {
            /*Rectangle()
                .fill(Color.white)
                .frame(width: 20.0, height: 20.0, alignment: .center)*/
            VStack {
                ActivityIndicator(isAnimating: $viewModel.isLoading, style: .medium, color: UIColor.white)
            }.frame(minWidth: 0.0, maxWidth: .infinity, alignment: .center)
        }
        
        var body: some View {
            NavigationView {
                VStack {
                    SeaInputField(placeholder: "Felhasznalonev", inputText: $userName, backgroundColor: Colors.searchFieldBackground, keyboardType: UIKeyboardType.webSearch, onEditingChanged: { editing in
                        if !editing {
                            self.usecaseHandler?(.load(self.userName))
                        }
                    })
                        .padding([.horizontal, .top])
                    
                    List {
                        ForEach(viewModel.userList) { user in
                            VStack(alignment: .leading, spacing: 0.0) {
                                Text(user.userName)
                                    .foregroundColor(Color.white)
                                    .padding(.vertical)
                                    .onAppear(perform: {
                                        if self.viewModel.userList.last?.id == user.id {
                                            self.usecaseHandler?(.loadMore(self.userName))
                                        }
                                    })
                                Divider()
                                    .background(Colors.separatorColor)
                            }.listRowInsets(EdgeInsets(top: 0.0, leading: 16.0, bottom: 0.0, trailing: 16.0))
                        }
                        
                        if viewModel.isLoading {
                            loadingIndicator
                        }
                    }.pullToRefresh(isShowing: $viewModel.isRefreshing) {
                        self.usecaseHandler?(.load(self.userName))
                    }
                }
                .navigationBarTitle("Ranglista", displayMode: .inline)
                .navigationBarItems(leading: closeButton, trailing: attackButton)
                .background(Colors.backgroundColor)
                .navigationBarColor(Colors.navBarBackgroundColor)
            }
            .onAppear {
                self.usecaseHandler?(.load(self.userName))
            }
        }
    }
}

/*struct LeaderboardPage_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardPage()
    }
}*/
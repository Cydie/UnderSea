//
//  LeaderboardAttackButton.swift
//  Undersea
//
//  Created by Vekety Robin on 2020. 07. 21..
//  Copyright © 2020. Vekety Robin. All rights reserved.
//

import SwiftUI

struct LeaderboardAttackButton: View {
    
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Rectangle()
                .fill(Color.clear)
        }.frame(width: 25.0, height: 25.0)
        .background(
            LinearGradient(gradient: Gradient(colors: [Colors.cyanDark, Colors.cyan, Colors.cyanLight]), startPoint: .bottom, endPoint: .top)
        )
        .mask(SVGImage(svgPath: R.file.attackSvg()!))
    }
}

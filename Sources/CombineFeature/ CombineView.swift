//
//   CombineView.swift
//  Menata
//
//  Created by Muhamad Azis on 19/06/25.
//

import SwiftUI

struct CombineView: View {
    let project: Project
    
    var body: some View {
        VStack {
            CombineHeaderView(project: Project)
            Text("This is Combine View")
                .font(.largeTitle)
                .padding()
        }
    }
}

#Preview {
    CombineView()
}

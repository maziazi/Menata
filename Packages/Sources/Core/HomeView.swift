//
//  HomeView.swift
//  Menata
//
//  Created by Muhamad Azis on 16/06/25.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedSegment = 0
    private let segments = ["Room", "Object"]
    
    var body: some View {
        VStack {
            HStack {
                Text("Home")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal, 25)
            .padding(.top, 10)
            .padding(.bottom, 15)
        }
        .background(Color.orange)
                        
        VStack {
            Picker("View Mode", selection: $selectedSegment) {
                ForEach(0..<segments.count, id: \.self) { index in
                    Text(segments[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .padding(.top, 15)
                            
            Spacer()
                            
            VStack {
                Image(systemName: selectedSegment == 0 ? "house" : "cube")
                    .font(.system(size: 50))
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                                
                Text(selectedSegment == 0 ? "No Room has been scanned" : "No Object has been scanned")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
                    
            Spacer()
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    HomeView()
}

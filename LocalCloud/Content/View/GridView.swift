//
//  GridView.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 15.08.2022.
//

import SwiftUI

struct GridView: View {
//    @ObservedObject var viewModel: GridViewViewModel
    private var data: [Int] = Array(1...20)
    private let colors: [Color] = [.red, .green, .blue, .yellow]
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 100))
    ]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                ForEach(data, id: \.self) { number in
                    ZStack {
                        Rectangle()
                            .frame(width: 100, height: 100)
                            .foregroundColor(colors[number%4])
                            .cornerRadius(30)
                        Text("\(number)")
                            .foregroundColor(.white)
                            .font(.system(size: 80, weight: .medium, design: .rounded))
                    }
                }
            }
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView()
    }
}

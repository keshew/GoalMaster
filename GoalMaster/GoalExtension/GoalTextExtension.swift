import SwiftUI

extension Text {
    func Open(size: CGFloat,
             color: Color = .white)  -> some View {
        self.font(.custom("OpenSans-Regular", size: size))
            .foregroundColor(color)
    }
    
    func OpenBold(size: CGFloat,
             color: Color = .white)  -> some View {
            self.font(.custom("OpenSans-Regular", size: size).weight(.heavy))
            .foregroundColor(color)
    }
}

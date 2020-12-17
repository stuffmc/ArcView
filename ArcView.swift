//
//  ArcViewApp.swift
//  ArcView
//
//  Created by StuFF mc on 17.12.20.
//

import SwiftUI

@main
struct ArcViewApp: App {
    var body: some Scene {
        WindowGroup {
            ArcView(filledSlice: 0.7)
        }
    }
}

struct ArcShape: Shape {
    var start: Double
    var end: Double
    var width: CGFloat
    var roundCorners: Bool
    var animatableData: Double {
        get { end }
        set { end = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(center.x, center.y) - width
        let offset: Double = roundCorners ? (Double(width) * 180) / (Double(radius) * Double.pi) : 0.0
        let newStart = start + offset
        let newEnd = end - offset
        var path = Path()
        path.add(center: center,
                 radius: radius,
                 start: newStart,
                 end: max(newStart, newEnd),
                 clockwise: false)
        let strokeStyle = StrokeStyle(lineWidth: width, lineCap: roundCorners ? .round : .butt)
        return path.strokedPath(strokeStyle)
    }
}

struct ArcView: View {
    private let minimumValue: Double = 0.01
    private let start: Double = -90.0
    private let end: Double
    private let fullEnd: Double = 270
    private let filledSlice: Double
    private let colors: [Color] = [.red, .green, .blue]
    private let angularGradient: AngularGradient
    var width: CGFloat

    init(filledSlice: Double, width: CGFloat = 6) {
        self.width = width
        self.filledSlice = filledSlice >= minimumValue ? filledSlice : 0.0
        self.end = ((self.fullEnd - self.start) * self.filledSlice) + self.start
        self.angularGradient = AngularGradient(gradient: Gradient(colors: self.colors),
                                               center: .center,
                                               startAngle: .degrees(self.start),
                                               endAngle: .degrees(self.fullEnd))
    }

    var body: some View {
        ZStack {
            ArcShape(start: self.start, end: self.fullEnd, width: self.width, roundCorners: false)
                .stroke(lineWidth: self.width)
                .foregroundColor(Color.gray)
                .opacity(0.2)
            ArcShape(start: self.start, end: self.end, width: self.width, roundCorners: true)
                .stroke(self.angularGradient, lineWidth: self.width)
        }
    }
}

extension GeometryProxy {
    var center: CGPoint { CGPoint(x: size.height / 2, y: size.height / 2) }
    var radius: CGFloat { size.width / 2 }
}

private extension Path {
    mutating func add(center: CGPoint, radius: CGFloat, start: Double, end: Double, clockwise: Bool) {
        addArc(center: center, radius: radius, startAngle: Angle(degrees: start), endAngle: Angle(degrees: end), clockwise: clockwise)
    }
}

#if DEBUG
struct ArcView_Previews: PreviewProvider {

    static var previews: some View {
       Group {
        ArcView(filledSlice: 0.9)
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
            .previewDisplayName("iPhone SE")

        ArcView(filledSlice: 1.0)
             .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
             .previewDisplayName("iPhone XS Max")
       }
       .preferredColorScheme(.dark)
    }
}
#endif


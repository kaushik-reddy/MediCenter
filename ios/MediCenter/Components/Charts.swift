import SwiftUI

struct GaugeRingView: View {
    let percent: Int
    var color: Color = Theme.green
    var size: CGFloat = 110
    var label: String? = nil
    var sub: String? = nil
    var body: some View {
        ZStack {
            Circle().stroke(Theme.border, lineWidth: 11)
            Circle().trim(from: 0, to: CGFloat(percent) / 100)
                .stroke(color, style: StrokeStyle(lineWidth: 11, lineCap: .round))
                .rotationEffect(.degrees(-90))
            VStack(spacing: 1) {
                if let label { Text(label).font(.system(size: 22, weight: .heavy)).foregroundStyle(Theme.text) }
                if let sub { Text(sub).font(.system(size: 10.5)).foregroundStyle(Theme.textMuted) }
            }
        }
        .frame(width: size, height: size)
    }
}

struct DonutSegment { let value: Double; let color: Color }

struct DonutView: View {
    let segments: [DonutSegment]
    var size: CGFloat = 110
    var centerLabel: String? = nil
    var centerSub: String? = nil
    private var total: Double { max(segments.reduce(0) { $0 + $1.value }, 1) }
    var body: some View {
        ZStack {
            ForEach(0..<segments.count, id: \.self) { i in
                let start = segments[0..<i].reduce(0) { $0 + $1.value } / total
                let end = start + segments[i].value / total
                Circle().trim(from: start, to: end)
                    .stroke(segments[i].color, lineWidth: 16)
                    .rotationEffect(.degrees(-90))
            }
            VStack(spacing: 1) {
                if let centerLabel { Text(centerLabel).font(.system(size: 20, weight: .heavy)).foregroundStyle(Theme.text) }
                if let centerSub { Text(centerSub).font(.system(size: 10)).foregroundStyle(Theme.textMuted) }
            }
        }
        .frame(width: size, height: size)
    }
}

struct BarsView: View {
    let data: [Double]
    let labels: [String]
    var colors: [Color]? = nil
    var maxV: Double = 100
    var suffix: String = "%"
    var body: some View {
        HStack(alignment: .bottom, spacing: 6) {
            ForEach(0..<data.count, id: \.self) { i in
                VStack(spacing: 4) {
                    Text("\(Int(data[i]))\(suffix)").font(.system(size: 9, weight: .semibold)).foregroundStyle(Theme.textMuted)
                    GeometryReader { geo in
                        VStack {
                            Spacer(minLength: 0)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(colors?[i] ?? Theme.brand500)
                                .frame(height: geo.size.height * CGFloat(data[i] / maxV))
                        }
                    }
                    Text(labels[i]).font(.system(size: 10)).foregroundStyle(Theme.textMuted)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 120)
    }
}

struct AreaLineView: View {
    let data: [Double]
    var color: Color = Theme.brand500
    var height: CGFloat = 110
    var body: some View {
        GeometryReader { geo in
            let maxV = data.max() ?? 1
            let minV = data.min() ?? 0
            let range = max(maxV - minV, 1)
            let w = geo.size.width
            let h = geo.size.height
            let step = w / CGFloat(max(data.count - 1, 1))
            let pts = data.enumerated().map { (i, v) in
                CGPoint(x: CGFloat(i) * step, y: h - CGFloat((v - minV) / range) * (h - 10) - 5)
            }
            ZStack {
                Path { p in
                    guard let first = pts.first else { return }
                    p.move(to: first)
                    pts.dropFirst().forEach { p.addLine(to: $0) }
                    p.addLine(to: CGPoint(x: w, y: h))
                    p.addLine(to: CGPoint(x: 0, y: h))
                    p.closeSubpath()
                }
                .fill(LinearGradient(colors: [color.opacity(0.28), color.opacity(0)], startPoint: .top, endPoint: .bottom))
                Path { p in
                    guard let first = pts.first else { return }
                    p.move(to: first)
                    pts.dropFirst().forEach { p.addLine(to: $0) }
                }
                .stroke(color, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
            }
        }
        .frame(height: height)
    }
}

struct SparklineView: View {
    let data: [Double]
    var color: Color = Theme.brand500
    var body: some View {
        GeometryReader { geo in
            let maxV = data.max() ?? 1
            let minV = data.min() ?? 0
            let range = max(maxV - minV, 1)
            let w = geo.size.width
            let h = geo.size.height
            let step = w / CGFloat(max(data.count - 1, 1))
            Path { p in
                let pts = data.enumerated().map { (i, v) in
                    CGPoint(x: CGFloat(i) * step, y: h - CGFloat((v - minV) / range) * h)
                }
                guard let first = pts.first else { return }
                p.move(to: first)
                pts.dropFirst().forEach { p.addLine(to: $0) }
            }
            .stroke(color, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
        }
        .frame(height: 34)
    }
}

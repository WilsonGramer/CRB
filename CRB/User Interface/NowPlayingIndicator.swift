// https://github.com/docterd/SwimplyPlayIndicator

import SwiftUI
import Combine

public struct NowPlayingIndicator: View {
    fileprivate struct AnimationValue: Identifiable {
        let id: Int
        let maxValue: CGFloat
        let animation: Animation
    }

    public enum AudioState {
        case stop
        case play
        case pause
    }

    let state: AudioState
    let count: Int = 3
    
    @State private var opacity: Double = 0.0

    private var animationValues: [AnimationValue] {
        let valueRange: ClosedRange<CGFloat> = (0.7 ... 1.0)
        let speedRange: ClosedRange<Double> = (0.6 ... 1.2)
        let animations: [Animation] = [.easeIn, .easeOut, .easeInOut, .linear]
        let values = (0 ..< count)
            .compactMap { (id) -> AnimationValue? in
                animations
                    .randomElement()
                    .map { animation -> AnimationValue in
                        AnimationValue(id: id, maxValue: CGFloat.random(in: valueRange),
                                       animation: animation.speed(Double.random(in: speedRange)))
                    }
            }
        return values
    }

    public var body: some View {
        HStack(alignment: .center, spacing: 2.5) {
            ForEach(self.animationValues) { animationValue in
                BarView(state: state, animationValue: animationValue)
            }
        }
        .opacity(opacity)
        .drawingGroup()
        .frame(idealWidth: 18, idealHeight: 18)
        .onAppear {
            self.opacity = 0.0
        }
        .onReceive(Just(state), perform: { _ in
            withAnimation(.linear) {
                self.opacity = state == .stop ? 0.0 : 1.0
            }
        })
    }
}

private struct BarView: View {
    @State private var heightValue: CGFloat = 0.0
    let state: NowPlayingIndicator.AudioState
    let animationValue: NowPlayingIndicator.AnimationValue

    var body: some View {
        LineView(maxValue: heightValue)
            .onAppear {
                heightValue = 0.0
            }
            .onReceive(Just(state).throttle(for: 0.5, scheduler: RunLoop.main, latest: true), perform: { _ in
                let animation = state == .play
                    ? animationValue.animation.repeatForever()
                    : Animation.easeOut(duration: 0.3)

                withAnimation(animation) {
                    self.heightValue = state == .play ? animationValue.maxValue : 0.0
                }
            })
    }
}

private struct LineView: Shape {
    var maxValue: CGFloat = 0.0
    
    var animatableData: CGFloat {
        get { maxValue }
        set { maxValue = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let height = max(rect.width, maxValue * rect.height)
        let lineRect = CGRect(x: 0, y: rect.maxY - height, width: rect.width, height: height)
        return Path(roundedRect: lineRect, cornerRadius: 1.5)
    }
}

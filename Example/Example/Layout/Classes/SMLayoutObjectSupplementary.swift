import UIKit

final class SMLayoutObjectSupplementary {
    
    private(set) var frameCurrent: CGRect
    let frameInitial: CGRect
    let kind: String
    var rangeCurrent: ClosedRange<CGFloat>?
    var rangeInitial: ClosedRange<CGFloat>? {
        didSet {
            rangeCurrent = rangeInitial
        }
    }
    let stick: SMLayoutStick?
    let zIndex: Int
    
    private init(frameCurrent: CGRect, frameInitial: CGRect, kind: String, rangeCurrent: ClosedRange<CGFloat>? = nil, rangeInitial: ClosedRange<CGFloat>? = nil, stick: SMLayoutStick?, zIndex: Int) {
        self.frameCurrent = frameCurrent
        self.frameInitial = frameInitial
        self.kind = kind
        self.rangeCurrent = rangeCurrent
        self.rangeInitial = rangeInitial
        self.stick = stick
        self.zIndex = zIndex
    }
    /// Используется для инициализации бэкграунда
    convenience init(aspect: SMLayoutAspect, direction: SMLayoutDirection, kind: String, length: CGFloat, zIndex: Int) {
        let frame: CGRect
        switch direction {
        case .vertical:
            frame = CGRect(origin: .zero, size: CGSize(width: aspect.value, height: length))
        case .horizontal:
            frame = CGRect(origin: .zero, size: CGSize(width: length, height: aspect.value))
        }
        self.init(frameCurrent: frame, frameInitial: frame, kind: kind, stick: nil, zIndex: zIndex)
    }
    /// Используется для инициализации футера и хедера
    convenience init?(aspect: SMLayoutAspect, direction: SMLayoutDirection, origin: inout CGFloat, stick: SMLayoutStick?, supplementary: SMLayoutSupplementary?, zIndex: Int) {
        guard let supplementary = supplementary else {
            return nil
        }
        let frame = supplementary.smLayoutSupplementaryFrame(aspect: aspect, origin: origin)
        let kind = supplementary.smLayoutSupplementaryKind()
        switch direction {
        case .vertical:
            origin += frame.origin.y - origin + frame.size.height
        case .horizontal:
            origin += frame.origin.x - origin + frame.size.width
        }
        self.init(frameCurrent: frame, frameInitial: frame, kind: kind, stick: stick, zIndex: zIndex)
    }
}

extension SMLayoutObjectSupplementary: SMLayoutUpdatable {
    
    func smLayoutUpdated(direction: SMLayoutDirection, origin: SMLayoutOrigin) {
        self.frameCurrent = {
            var frame = self.frameInitial
            switch direction {
            case .vertical:
                frame.origin.y = origin.value + frame.origin.y
            case .horizontal:
                frame.origin.x = origin.value + frame.origin.x
            }
            return frame
        }()
        self.rangeCurrent = {
            guard let range: ClosedRange<CGFloat> = self.rangeInitial else {
                return nil
            }
            return range.lowerBound + origin.value ... range.upperBound + origin.value
        }()
    }
    
    func smLayoutUpdated(visible: SMLayoutVisible) {
        guard let stick = self.stick, let rangeCurrent = self.rangeCurrent else {
            return
        }
        var rangeVisible = visible.range
        if stick == .bottom {
            let offset: CGFloat = {
                switch visible.direction {
                case .vertical:
                    return self.frameCurrent.size.height
                case .horizontal:
                    return self.frameCurrent.size.width
                }
            }()
            if rangeVisible.upperBound - rangeVisible.lowerBound >= offset {
                rangeVisible = rangeVisible.lowerBound ... rangeVisible.upperBound - offset
            } else {
                rangeVisible = rangeVisible.lowerBound ... rangeVisible.lowerBound
            }
        }
        let range = rangeVisible.clamped(to: rangeCurrent)
        let origin = stick == .bottom ? range.upperBound : range.lowerBound
        self.frameCurrent = frameInitial
        switch visible.direction {
        case .vertical:
            self.frameCurrent.origin.y = origin
        case .horizontal:
            self.frameCurrent.origin.x = origin
        }
        self.rangeCurrent = rangeCurrent
    }
    
    func smLayoutUpdateRequired(visible: SMLayoutVisible) -> Bool {
        guard let _ = self.stick, let range = self.rangeCurrent else {
            return false
        }
        guard visible.range.overlaps(range) else {
            return false
        }
        return true
    }
}

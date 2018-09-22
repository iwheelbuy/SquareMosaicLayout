import Foundation

struct SMLDirection {
    
    private let aspect: CGFloat
    private let vertical: Bool
    
    init(aspect: CGFloat, vertical: Bool) {
        self.aspect = aspect
        self.vertical = vertical
    }
    
    func smlDirectionAspect() -> CGFloat {
        return aspect
    }
    
    func smlDirectionVertical() -> Bool {
        return vertical
    }
}

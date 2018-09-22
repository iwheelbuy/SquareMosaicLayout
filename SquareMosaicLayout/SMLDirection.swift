import Foundation

protocol SMLDirection {
    
    func smlDirectionAspect() -> CGFloat
    func smlDirectionVertical() -> Bool
}

struct Direction: SMLDirection {
    
    let aspect: CGFloat
    let vertical: Bool
    
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


import UIKit

protocol ConfigurableCell {
    associatedtype CellType
    
    func config(for weather: CellType)
}

protocol NibCell  {
    static var nib: UINib! { get }
    static var reuseId : String! { get }
}

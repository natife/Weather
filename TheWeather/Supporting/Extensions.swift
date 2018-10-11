
import UIKit

extension UIView{
    static var nib: UINib! {
        return UINib(nibName: reuseId, bundle: nil)
    }
    
    static var reuseId: String! {
        return String(describing: self)
    }
    
    class func view<T: UIView>() -> T{
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

extension UIViewController{
    private static var reuseId: String!{
        return String(describing: self)
    }
    
    private static func controller<T>(_ controller: T.Type) -> T{
        return UIStoryboard(name: reuseId, bundle: nil).instantiateViewController(withIdentifier: reuseId) as! T
    }
    
    static func instantiate() -> Self{
        return controller(self)
    }
    
}

extension UITableView{
    func dequeueReusableCell<T: UITableViewCell>(ofType type: T.Type, for indexPath: IndexPath) -> T{
        return dequeueReusableCell(withIdentifier: T.reuseId, for: indexPath) as! T
    }
    func register<T: UITableViewCell>(cell: T.Type, bundle: Bundle? = nil){
        register(T.nib, forCellReuseIdentifier: T.reuseId)
    }
}

extension UICollectionView{
    func dequeueReusableCell<T: UICollectionViewCell>(ofType type: T.Type, for indexPath: IndexPath) -> T{
        return dequeueReusableCell(withReuseIdentifier: T.reuseId, for: indexPath) as! T
    }
    func register<T: UICollectionViewCell>(cell: T.Type, bundle: Bundle? = nil){
        register(T.nib, forCellWithReuseIdentifier: T.reuseId)
    }
}

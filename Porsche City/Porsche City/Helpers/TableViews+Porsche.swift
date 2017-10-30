import UIKit

extension UITableView
{
    func hideEmtpyCells()
    {
        self.tableFooterView = UIView(frame: CGRect.zero)
    }
}

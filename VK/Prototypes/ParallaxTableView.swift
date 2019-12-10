//реализация View с параллакс эффектом
//infoHeight & infoBottom идентификаторы констрейнов из Storyboard

import UIKit

class ParallaxTableView: UITableView {

    var infoHeight: NSLayoutConstraint?
    var infoBottom: NSLayoutConstraint?

    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let header = tableHeaderView else { return }
        if let imageView = header.subviews.first as? UIImageView {
            infoHeight = imageView.constraints.filter{ $0.identifier == "infoHeight"}.first
            infoBottom = header.constraints.filter{ $0.identifier == "infoBottom"}.first
        }

        let offsetY = -contentOffset.y
        infoBottom?.constant = offsetY >= 0 ? 0 : offsetY / 2
        infoHeight?.constant = max(header.bounds.height, header.bounds.height + offsetY)
        
        header.clipsToBounds = offsetY <= 0
    }
}

import UIKit

extension UIImage {

    func aspectFitImage(inRect rect: CGRect) -> UIImage? {
        let width = self.size.width
        let height = self.size.height
        let aspectWidth = rect.width / width
        let aspectHeight = rect.height / height
        let scaleFactor = aspectWidth > aspectHeight ? rect.size.height / height : rect.size.width / width

        UIGraphicsBeginImageContextWithOptions(CGSize(width: width * scaleFactor, height: height * scaleFactor), false, 0.0)
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: width * scaleFactor, height: height * scaleFactor))

        defer {
            UIGraphicsEndImageContext()
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func aspectFillImage(inRect rect: CGRect) -> UIImage? {
        let width = self.size.width
        let height = self.size.height
        let scaleFactor = rect.size.width / width
        let aspectHeight = height * scaleFactor
        let aspect = aspectHeight / rect.height
        let fillY = aspect > 2.0 ? -height / 2 + rect.height : 0

        UIGraphicsBeginImageContextWithOptions(CGSize(width: rect.width, height: aspectHeight), false, 0.0)
        self.draw(in: CGRect(x: 0.0, y: fillY, width: rect.width, height: aspectHeight))

        defer {
            UIGraphicsEndImageContext()
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}

import UIKit
//// step 20
protocol FullImageViewControllerDelegate {
    func deleteData(indexPath: IndexPath)
}
class FullImageViewController: UIViewController {


    @IBOutlet weak var imageView: UIImageView!
    //step 12
    var selectedImage: UIImage?
    var indexPath: IndexPath?

    //step 21
   var delegate: FullImageViewControllerDelegate?

        override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = selectedImage
}
    //step 16
    @IBAction func closeViewBySwipe(_ sender: Any) {
        closeView()
    }
        //step 19
    @IBAction func deleteButtonTapped(_ sender: Any) {
      //  step 22
        self.delegate?.deleteData(indexPath: indexPath!) //??
        self.dismiss(animated: true, completion: nil)
        closeView()
    }

    func deleteImage() {

    }
    
    //step 17
    func closeView() {
        navigationController?.popViewController(animated: true)
    }
    
}
//step 14
extension FullImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}

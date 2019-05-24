import UIKit
import Photos

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    var arrayImage = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestPhotoAccess { (success) in
            DispatchQueue.main.async {
                self.updateImages()
            }
        }
    }
    
    private func requestPhotoAccess(completion: @escaping (_ success: Bool) -> ()) {
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == PHAuthorizationStatus.authorized {
                completion(true)
            } else {
                completion(false)
                print("Fail to access photos")
            }
        }
    }
    
    private func updateImages() {
        self.arrayImage = self.loadImagesFromLibrary()
        self.collectionView.reloadData()
    }
    
    private func loadImagesFromLibrary() -> [UIImage] {
        let imgManager = PHImageManager.default()
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 10
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        let fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        var images = [UIImage]()
        fetchResult.enumerateObjects { (asset, index, stop) in
            let scale = UIScreen.main.scale
            let size = CGSize(width: 100 * scale, height: 100 * scale)
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            imgManager.requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.aspectFill, options: options, resultHandler: { (image, _) in
                if let image = image {
                    images.append(image)
                }
            })
        }
        return images
    }
}



extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrayImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as? MyCollectionViewCell else {return UICollectionViewCell()}
        
        cell.myImage.image = arrayImage[indexPath.row]
        return cell
    }
    // step 11 (see below)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on image # \(indexPath.row)")
        let myImageViewPage: FullImageViewController = self.storyboard?.instantiateViewController(withIdentifier: "FullImageViewController") as! FullImageViewController
        
        //step 13
        myImageViewPage.selectedImage = self.arrayImage[indexPath.row]
        
        // step 25 .delegate = self
       myImageViewPage.delegate = self
        // 25 передаем выбранную ячейку
        myImageViewPage.indexPath = indexPath
        
        self.navigationController?.pushViewController(myImageViewPage, animated: true)
        
    }
    
}
// step 23
extension ViewController: FullImageViewControllerDelegate {
    //step 24
    func deleteData(indexPath: IndexPath) {
        arrayImage.remove(at: indexPath.item)
        collectionView.reloadData()
    }
    
    
}


import UIKit
import HTMLString

struct Model: Decodable {
    let kind: String
    let data: ListingData
}

struct ListingData: Decodable {
    let modhash: String
    let dist: Int
    let children: [Child]
}

struct Child: Decodable {
    let data: ChildData
    let kind: String?
}

struct ChildData: Decodable {
    let preview: PreviewData
}

struct PreviewData: Decodable {
    let images: [ImageData]
    let enabled: Bool = false
}

struct ImageData: Decodable {
    let source: SourceData
}

struct SourceData: Decodable {
    let url: String?
    let width: Int
    let height: Int
}


class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var images: [String] = []
    var redditImage: [UIImage] = []

    @IBOutlet weak var myCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        myCollectionView.dataSource = self

        let urlString = "https://www.reddit.com/r/aww.json"

            let url = URL(string: urlString)
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
             if error == nil {
                 if let data = try? Data(contentsOf: url!) {
                     let decoder = JSONDecoder()
                     if let redditJSON = try? decoder.decode(Model.self, from: data) {
                        /// ".removingHTMLEntities" is from using the HTMLString pod for removing HTML encoded entities in the image URL.
                        redditJSON.data.children.forEach { (entry) in
                            if let url = entry.data.preview.images[0].source.url {
                             self.images.append(url.removingHTMLEntities)
                            } else { return }
                          }
                        }
                    DispatchQueue.main.async {
                        self.myCollectionView.reloadData()
                    }
                }
            }
        }.resume()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MyCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "redditImageCell", for: indexPath) as! MyCollectionViewCell
        let imageURL = URL(string: images[indexPath.row])!
        print(imageURL)

        cell.redditImageView.downloaded(from: imageURL)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        return CGSize(width: collectionWidth/2, height: collectionWidth/2)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageDetail: ImageViewController = self.storyboard?.instantiateViewController(identifier: "ImageViewController") as! ImageViewController
        let imageURL = URL(string: images[indexPath.row])!
        let data = try? Data(contentsOf: imageURL)
        imageDetail.detailImage = UIImage(data: data!)
        self.navigationController?.pushViewController(imageDetail, animated: true)
    }
}

extension UIImageView {
    func downloaded(from url: URL)  {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
}



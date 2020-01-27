# iOSProjects

# 1. redditImages_CollectionView
This project parses a reddit json "https://www.reddit.com/r/aww.json" for images and adds them to a collectionView with navigation to tap on an image and view the image in its own view controller. The approach includes: 
1. Parsing the json for `images` using `URLSession` asynchronously and mapping to a `Model` object using `Decodable`. 
2. Used the cocoapods: https://cocoapods.org/pods/HTMLString to removeHTML encoded entities in the image URL. 
3. Use `UICollectionViewDataSource`, `UICollectionViewFlowLayoutDelegate` to add the parsed images to a collectionView. 
4. Tapping on an image in the collectionView, takes the user to another view controller displaying the tapped image. 

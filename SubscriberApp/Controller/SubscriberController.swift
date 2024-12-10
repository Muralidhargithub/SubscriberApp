import UIKit

class SubscriberController: UIView {
    
    private var data: [SubscriberDetails] = []
    private let subscriberData: SubscriberPro = SubscribeNetwork.subInstance
    private var imageCache: [URL: UIImage] = [:] // Cache for images
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUP()
        fetchData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUP() {
        self.addSubview(tableView)
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    
    func fetchData() {
        let url = commonUrl.baseURL
        subscriberData.getData(url: url) { [weak self] (result: Subscriber?) in
            guard let self = self, let result = result else {
                print("Failed to fetch data or decode Subscriber.")
                return
            }
            DispatchQueue.main.async {
                self.data = result.data
                self.tableView.reloadData()
            }
        }
    }
        func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
            if let cachedImage = imageCache[url] {
                completion(cachedImage)
                return
            }
            subscriberData.getImage(url: url.absoluteString) { [weak self] image in
                guard let self = self else { return }
                if let image = image {
                    self.imageCache[url] = image
                }
                completion(image)
            }
        }
    }


extension SubscriberController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        
        let subscriberDetails = data[indexPath.row]
        cell.configure(with: subscriberDetails) { [weak self] url, completion in
            self?.loadImage(from: url, completion: completion)
        }
        
        return cell
    }
}

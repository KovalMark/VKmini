import UIKit

// MARK: NewsController
class NewsController: UIViewController {
    
    private let service = NewsVKService()
    private var news: [NewsVK] = []
    private var imageService: ImageService?
    private var lastDateString: String?
    var nextForm = ""
    var isLoading = false
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter
    }()
    
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: DidLoad / WillAppear
    override func viewDidLoad() {
        super.viewDidLoad()
        imageService = ImageService(container: newsTableView)
        setupRefreshControl()
        registerCell()
        selfNewsTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
        service.getUrl()
            .get({ url in
                print(url)
            })
            .then(on: DispatchQueue.global(), service.getData(_:))
            .then(on: DispatchQueue.global(), service.getParsedData(_:))
            .get({ response in
                self.nextForm = response.nextFrom ?? ""
            })
            .then(on: DispatchQueue.global(), service.getNews(_:))
            .done(on: DispatchQueue.main) { [weak self] news in
                guard let self = self else { return }
                self.news = news
                self.newsTableView.reloadData()
                self.lastDateString = String(news.first?.date ?? 0)
            }.ensure {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }.catch { error in
                print(error)
            }
    }
    
    // MARK: Views
    // Функция настройки контроллера
    fileprivate func setupRefreshControl() {
        
        // Инициализируем и присваиваем сущность UIRefreshControl
        newsTableView.refreshControl = UIRefreshControl()
        
        // Настраиваем свойства контрола:
        // 1) выводимый текст
        newsTableView.refreshControl?.attributedTitle = NSAttributedString(string: "Загрузка новостей")
        // 2) цвет заднего фона
        newsTableView.refreshControl?.backgroundColor = #colorLiteral(red: 0.2196077406, green: 0.2196079195, blue: 0.2239105105, alpha: 1)
        // 3) Цвет спиннера
        newsTableView.refreshControl?.tintColor = #colorLiteral(red: 1, green: 0.9959130883, blue: 1, alpha: 1)
        // 4) Прикрепляем функцию, которая будет вызываться контролом
        newsTableView.refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    @objc func refreshNews() {
        guard let date = lastDateString else {
            newsTableView.refreshControl?.endRefreshing()
            return
        }
        service.getUrlWithTime(date)
            .get({ url in
                print(url)
            })
            .then(on: DispatchQueue.global(), service.getData(_:))
            .then(on: DispatchQueue.global(), service.getParsedData(_:))
            .then(on: DispatchQueue.global(), service.getNews(_:))
            .done(on: DispatchQueue.main) { [weak self] news in
                guard let self = self else { return }
                print(news.count)
                let indexSet = IndexSet(integersIn: self.news.count..<self.news.count + news.count)
                self.news.insert(contentsOf: news, at: 0)
                self.newsTableView.insertSections(indexSet, with: .automatic)
                self.lastDateString = news.first?.getStringDate()
            }.ensure { [weak self] in
                self?.newsTableView.refreshControl?.endRefreshing()
            }.catch { error in
                print(error)
            }
    }
}

// MARK: extension NewsController
// setting for cells
extension NewsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        news.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // много вычислений выполнится indexPath.section * indexPath.row раз
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsImageCell.identifier) as! NewsImageCell
            let post = news[indexPath.section]
            guard let urlImage = post.photosURL?.first else { return UITableViewCell()}
            cell.configure(urlImage)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsTextCell.identifier) as! NewsTextCell
            let text = news[indexPath.section].text
            cell.configure(text)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            guard
                let urls = news[indexPath.section].photosURL,
                !urls.isEmpty else {
                return 0
            }
            let width = view.frame.width
            let post = news[indexPath.section]
            let cellHeight = width * post.aspectRatio
            return cellHeight
        case 1:
            if news[indexPath.section].text.isEmpty {
                return 0
            }
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewsHeader.identifier) as? NewsHeader
        
        header?.configure(avatarImage: news[section].avatarURL, nameOwner: news[section].creatorName)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
    
    // Вызовите метод willDisplayHeaderView в TableViewController классе
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        // Создаём константу, именно через неё мы будем обращаться к свойствам и изменять их
        let header = view as! UITableViewHeaderFooterView
        
        // Установить цвет фона для секции
        header.tintColor = #colorLiteral(red: 0.1128253862, green: 0.1178093925, blue: 0.1177227572, alpha: 1)
    }
}

// MARK: extension NewsController
// news update
extension NewsController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxSection = indexPaths.map({ $0.section }).max() else {
            return
        }
        
        if maxSection > news.count - 3,
           !isLoading {
            isLoading = true
            
            service.getUrl(self.nextForm)
                .get({ url in
                    print(url)
                })
                .then(on: DispatchQueue.global(), service.getData(_:))
                .then(on: DispatchQueue.global(), service.getParsedData(_:))
                .get({ response in
                    self.nextForm = response.nextFrom ?? ""
                })
                .then(on: DispatchQueue.global(), service.getNews(_:))
                .done(on: DispatchQueue.main) { [weak self] news in
                    guard let self = self else { return }
                    let indexSet = IndexSet(integersIn: self.news.count..<self.news.count + news.count)
                    
                    self.news.append(contentsOf: news)
                    self.newsTableView.insertSections(indexSet, with: .automatic)
                }.ensure {
                    self.isLoading = false
                }.catch { error in
                    print(error)
                }
        }
    }
}

// MARK: extension NewsController
// register and self newsTableView
extension NewsController {
    
    func registerCell() {
        newsTableView.register(NewsHeader.self, forHeaderFooterViewReuseIdentifier: NewsHeader.identifier)
        newsTableView.register(NewsImageCell.self, forCellReuseIdentifier: NewsImageCell.identifier)
        newsTableView.register(NewsTextCell.self, forCellReuseIdentifier: NewsTextCell.identifier)
    }
    
    func selfNewsTableView() {
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.prefetchDataSource = self
    }
}

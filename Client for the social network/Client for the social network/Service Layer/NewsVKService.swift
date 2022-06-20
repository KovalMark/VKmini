import Foundation
import PromiseKit

// MARK: - NewsVKService
final class NewsVKService {
    
    private var urlConstructor = URLComponents()
    private let constants = NetworkConstants()
    private let configuration: URLSessionConfiguration!
    private let session: URLSession!
    
    init() {
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
    }
    
    func getAuthorizeRequest() -> URLRequest? {
        urlConstructor.host = "oauth.vk.com"
        urlConstructor.path = "/authorize"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "client_id", value: constants.clientID),
            URLQueryItem(name: "scope", value: constants.scope),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: constants.versionAPI)
        ]
        
        guard let url = urlConstructor.url else { return nil }
        let request = URLRequest(url: url)
        return request
    }
    
    //MARK: - News feed (Promise)
    // Result use
    // 1. Создаем URL для запроса
    func getUrl() -> Promise<URL> {
        urlConstructor.path = "/method/newsfeed.get"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "filters", value: "post"),
            //            URLQueryItem(name: "start_from", value: "next_from"),
            URLQueryItem(name: "count", value: "20"),
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: constants.versionAPI),
        ]
        
        return Promise  { resolver in
            guard let url = urlConstructor.url else {
                resolver.reject(AppError.notCorrectUrl)
                return
            }
            resolver.fulfill(url)
        }
    }
    
    func getUrl(_ nextForm: String) -> Promise<URL> {
        urlConstructor.path = "/method/newsfeed.get"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "filters", value: "post"),
            URLQueryItem(name: "start_from", value: nextForm),
            URLQueryItem(name: "count", value: "20"),
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: constants.versionAPI),
        ]
        
        return Promise  { resolver in
            guard let url = urlConstructor.url else {
                resolver.reject(AppError.notCorrectUrl)
                return
            }
            resolver.fulfill(url)
        }
    }
    
    func getUrlWithTime(_ timeInterval1970: String) -> Promise<URL> {
        urlConstructor.path = "/method/newsfeed.get"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "filters", value: "post"),
            URLQueryItem(name: "start_from", value: "next_from"),
            URLQueryItem(name: "start_time", value: timeInterval1970),
            URLQueryItem(name: "count", value: "1"),
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: constants.versionAPI),
        ]
        
        return Promise  { resolver in
            guard let url = urlConstructor.url else {
                resolver.reject(AppError.notCorrectUrl)
                return
            }
            resolver.fulfill(url)
        }
    }
    
    // 2. Создаем запрос получили данные
    func getData(_ url: URL) -> Promise<Data> {
        return Promise { resolver in
            session.dataTask(with: url) {  (data, response, error) in
                guard let data = data else {
                    resolver.reject(AppError.errorTask)
                    return
                }
                resolver.fulfill(data)
            }.resume()
        }
    }
    
    // Парсим Данные
    func getParsedData(_ data: Data) -> Promise<ItemsNews> {
        return Promise  { resolver in
            do {
                let response = try JSONDecoder().decode(NewsResponse.self, from: data).response
                resolver.fulfill(response)
            } catch {
                resolver.reject(AppError.failedToDecode)
            }
        }
    }
    
    func getNews(_ items: ItemsNews) -> Promise<[NewsVK]> {
        return Promise<[NewsVK]> { resolver in
            var news = items.items
            let groups = items.groups
            let profiles = items.profiles
            
            for i in 0..<news.count {
                if news[i].sourceID < 0 {
                    let group = groups.first(where: { $0.id == -news[i].sourceID })
                    news[i].avatarURL = group?.avatarURL
                    news[i].creatorName = group?.name
                } else {
                    let profile = profiles.first(where: { $0.id == news[i].sourceID })
                    news[i].avatarURL = profile?.avatarURL
                    news[i].creatorName = (profile?.firstName ?? "") + (profile?.lastName ?? "")
                }
            }
            resolver.fulfill(news)
        }
    }
}

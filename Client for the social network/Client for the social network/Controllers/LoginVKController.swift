import UIKit
import WebKit

// MARK: - web-interface
final class LoginVKController: UIViewController {
    
    private lazy var webView: WKWebView = {
        
        let config = WKWebViewConfiguration()
        let view = WKWebView(frame: .zero, configuration: config)
        return view
    } ()
    
    override func loadView() {
        super.loadView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebView()
        loadAuth()
    }
}

// MARK: - WKNavigationDelegate
extension LoginVKController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard
            let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment
        else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
        if let token = params["access_token"], let id = params["user_id"] {
            Session.instance.userID = Int(id)!
            Session.instance.token = token
            print(token)
            decisionHandler(.cancel)
            
            performSegue(withIdentifier: "Log in", sender: nil)
        }
    }
}

// MARK: - extension LoginVKController
private extension LoginVKController {
    
    func configureWebView() {
        
        navigationController?.navigationBar.isHidden = true
        webView.navigationDelegate = self
    }
    
    func loadAuth() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "8135045"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "offline, friends, groups, photos, status, wall, video"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "revoke", value: "0")
        ]
        
        guard let url = urlComponents.url else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

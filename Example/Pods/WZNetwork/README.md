# 我主良缘网络框架

## Requirements:
- **iOS** 9.0+
- Xcode 10.0+
- Swift 5.0+


## Installation Cocoapods
<pre><code class="ruby language-ruby">pod 'WZNetwork', '~> 2.0.0'</code></pre>

## Demo
![demo](https://git.lug.ustc.edu.cn/wzios/WZNetwork/raw/master/1.png)

## Usage 
### 定义用户模块请求接口
```Swift
/// MARK - 账户模块API
enum UserModuleApi {
    
    /// 登录
    case login(info: [String: Any])
    /// 获取相册
    case findalbum
    
    /// 上传用户头像
    case upLoadUserAvatar(info: [String: Any], image: Data)
    
    /// 下载配置
    case downloadConfig
}


// MARK: - TargetType
extension UserModuleApi: TargetType {
    
    var baseURL: URL {
        return URL(string: "http://testapi.myhoney520.com")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/passport/app/login/index"
        case .findalbum:
            return "/user/app/album/get"
        case .upLoadUserAvatar:
            return "/user/app/avatar/saveImg"
        case .downloadConfig:
            return "/center/app/config/getIOS"
        }
    }
    
    var method: WZMoya.Method {
        switch self {
        case .login:
            return .post
        case .findalbum:
            return .get
        case .upLoadUserAvatar:
            return .post
        case .downloadConfig:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .login(info):
            return Task.requestParameters(parameters: info, encoding: URLEncoding.methodDependent)
        case .findalbum:
            return Task.requestPlain
        case let .upLoadUserAvatar(info, image):
            return Task.uploadCompositeMultipart([MultipartFormData(provider: MultipartFormData.FormDataProvider.data(image), name: "imgfile0", fileName: "20190901213123FromIOS.jpg", mimeType: "image/jpg")], urlParameters: info)
        case .downloadConfig:
            return Task.requestPlain
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var headers: [String : String]? {
        return nil
    }
}
```

### 调用接口
```Swift
// MARK: - <#UITableViewDelegate#>
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let requestObject = UserModuleApi.allCases[indexPath.row]
        switch indexPath.row {
        case 0:
            requestObject.request()
                .mapModel(UserModel.self)
                .subscribe(onNext: { (result) in
                    debugPrint(result)
                    Network.Configuration.default.token = result.token
                }, onError: { (error) in
                    debugPrint(error)
                }).disposed(by: disposeBag)
        case 1:
            requestObject.request()
                .mapModel([UserPhoto].self)
                .subscribe(onNext: { (result) in
                    debugPrint(result)
                }, onError: { (error) in
                    debugPrint(error)
                }).disposed(by: disposeBag)
        case 2:
            requestObject.request()
                .mapResult(String.self)
                .subscribe(onNext: { (result) in
                debugPrint(result.msg)
            }, onError: { (e) in
                debugPrint(e)
            }).disposed(by: disposeBag)
        case 3:
            
            requestObject.request()
                .mapModel(BaseConfigInfo.self)
                .subscribe(onNext: { (result) in
                    debugPrint(result)
                }, onError: { (error) in
                    debugPrint(error)
                }).disposed(by: disposeBag)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
```

### 具体详情请运行项目查看


## Reference
<ul>
<li><a href="https://git.lug.ustc.edu.cn/wzios/WZAlamofire.git"><code>WZAlamofire</code></a></li>
<li><a href="https://git.lug.ustc.edu.cn/wzios/WZMoya.git"><code>WZMoya</code></a></li>
</ul>

## License
WZNetwork is released under an MIT license. See [LICENSE](LICENSE) for more information.
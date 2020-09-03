# 我主良缘路由

## Requirements:
- **iOS** 9.0+
- Xcode 10.0+
- Swift 5.0+


## Installation Cocoapods
<pre><code class="ruby language-ruby">pod 'WZRoute', '~> 2.0.0'</code></pre>
<pre><code class="ruby language-ruby">pod 'WZRoute/Binary', '~> 2.0.0'</code></pre>

## Use 具体看API

```swift
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.red
        WZRoute.push(vc, animated: true) {
            debugPrint("完成")
        }
```

## License
WZRoute is released under an MIT license. See [LICENSE](LICENSE) for more information.
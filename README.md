# 4d-tips-laravel-example
Laravel 8で4D v18 R5のREST APIをコールする例題

### 4DをRESTサーバーにするには

**REST API**: ORDAのリモートデータストア・4D for iOS・4D Mobile (Wakanda Bridge) の基盤となっているAPIを利用することができます。**軽量クライアントアプリ**（モバイルなど）の開発に最適です。Web Application Expansion (Web Server) ライセンスではなく，**4D Client Expansionライセンス**を消費します。ログインユーザー毎のセッション管理（18 R6以降はスケーラブルセッション管理）が組み込まれており，原則的にゲストユーザーは想定されていません。ORDAのクラスがそのままREST APIで公開されるので，個別にHTTPリクエストハンドラーを開発する必要はありません。

**HTTP API**: **Web Application Expansionライセンス**を消費する従来のメカニズム（``On Web Connection`` ``WEB SEND TEXT``など）の上に自作のREST APIを開発することができます。同時アクセスユーザー数にライセンス上の制限はありませんが，個別にHTTPリクエストハンドラーを開発する必要があり，膨大な作業量になるため，この方法でいわゆるリッチクライアント（4D ClientのWeb版）を実装することは想定されていません。

この例題では前者を使用します。

### Class API

[`Product` dataClass](4D/Shop/Project/Sources/Classes/Product.4dm)にはメンバー関数が定義されています。

* `getThisMonthProfit()`は`query()`にフォーミュラを使用している点に注目

```4d
$formula:=Formula:C1597((Year of:C25(This:C1470.date)=Year of:C25($1.currentDate)) & (Month of:C24(This:C1470.date)=Month of:C24($1.currentDate)))
$params:=New object:C1471
$params.args:=New object:C1471("currentDate"; Current date:C33)
$trades:=This:C1470.all().trades.query($formula; $params)
```

* `getThisYearProfit()`は`query()`にプレースホルダーを使用している点に注目

```4d
$currentDate:=Current date:C33
$params:=New object:C1471
$params.attributes:=New object:C1471("日付"; "date")
$params.parameters:=New object:C1471("今年の元日"; Add to date:C393(!00-00-00!; Year of:C25($currentDate); 1; 1); "今月の末日"; Add to date:C393(!00-00-00!; Year of:C25($currentDate); Month of:C24($currentDate)+1; 1)-1)
$trades:=This:C1470.all().trades.query(":日付 >= :今年の元日 and :日付 <= :今月の末日"; $params)
```

[`ProductEntity`](4D/Shop/Project/Sources/Classes/ProductEntity.4dm) [`ProductSelection`](4D/Shop/Project/Sources/Classes/ProductSelection.4dm)にも同名のメンバー関数（ポリモーフィズム）が定義されています。

* [`ORDA`](4D/Shop/Project/Sources/Methods/test_function_1.4dm)でクラスのメンバーメソッドをコールする例題

### On REST Authentication

前述したようにREST APIでは原則的にゲストユーザーが想定されていません。[`On REST Authentication`](4D/Shop/Project/Sources/DatabaseMethods/onRESTAuthentication.4dm)による認証は必須です。認証メソッドが実装されていない場合，すべてのリクエストは新規ゲストユーザーとなり，[たちまちクライアント接続ライセンスが底を尽きます](https://4d-jp.github.io/2020/11/12/rest-api-license-model/)。

RESTアクセスを認証するためには`$directory/login` APIにHTTPで`POST`する必要があります。ブラウザのアドレスにURLを入力した場合は`GET`になるのでダメです。4Dの `HTTP Request`を使用するのであれば，`*`オプションを指定して`Keep-Alive`接続にすることができます。返された`Set-Cookie`ヘッダーからセッション識別子を取り出し，後続のアクセスで`Cookie`ヘッダーにセットすることができます。

* [`HTTP Request`](4D/Shop/Project/Sources/Methods/test_url_2.4dm)でクラスのメンバーメソッドをコールする例題

**注記**: 18 R5では，``exposed``に設定されていないクラスメソッドはREST APIで公開されません。18 R4（クラスAPIが追加された最初のバージョン）では，すべてのクラスメソッドがREST APIで公開されました。

### Laravelのセットアップ

**注記**: Larevelはすでにインストールされている前提です。

* 新規プロジェクトの作成

```sh
cd Laravel
laravel new shop
cd shop
```

* HTTPクライアントのインストール

```sh
composer require guzzlehttp/guzzle
```

* コントローラーの作成

```sh
php artisan make:controller ShopController
```
* ソースコードの編集

 * [routes/web.php](4D/Shop/Resources/routes/web.php)
 * [app/Http/Controllers/TelemasController.php](4D/Shop/Resources/app/Http/Controllers/ShopController.php)
 * [resources/views/product/index.blade.php](4D/Shop/Resources/resources/views/product/index.blade.php)

* ルーティングの確認

```sh
php artisan route:list
```

* サーバーの公開

```sh
php artisan serve --host=localhost --port=8000
```

### ルーティングについて

```php
Route::resource('shop', 'App\Http\Controllers\ShopController');
Route::get('/login', 'App\Http\Controllers\ShopController@login');
Route::get('/getThisMonthProfit', 'App\Http\Controllers\ShopController@getThisMonthProfit');
```

**注記**: Laravel 7以前のように[名前空間を省略するとエラー](https://litvinjuan.medium.com/how-to-fix-target-class-does-not-exist-in-laravel-8-f9e28b79f8b4)になります。

### 認証について

Laravelのコントローラーメソッドで4DのREST APIをコールします。セッション識別子は，[`$request`](https://laravel.com/docs/8.x/requests)に代入することができます。


```php
public function login(Request $request)
{
    $base_url = 'http://127.0.0.1:1800';
    $client = new \GuzzleHttp\Client( [
                                     'base_uri' => $base_url,
                                     ] );
    $path = '/rest/$directory/login';
    $headers = [
    'username-4D'           => 'user',
    'session-4D-length'     => '60',
    'hashed-password-4D'    => 'q1TzCU0hvFUZnyOPqPJ8Iw==',
    'Connection'            => 'keep-alive'
    ];
    $response = $client->request( 'POST', $path,
                                 [
                                 'http_errors' => false,
                                 'allow_redirects' => true,
                                 'headers'         => $headers
                                 ] );
    
    $status = (string) $response->getBody();
    if (200 == $response->getStatusCode()) {
        $cookies = $response->getHeader('Set-Cookie');
        if(count($cookies) != 0) {
            preg_match('/WASID4D=[^;]+/',$cookies[0],$match);
            if(count($match) != 0) {
                $request->session()->put('cookie', $match[0]);
            }
            
        }
        
    }

}
```

### Restfulリソースコントローラーについて

LaravelのRestfulリソースコントローラーメソッド（たとえば`Controller@index`）で4DのREST APIをコールし，JSONをビューに渡すことができます。

```php
public function index(Request $request)
{
    if (!$request->session()->exists('cookie')) {
        $this->login($request);
    }
                
    if ($request->session()->exists('cookie')) {
        
        $base_url = 'http://127.0.0.1:1800';
        $client = new \GuzzleHttp\Client( [
                                         'base_uri' => $base_url,
                                         ] );
        $path = '/rest/Product';
        $headers = [
        'Cookie'            => session('cookie')
        ];
        $response = $client->request( 'GET', $path,
                                     [
                                     'http_errors' => false,
                                     'allow_redirects' => true,
                                     'headers'         => $headers
                                     ] );
        
        if (200 == $response->getStatusCode()) {
            $products = json_decode($response->getBody());
            $products = $products->{"__ENTITIES"};
            return view('product/index', compact('products'));
        }

    }

}
```

### ビューについて

ビューの時点では完全にLaravelアプリケーションとなります。

### テスト

* [http://localhost:8000/shop](http://localhost:8000/shop)

全レコードを表示します（ログインしていなければ最初にログインします）。

* [http://localhost:8000/login](http://localhost:8000/login)

ログインします。

* [http://localhost:8000/getThisMonthProfit](http://localhost:8000/getThisMonthProfit)

4DのREST API`rest/Product/getThisMonthProfit`をコールします。

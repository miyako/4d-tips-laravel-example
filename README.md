# 4d-tips-laravel-example
Laravel 8で4D v18 R5のREST APIをコールする例題

#### REST API

4DにHTTPでアクセスする方法はおおきくわけて２とおり存在します。

**REST API**: ORDAのリモートデータストア・4D for iOS・4D Mobile (Wakanda Bridge) の基盤となっているAPIです。軽量クライアントアプリ（モバイルなど）に向いています。Web Application Expansion (Web Server) ライセンスではなく，4D Client Expansionを消費します。ログインユーザー毎のセッション管理（18 R6以降はスケーラブルセッション管理）が組み込まれており，原則的にゲストユーザーは想定されていません。ORDAのクラスがそのままREST APIで公開できるので，個別にHTTPリクエストハンドラーを開発する必要はありません。

**HTTP API**: Web Application Expansion (Web Server) ライセンスを使用し，従来のメカニズム（``On Web Connection`` ``WEB SEND TEXT``など）の上に自作のREST APIを開発することができます。同時アクセスユーザー数にライセンス上の制限はありませんが，個別にHTTPリクエストハンドラーを開発する必要があります。

#### Class API

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

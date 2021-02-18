<head>
  <title>Products</title>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
</head>
<div class="container ops-main">
<div class="row">
  <div class="col-md-12">
    <h3 class="ops-title">Products</h3>
  </div>
</div>
<div class="row">
  <div class="col-md-11 col-md-offset-1">
    <table class="table text-center">
      <tr>
        <th class="text-center">ID</th>
        <th class="text-center">name</th>
        <th class="text-center">code</th>
      </tr>
      @foreach($products as $product)
      <tr>
        <td>{{ $product->ID }}</td>
        <td>{{ $product->name }}</td>
        <td>{{ $product->code }}</td>
      </tr>
      @endforeach
    </table>
  </div>
</div>

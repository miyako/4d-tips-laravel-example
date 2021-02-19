<?php
    
    namespace App\Http\Controllers;
    
    use Illuminate\Http\Request;

    class ShopController extends Controller
    {
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
        
        public function show(Request $request)
        {
            
        }
        
        public function create(Request $request)
        {
            
        }
        
        public function store(Request $request)
        {
            
        }
        
        public function update(Request $request)
        {
            
        }
        
        public function destroy(Request $request)
        {
            
        }
        
        public function edit(Request $request)
        {
            
        }
        
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
        
        public function getThisMonthProfit(Request $request)
        {
            if (!$request->session()->exists('cookie')) {
                $this->login($request);
            }
                        
            if ($request->session()->exists('cookie')) {
                
                $base_url = 'http://127.0.0.1:1800';
                $client = new \GuzzleHttp\Client( [
                                                 'base_uri' => $base_url,
                                                 ] );
                $path = '/rest/Product/getThisMonthProfit';
                $headers = [
                'Cookie'            => session('cookie')
                ];
                $response = $client->request( 'POST', $path,
                                             [
                                             'http_errors' => false,
                                             'allow_redirects' => true,
                                             'headers'         => $headers
                                             ] );
                
                $status = (string) $response->getBody();
                if (200 == $response->getStatusCode()) {

                    
                }
                echo $status;
            }

        }
        
    }

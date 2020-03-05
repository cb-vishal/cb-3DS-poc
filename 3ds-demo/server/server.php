<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$tokenFromFrontEnd = $_POST['cko-card-token'];

echo $tokenFromFrontEnd;

$gatewayURL = "https://api.sandbox.checkout.com/payments";
$apiKey = "sk_test_0b9b5db6-f223-49d0-b68f-f6643dd4f808";
$requestBody = json_encode(array(
    'source' => array(
        'type' => 'token',
        'token' => $tokenFromFrontEnd,
    ),
    '3ds' => array(
        'enabled' => true,
    ),
    'amount' => 25,
    'currency' => 'USD',
    'reference' => 'order-123',
    'success_url' => 'http://gooogle.com/success',
    'failure_url' => 'http://gooogle.com/fail',
    'metadata' => array(
        'udf5' => 'chargebee-123',
    ),
));

// This is just a simple HTTP POST request ==> 
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $gatewayURL);
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_HTTPHEADER, array(
    'Authorization: '.$apiKey,
    'Content-Type:application/json;charset=UTF-8',
));
curl_setopt($ch, CURLOPT_POSTFIELDS,$requestBody);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$server_output = curl_exec($ch);
curl_close($ch);
// <==

$apiResponseBody = json_decode($server_output);
$redirectionURL = $apiResponseBody->_links->redirect->href;
echo $redirectionURL;
// Redirect user to the 3DS Redirection URL
header("Location: ".$redirectionURL); 

exit();
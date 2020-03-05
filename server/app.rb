require 'sinatra'
require "sinatra/cors"
require 'byebug'
require 'braintree'



#################### braintreee

Braintree::Configuration.environment = :sandbox
Braintree::Configuration.merchant_id = "nj4dqm7pgxr4njbn"
Braintree::Configuration.public_key = "xr8zpm47sgkyywbq"
Braintree::Configuration.private_key = "8a513022877fbee9fde27046a86082fa"

#braintree = Braintree::Gateway.new(
 # :environment => :sandbox,
  #:merchant_id => "jszbnz6jgstn85rp",
  #:public_key => "x8xhgh2t68zz83fp",
  #:private_key => "ce975729cbad5bf5ab882a289818668e"
#)

#################
post '/braintree/nonce' do
  data = JSON.parse(request.body.read.to_s)
 response =  Braintree::PaymentMethodNonce.create(data['card_token'])
   nonce = response.payment_method_nonce.nonce
   puts nonce
return [200, {'Content-Type' => 'application/json', "Access-Control-Allow-Origin" => "*", 
"Access-Control-Allow-Credentials" => "true" }, {temp_token: nonce}.to_json]
end

get '/braintree/getpm' do
  response = Braintree::PaymentMethodNonce.find('eba9addd-8f6c-09af-6c2a-b6e25a49fa43')

  return [200, {'Content-Type' => 'application/json', "Access-Control-Allow-Origin" => "*", 
"Access-Control-Allow-Credentials" => "true" }, {nonce: response.payment_method_nonce.payer_info}.to_json]
end

get '/braintree/client_token' do
 response =  Braintree::ClientToken.generate(
  :merchant_account_id => 'cb'
 )
return [200, {'Content-Type' => 'application/json', "Access-Control-Allow-Origin" => "*", 
"Access-Control-Allow-Credentials" => "true" }, response]
end

post '/braintree/sale' do
data = JSON.parse(request.body.read.to_s)
print data['nonce']  
        response = Braintree::Transaction.sale(
              :amount => "12",
              :merchant_account_id => "cb",
              :payment_method_nonce => data['nonce'],
              :customer_id => "270195243",
              :options => {
              :submit_for_settlement => true,
              :store_in_vault => true,
              :three_d_secure => {
                :required => true,
              },
             })
        
      if response.success?
           transaction = response.transaction
           puts "Success Txn_id:"+ transaction.id
           return [200, {'Content-Type' => 'application/json', "Access-Control-Allow-Origin" => "*", 
"Access-Control-Allow-Credentials" => "true" }, {status: 'success', txn_id: transaction.id}.to_json]
      else
      response.errors.each do |error|
       puts error.attribute
       puts error.code
       puts error.message
       end
       return  [200, {'Content-Type' => 'application/json', "Access-Control-Allow-Origin" => "*", 
"Access-Control-Allow-Credentials" => "true" }, {status: 'failure', error: response.message}.to_json]
      end
      
end


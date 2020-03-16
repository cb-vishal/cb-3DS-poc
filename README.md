# cb-3DS-poc
 Steps to generate payment method for Stripe google pay
 - Clone the repo -> git clone https://github.com/cb-sudheer/cb-3DS-poc.git
 - Navigate to server folder and start ruby server -> ruby app.rb
 - Start ngrok for 4567 port -> ./ngrok http 4567
 - Copy the forwarding url which is having https for example "https://0121acf4.ngrok.io"
 - Open corresponding html file stripe/stripe_payment_request.html and replace existing ngrok url with your ngrok url
 - Open the stripe_payment_request.html in mobile using the url https://cb-sudheer.github.io/cb-3DS-poc/stripe/stripe_payment_request.html
 - click pay now button
 - add a card in google pay
 - choose the card from google pay
 - click ok
 - you should receive a payment method token.

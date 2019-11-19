var payButton = document.getElementById('pay-button');
var form = document.getElementById('payment-form');

Frames.init('pk_test_4296fd52-efba-4a38-b6ce-cf0d93639d8a');

Frames.addEventHandler(Frames.Events.CARD_VALIDATION_CHANGED, onCardValidationChanged);
function onCardValidationChanged(event) {
	console.log('CARD_VALIDATION_CHANGED: %o', event);

	var errorMessage = document.querySelector('.error-message');
	payButton.disabled = !Frames.isCardValid();
}

Frames.addEventHandler(Frames.Events.FRAME_VALIDATION_CHANGED, onValidationChanged);
function onValidationChanged(event) {
	console.log('FRAME_VALIDATION_CHANGED: %o', event);

	var errorMessage = document.querySelector('.error-message');
	errorMessage.textContent = getErrorMessage(event);
}

var errors = {
	['card-number']: 'Please enter a valid card number',
	['expiry-date']: 'Please enter a valid expiry date',
	['cvv']: 'Please enter a valid cvv code'
};

function getErrorMessage(event) {
	if (event.isValid || event.isEmpty) {
		return '';
	}

	return errors[event.element];
}

Frames.addEventHandler(Frames.Events.CARD_TOKENIZED, onCardTokenized);
function onCardTokenized(event) {
	Frames.addCardToken(form, event.token);
	form.submit();
}

form.addEventListener('submit', function(event) {
	event.preventDefault();
	Frames.submitCard();
});

/* Nubo Office brand pack: written for Nubo OS, not taken from any other brand pack.
 * Sets the product name and link the editor shows, and credits the technology base. */

// A consumer product: no notices for macro authors about the legacy script interface.
window.hideLegacyScriptWarning = true;

var brandProductName = brandProductName === undefined ? 'Nubo Office' : brandProductName;
var brandProductURL = brandProductURL === undefined ? 'https://os.nubosuite.tech/' : brandProductURL;

window.addEventListener('load', function () {
	function retry(fn) { setTimeout(fn, 250); }

	// The logo at the top left: our name, our address.
	function setLogo() {
		var logo = document.querySelector('#document-header > a');
		if (!logo) { retry(setLogo); return; }
		logo.setAttribute('data-cooltip', brandProductName);
		logo.setAttribute('href', brandProductURL);
		logo.addEventListener('click', function (e) {
			e.preventDefault();
			window.open(brandProductURL, '_blank');
		});
	}

	// About window: say what this is built on.
	function setAboutCredit() {
		var lk = document.getElementById('lokit-version');
		var about = document.getElementById('about-dialog-info');
		if (!lk || !about) { retry(setAboutCredit); return; }
		var div = document.createElement('div');
		div.id = 'lokit-extra';
		div.style.marginInlineEnd = 'auto';
		div.textContent = 'Built on Collabora Online and LibreOffice technology';
		lk.parentNode.parentNode.insertBefore(div, lk.parentNode);
	}

	setLogo();
	setAboutCredit();
});

const modal = document.getElementById('pgp-modal');
const link = document.getElementById('pgp-link');
const close = document.querySelector('.modal-close');
const copyBtn = document.getElementById('copy-btn');
const pgpText = document.getElementById('pgp-text');

fetch('keys/publickey.asc')
	.then(res => res.text())
	.then(text => {
		pgpText.textContent = text;
	});

link.addEventListener('click', (e) => {
	e.preventDefault();
	openModal();
	history.replaceState(null, '', '#pgp');
});

close.addEventListener('click', () => {
	closeModal();
});

window.addEventListener('click', (e) => {
	if (e.target === modal) closeModal();
});

copyBtn.addEventListener('click', async () => {
	try {
		await navigator.clipboard.writeText(pgpText.textContent);
		copyBtn.textContent = 'Copied!';
		setTimeout(() => {
			copyBtn.innerHTML = '<img src="icons/copy.svg" alt="Copy"> Copy';
		}, 1000);
	} catch (err) {
		console.error('Copy failed', err);
	}
});

function openModal() {
	modal.style.display = 'block';
	window.scrollTo(0, 0);
}

function closeModal() {
	modal.style.display = 'none';
	if (window.location.hash === '#pgp') history.replaceState(null, '', ' ');
}

if (window.location.hash === '#pgp') {
	openModal();
}

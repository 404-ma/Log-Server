document.getElementById("clear").addEventListener('click', () => {
	fetch("/clear");
	document.getElementById("refresh").textContent = "Refresh to view log changes"
})

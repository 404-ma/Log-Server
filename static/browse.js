document.getElementById('search').addEventListener('click', () => {
	const input = document.getElementById('input');
	console.log(input.value);
	filterFiles(input.value);
})

document.getElementById('clear').addEventListener('click', () => {
	document.getElementById('input').value = '';
	filterFiles("");
})

function loadFiles(files) {
	const fileViewer = document.getElementById('fileViewer');

	document.getElementById('fileCount').textContent = files.length;

	files.forEach(file => {
		const fileElement = document.createElement('div');
		fileElement.classList.add('file');

		const fileIcon = document.createElement('div');
		fileIcon.classList.add('file-icon');
		fileIcon.innerHTML = '📄';
		fileElement.appendChild(fileIcon);

		const fileName = document.createElement('div');
		fileName.classList.add('file-name');
		fileName.textContent = file;
		fileElement.appendChild(fileName);

		fileElement.addEventListener('click', () => {

			const data = { fileName: file };

			fetch('/choosefile', {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json',
				},
				body: JSON.stringify(data),
			})
				.then(response => response.json())
				.then(data => {
					// window.location.reload();
					document.getElementById('ogSelected').textContent = '';
					document.getElementById('newSelected').textContent = `Selected File: ${file}`;
				})
				.catch((error) => {
					console.error('Error:', error);
					alert("an error occured.");
				});
		});

		fileViewer.appendChild(fileElement);
	});
}

function filterFiles(searchTerm) {
	const files = Array.from(fileNames).filter(a => a.trim().includes(searchTerm.trim()));
	console.log(files);

	const fileViewer = document.getElementById('fileViewer');
	fileViewer.innerHTML = "";

	loadFiles(files);
}

loadFiles(window.fileNames);

function confirmDelete(conferenceId, contextPath) {
    if (confirm('Are you sure you want to delete this conference?')) {
        const form = document.createElement('form');
        form.method = 'post';
        form.action = contextPath + '/conference/' + conferenceId;
        
        const methodInput = document.createElement('input');
        methodInput.type = 'hidden';
        methodInput.name = '_method';
        methodInput.value = 'DELETE';
        form.appendChild(methodInput);
        
        document.body.appendChild(form);
        form.submit();
    }
}
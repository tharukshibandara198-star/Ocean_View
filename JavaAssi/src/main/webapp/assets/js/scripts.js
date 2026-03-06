/* ================================================================
   scripts.js  —  Ocean View Resort Client-Side Utilities
   ================================================================ */

/**
 * Auto-uppercase Reservation Number input fields as the user types.
 * This prevents case-mismatch when searching (e.g. ovr-00001 → OVR-00001).
 */
document.querySelectorAll('input[name="reservationNo"]').forEach(function(input) {
    input.addEventListener('input', function() {
        this.value = this.value.toUpperCase();
    });
});

/**
 * Confirmation dialog before navigating away from an unsaved form.
 * Attaches to forms with class 'confirm-leave'.
 */
(function() {
    var dirtyForms = document.querySelectorAll('form.confirm-leave');
    dirtyForms.forEach(function(form) {
        var isDirty = false;
        form.addEventListener('input', function() { isDirty = true; });
        form.addEventListener('submit', function() { isDirty = false; });
        window.addEventListener('beforeunload', function(e) {
            if (isDirty) {
                e.preventDefault();
                e.returnValue = '';
            }
        });
    });
})();

/**
 * Highlights table rows on click (useful for large reservation tables).
 */
(function() {
    var table = document.getElementById('reservationTable');
    if (!table) return;
    table.querySelectorAll('tbody tr').forEach(function(row) {
        row.style.cursor = 'pointer';
        row.addEventListener('click', function() {
            // Remove highlight from all rows
            table.querySelectorAll('tbody tr').forEach(function(r) {
                r.classList.remove('table-active');
            });
            this.classList.add('table-active');
        });
    });
})();

/**
 * Auto-dismiss success alerts after 5 seconds.
 */
(function() {
    var alerts = document.querySelectorAll('.alert-success');
    alerts.forEach(function(alert) {
        setTimeout(function() {
            var bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });
})();

/**
 * Show a spinner on the submit button while a form is being submitted.
 * Prevents double-submission.
 */
(function() {
    document.querySelectorAll('form').forEach(function(form) {
        form.addEventListener('submit', function(e) {
            // Only if the form is valid (no is-invalid fields)
            var hasInvalid = form.querySelectorAll('.is-invalid').length > 0;
            if (!hasInvalid) {
                var submitBtn = form.querySelector('button[type="submit"]');
                if (submitBtn) {
                    submitBtn.disabled = true;
                    var original = submitBtn.innerHTML;
                    submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status"></span>Processing...';
                    // Re-enable after 8 seconds as a safety fallback
                    setTimeout(function() {
                        submitBtn.disabled = false;
                        submitBtn.innerHTML = original;
                    }, 8000);
                }
            }
        });
    });
})();

// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use TypeScript in this file: www.typescriptlang.org
window.alertQueue = [];
window.addEventListener("load", function (e) {
    var alerts = document.querySelectorAll(".alert");
    alerts.forEach(function (f) {
        window.alertQueue.push(f);
    });
    if (window.alertQueue.length !== 0) {
        runAlerts();
    }
});
function runAlerts() {
    var alert = window.alertQueue.pop();
    alert.classList.add("active");
    window.setTimeout((function (e) {
        e.classList.remove("active");
        window.setTimeout((function (f) {
            f.parentNode.removeChild(f);
            runAlerts();
        }).bind(null, e), 300);
    }).bind(null, alert), 5000);
}

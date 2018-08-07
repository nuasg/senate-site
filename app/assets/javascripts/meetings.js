function initMeetings() {
    var x = document.querySelector("#term-select");
    if (x != null) {
        var n = x;
        n.addEventListener("change", function () {
            window.location.href = this.options[this.selectedIndex].dataset.url;
        });
    }
}
window.addEventListener("load", initMeetings);

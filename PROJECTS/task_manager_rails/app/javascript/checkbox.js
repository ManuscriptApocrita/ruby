document.addEventListener("DOMContentLoaded", function() {
    var checkbox = document.getElementById("myCheckbox");

    function saveCheckboxState() {
        localStorage.setItem("checkboxState", checkbox.checked);
    }

    checkbox.addEventListener("change", saveCheckboxState);

    var savedState = localStorage.getItem("checkboxState");
    if (savedState === "true") {
        checkbox.checked = true;
    } else {
        checkbox.checked = false;
    }
});
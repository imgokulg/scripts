function getRandomEmail() {
    let chars = 'abcdefghijklmnopqrstuvwxyz';
    let email = '';

    [['.', 6, 10], ['.', 4, 7], ['@', 5, 8]].forEach((eleArr) => {
        email += eleArr[0];
        const min = eleArr[1];
        const max = eleArr[2];
        let size = getRandomNumber(min, max);
        for (var index = 0; index < size; index++) {
            email += chars[Math.floor(Math.random() * chars.length)];
        }
    });
    return email + '.com';
}

function getRandomNumber(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

function downloadJSON(responseJson, fileName) {
    if (fileName == undefined || fileName == "") {
        fileName = location.href.split("/").slice(-1)[0];
    }
    const elementId = fileName + "_" + new Date().getTime();
    document.body.innerHTML += "<a id='"+elementId+"' style='display:none'></a>";
    responseJson = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(responseJson));
    let dlAnchorElem = document.getElementById(elementId);
    dlAnchorElem.setAttribute("href", responseJson);
    dlAnchorElem.setAttribute("download", fileName + ".json");
    dlAnchorElem.click();
}
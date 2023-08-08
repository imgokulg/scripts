function getRandomEmail() {
    let chars = 'abcdefghijklmnopqrstuvwxyz';
    let email = '';

    [['', 6, 10], ['.', 4, 7], ['@', 5, 8]].forEach((eleArr) => {
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

async function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

function downloadJSON(responseJson, fileName) {
    if (fileName == undefined || fileName == "") {
        fileName = location.href.split("/").slice(-1)[0];
    }
    const elementId = fileName + "_" + new Date().getTime();
    document.body.innerHTML += "<a id='" + elementId + "' style='display:none'></a>";
    responseJson = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(responseJson));
    let dlAnchorElem = document.getElementById(elementId);
    dlAnchorElem.setAttribute("href", responseJson);
    dlAnchorElem.setAttribute("download", fileName + ".json");
    dlAnchorElem.click();
}

function isBase64(str) {
    if (str != undefined && str != '' && str.trim() != '') {
        const base64regex = /^([0-9a-zA-Z+/]{4})*(([0-9a-zA-Z+/]{2}==)|([0-9a-zA-Z+/]{3}=))?$/;
        try {
            return (btoa(atob(str)) == str) || base64regex.test(str);
        } catch (err) {
        }
    }
    return false;
}

async function sha256(message) {
    // encode as UTF-8
    const msgBuffer = new TextEncoder().encode(message);                    

    // hash the message
    const hashBuffer = await crypto.subtle.digest('SHA-256', msgBuffer);

    // convert ArrayBuffer to Array
    const hashArray = Array.from(new Uint8Array(hashBuffer));

    // convert bytes to hex string                  
    const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
    return hashHex;
}

function loadJS(FILE_URL, async = true) {
  let scriptEle = document.createElement("script");

  scriptEle.setAttribute("src", FILE_URL);
  scriptEle.setAttribute("type", "text/javascript");
  scriptEle.setAttribute("async", async);

  document.body.appendChild(scriptEle);

  // success event 
  scriptEle.addEventListener("load", () => {
    console.log("File loaded")
  });
   // error event
  scriptEle.addEventListener("error", (ev) => {
    console.log("Error on loading file", ev);
  });
}

function getRandomElementFromTheArray(array) {
  return array[Math.floor((Math.random()*array.length))];
}

function shuffleArray(array) {
  array.sort(() => Math.random() - 0.5);
}

function getCSVContent(rows){
    return "data:text/csv;charset=utf-8," 
    + rows.map(e => e.join(",")).join("\n");
}

function copyToClipBoard(text){
    let copyText = document.createElement("input");
    copyText.value = text;
    document.body.appendChild(copyText);
    copyText.select();
    document.execCommand("copy");
    document.body.removeChild(copyText);
}

//Cookies.set(cookie["name"],cookie["value"],{ path: cookie["path"], domain: cookie["domain"],expires:365,SameSite=cookie["sameSite"],Secure:cookie["secure"],SameParty:true,Priority:"High"});

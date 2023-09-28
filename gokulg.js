// ==UserScript==
// @name         instagram Profile Posts
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        https://www.instagram.com/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=instagram.com
// @grant        none
// ==/UserScript==

(async function() {
    'use strict';

    const userName = window.location.pathname.replaceAll('/', '');
    let data = await getProfileFeedData(`https://www.instagram.com/api/v1/feed/user/${userName}/username/?count=12`);

    let posts = await getItemData(data.items);

    const userId = data.user.pk_id;
    let maxCall = 1;
    let currentCall = 0;
    while (data.more_available && currentCall < maxCall) {
        let nextMaxId = data.next_max_id;
        data = await getProfileFeedData(`https://www.instagram.com/api/v1/feed/user/${userId}/?count=12&max_id=${nextMaxId}`);
        let postsTemp = await getItemData(data.items);
        posts = posts.concat(postsTemp);
        currentCall++;
    }

    //console.log(posts);
    let stories = await getProfileFeedData(`https://www.instagram.com/api/v1/feed/reels_media/?reel_ids=${userId}`);
    console.log(stories);
    stories = stories.reels[userId].items;

    const storyURLS = await getItemData(stories);
    console.log(storyURLS);
    storyURLS.forEach(e => downloadFile(e.url, userName + "_" + userId + "__" + e.time + "." + e.type));
})();

async function getItemData(items) {
    let itemData = [];
    for (let i = 0; i < items.length; i++) {
        let item = items[i];
        let medias;
        let type = "jpg";
        if (item.carousel_media != undefined) {
            let car = await getItemData(item.carousel_media);
            itemData = itemData.concat(car);
        } else {
            if (item.video_versions != undefined) {
                medias = item.video_versions;
                type = "mp4";
            } else {
                medias = item.image_versions2.candidates;
            }

            let mediaUrl;
            for (let j = 0; j < medias.length; j++) {
                let media = medias[j];
                mediaUrl = media.url;
                if (media.width == item.original_width && media.height == item.original_height) {
                    break;
                }
            }

            itemData.push({ "url": mediaUrl, "type": type, "time": (new Date(item.device_timestamp / 1000).toLocaleDateString().replaceAll("/", "_") + " " + new Date(item.device_timestamp / 1000).toLocaleTimeString()) });

        }
    }
    return itemData;
}

async function getProfileFeedData(uri) {
    const data = await fetch(uri, {
            "headers": {
                "accept": "*/*",
                "accept-language": "en-IN,en;q=0.9,ta;q=0.8,es;q=0.7,en-GB;q=0.6,en-US;q=0.5",
                "cache-control": "no-cache",
                "dpr": "1",
                "pragma": "no-cache",
                "sec-ch-prefers-color-scheme": "dark",
                "sec-ch-ua": "\"Chromium\";v=\"116\", \"Not)A;Brand\";v=\"24\", \"Google Chrome\";v=\"116\"",
                "sec-ch-ua-full-version-list": "\"Chromium\";v=\"116.0.5845.111\", \"Not)A;Brand\";v=\"24.0.0.0\", \"Google Chrome\";v=\"116.0.5845.111\"",
                "sec-ch-ua-mobile": "?0",
                "sec-ch-ua-platform": "\"Windows\"",
                "sec-ch-ua-platform-version": "\"15.0.0\"",
                "sec-fetch-dest": "empty",
                "sec-fetch-mode": "cors",
                "sec-fetch-site": "same-origin",
                "viewport-width": "1920",
                "x-asbd-id": "129477",
                "x-ig-app-id": "936619743392459",
                "x-ig-www-claim": "0",
                "x-requested-with": "XMLHttpRequest"
            },
            "referrer": "https://www.instagram.com/",
            "referrerPolicy": "strict-origin-when-cross-origin",
            "body": null,
            "method": "GET",
            "mode": "cors",
            "credentials": "include"
        }).then(e => e.json())
        .then(e => { return e; });
    return data;
}

function downloadFile(url, fileName) {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", url, true);
    xhr.responseType = "blob";
    xhr.onload = function() {
        var urlCreator = window.URL || window.webkitURL;
        var imageUrl = urlCreator.createObjectURL(this.response);
        var tag = document.createElement('a');
        tag.href = imageUrl;
        tag.download = fileName;
        document.body.appendChild(tag);
        tag.click();
        document.body.removeChild(tag);
    }
    xhr.send();
}

async function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

function sendRequest(url, method, params) {
    let xhr = new XMLHttpRequest();
    xhr.open(method, url);
    xhr.onreadystatechange = function() {
        console.log(xhr.responseText);
    };
    xhr.send(JSON.stringify(params));

}

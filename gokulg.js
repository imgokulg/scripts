function geRandomEmail() {
    let chars = 'abcdefghijklmnopqrstuvwxyz';
    let email = '';

    [['.',6,10],['.',4,7],['@',5,8]].forEach( (eleArr) => {
        email += eleArr[0];
        const min = eleArr[1];
        const max = eleArr[2];
        let size = geRandomNumber(min, max);
        for(var index=0; index<size; index++){
            email += chars[Math.floor(Math.random() * chars.length)];
        }
    });
    return email + '.com';
}

function geRandomNumber(min,max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}
function alertMessage() {

    window.dataLayer = window.dataLayer || [];
    function gtag(){
        var x = dataLayer.push(arguments);
        console.log(x);
    	console.log('hete');
            console.log(arguments);

    }
    gtag('js', new Date());
      gtag('send','event','submit','TRACK_EVENT')
            gtag('send', 'event', 'submit', 'Click Text',);
            gtag('send', 'event', 'submit1', 'Click Text',);


            console.log(dataLayer);




}

// window.logger = (flutter_value) => {
//    console.log({ js_context: this, flutter_value });
// }

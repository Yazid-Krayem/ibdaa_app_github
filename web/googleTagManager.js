function alertMessage() {

    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
  
    gtag('config', 'UA-177911673-1');
    gtag('send','event','submit','TRACK_EVENT')
            gtag('send', 'event', 'submit', 'Click Text',);
            gtag('send', 'event', 'submit1', 'Click Text',);


}

// window.logger = (flutter_value) => {
//    console.log({ js_context: this, flutter_value });
// }

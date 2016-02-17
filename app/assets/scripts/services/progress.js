angular.module('geckoCliApp')  
.factory('Progress', function (ngProgressFactory) {
    var timer;
    var progressbar = ngProgressFactory.createInstance();
    return {
        start: function () {
            var me = this;
            // reset the status of the progress bar
            me.reset();
            // if the `complete` method is not called
            // complete the progress of the bar after 5 seconds
            timer = setTimeout(function () {
                me.complete();
            }, 5000);
        },
        complete: function () {
            progressbar.complete();
            if (timer) {
                // remove the 5 second timer
                clearTimeout(timer);
                timer = null;
            }
        },
        reset: function () {             
            if (timer) {
                // remove the 5 second timer
                clearTimeout(timer);
                // reset the progress bar
                progressbar.reset();
            }
            // start the progress bar
            progressbar.start();
        }
    };
});
/**=========================================================
 * Module: VendorAssetsConstant.js
 =========================================================*/

(function() {
    'use strict';

    angular
        .module('naut')
        .constant('VENDOR_ASSETS', {
            // jQuery based and standalone scripts
            scripts: {
              'animate':            ['/assets/animate.css/animate.min.css'],
              'icons':              ['/assets/font-awesome/css/font-awesome.min.css',
                                     '/assets/weather-icons/css/weather-icons.min.css',
                                     '/assets/feather/webfont/feather-webfont/feather.css'],
              'sparklines':         ['/assets/plugins/sparklines/jquery.sparkline.min.js'],
              'slimscroll':         ['/assets/slimscroll/jquery.slimscroll.min.js'],
              'screenfull':         ['/assets/screenfull/dist/screenfull.js'],
              'vectormap':          ['/assets/ika.jvectormap/jquery-jvectormap-1.2.2.min.js',
                                     '/assets/ika.jvectormap/jquery-jvectormap-1.2.2.css'],
              'vectormap-maps':      ['/assets/ika.jvectormap/jquery-jvectormap-world-mill-en.js',
                                     '/assets/ika.jvectormap/jquery-jvectormap-us-mill-en.js'],
              'loadGoogleMapsJS':   ['/assets/plugins/gmap/load-google-maps.js'],
              'flot-chart':         ['/assets/flot/jquery.flot.js'],
              'flot-chart-plugins': ['/assets/flot.tooltip/js/jquery.flot.tooltip.min.js',
                                     '/assets/flot/jquery.flot.resize.js',
                                     '/assets/flot/jquery.flot.pie.js',
                                     '/assets/flot/jquery.flot.time.js',
                                     '/assets/flot/jquery.flot.categories.js',
                                     '/assets/flot-spline/js/jquery.flot.spline.min.js'],
              'jquery-ui':          ['/assets/jquery-ui/jquery-ui.min.js',
                                     '/assets/jqueryui-touch-punch/jquery.ui.touch-punch.min.js'],
              'moment' :            ['/assets/moment/min/moment-with-locales.min.js'],
              'gcal':               ['/assets/fullcalendar/dist/gcal.js'],
              'blueimp-gallery':    ['/assets/blueimp-gallery/js/jquery.blueimp-gallery.min.js',
                                     '/assets/blueimp-gallery/css/blueimp-gallery.min.css'],
              'filestyle':          ['/assets/bootstrap-filestyle/src/bootstrap-filestyle.js'],
              'nestable':           ['/assets/nestable/jquery.nestable.js']
            },
            // Angular modules scripts (name is module name to be injected)
            modules: [
              {name: 'toaster',           files: ['/assets/angularjs-toaster/toaster.js',
                                                  '/assets/angularjs-toaster/toaster.css']},
              {name: 'ui.knob',           files: ['/assets/angular-knob/src/angular-knob.js',
                                                  '/assets/jquery-knob/dist/jquery.knob.min.js']},
              {name: 'easypiechart',      files:  ['/assets/jquery.easy-pie-chart/dist/angular.easypiechart.min.js']},
              {name: 'angularFileUpload', files: ['/assets/angular-file-upload/angular-file-upload.min.js']},
              {name: 'ngTable',           files: ['/assets/ng-table/dist/ng-table.min.js',
                                                  '/assets/ng-table/dist/ng-table.min.css']},
              {name: 'ngTableExport',     files: ['/assets/ng-table-export/ng-table-export.js']},
              {name: 'ui.map',            files: ['/assets/angular-ui-map/ui-map.min.js']},
              {name: 'ui.calendar',       files: ['/assets/fullcalendar/dist/fullcalendar.min.js',
                                                  '/assets/fullcalendar/dist/fullcalendar.css',
                                                  '/assets/angular-ui-calendar/src/calendar.js']},
              {name: 'angularBootstrapNavTree',   files: ['/assets/angular-bootstrap-nav-tree/dist/abn_tree_directive.js',
                                                          '/assets/angular-bootstrap-nav-tree/dist/abn_tree.css']},
              {name: 'htmlSortable',              files: ['/assets/html.sortable/dist/html.sortable.js',
                                                          '/assets/html.sortable/dist/html.sortable.angular.js']},
              {name: 'xeditable',                 files: ['/assets/angular-xeditable/dist/js/xeditable.js',
                                                          '/assets/angular-xeditable/dist/css/xeditable.css']},
              {name: 'angularFileUpload',         files: ['/assets/angular-file-upload/angular-file-upload.js']},
              {name: 'ngImgCrop',                 files: ['/assets/ng-img-crop/compile/unminified/ng-img-crop.js',
                                                          '/assets/ng-img-crop/compile/unminified/ng-img-crop.css']},
              {name: 'ui.select',                 files: ['/assets/angular-ui-select/dist/select.js',
                                                          '/assets/angular-ui-select/dist/select.css']},
              {name: 'textAngular',               files: ['/assets/textAngular/dist/textAngular.css',
                                                          '/assets/textAngular/dist/textAngular-rangy.min.js',                                                          
                                                          '/assets/textAngular/dist/textAngular-sanitize.js',
                                                          '/assets/textAngular/src/globals.js',
                                                          '/assets/textAngular/src/factories.js',
                                                          '/assets/textAngular/src/DOM.js',
                                                          '/assets/textAngular/src/validators.js',
                                                          '/assets/textAngular/src/taBind.js',
                                                          '/assets/textAngular/src/main.js',
                                                          '/assets/textAngular/dist/textAngularSetup.js'
                                                          ], serie: true},
              {name: 'vr.directives.slider',      files: ['/assets/venturocket-angular-slider/build/angular-slider.min.js']},
              {name: 'datatables',                files: ['/assets/datatables/media/css/jquery.dataTables.min.css',
                                                          '/assets/datatables/media/js/jquery.dataTables.min.js',
                                                          '/assets/angular-datatables/dist/angular-datatables.min.js']},
              {name: 'oitozero.ngSweetAlert',     files: ['/assets/sweetalert/dist/sweetalert.css',
                                                          '/assets/sweetalert/dist/sweetalert.min.js',
                                                          '/assets/angular-sweetalert/SweetAlert.js']}
            ]

        });

})();


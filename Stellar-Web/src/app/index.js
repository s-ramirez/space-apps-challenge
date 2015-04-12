'use strict';

angular.module('stellar', ['ngAnimate', 'ngCookies', 'ngTouch', 'ngSanitize', 'ngResource', 'ngRoute', 'ngMaterial', 'parse-angular', 'chart.js'])
	.config(function ($routeProvider, $mdThemingProvider) {
		Parse.initialize('XcKF1osnd9lmHdNW0A3PCvinbCZeYnGb9l1vlT6R','DWq5BteqorV46bjbVSlL87lAWC904L9kOu18odTo');
		$routeProvider
			.when('/', {
				templateUrl: 'app/main/main.html',
				controller: 'MainCtrl',
				controllerAs: 'main'
			})
			.when('/secondary', {
				templateUrl: 'app/secondary/secondary.html',
				controller: 'SecondaryCtrl'
			})
			.otherwise({
				redirectTo: '/'
			});

	  var stellarPal = $mdThemingProvider.extendPalette('orange', {
    	'500': 'ED5032',
    	'300': '4D7081'
  	  });
      $mdThemingProvider.definePalette('stellarPal', stellarPal);

      $mdThemingProvider.theme('default')
        .primaryPalette('stellarPal', {
        	'hue-3': '300'
        })
	});

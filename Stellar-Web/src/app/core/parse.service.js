(function() {
	'use strict';

	angular
		.module('stellar')
		.service('parseService', parseService);

	parseService.$inject = ["$q"];

	function parseService($q) {
		var service = {
			parseLogin: parseLogin,
			getCurrentUser: getCurrentUser,
			getAllUsers: getAllUsers,
			sendNotificationToChannel: sendNotificationToChannel,
			getChallenges: getChallenges
		};

		return service;

		function returnCachedValue(val) {
			var deferred = $q.defer();
			deferred.resolve(val); 
        	return deferred.promise;
		}

		function getCurrentUser() {
			return Parse.User.current();
		}

		function parseLogin(username, password) {
			return Parse.User.logIn(username, password, {}).then(function (data) {
				return data;
			});
		}

		// var query = new Parse.Query('Area');
		// query.include('fk_AreaType');
		// query.equalTo('fk_Branch', branch);

		function getAllUsers() {
			var query = new Parse.Query(Parse.User);

			return query.find().then(function (results) {
				return results;
			});
		}

		function getChallenges() {
			var query = new Parse.Query('Challenge');

			return query.find();
		}

		function sendNotificationToChannel(msg, channel) {
			var query = new Parse.Query(Parse.Installation);
			query.equalTo('channels', channel);

			return Parse.Push.send({
				where: query,
				data: {
					alert: msg
				}
			});
		}
	}
})();
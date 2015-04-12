(function() {
  'use strict';

  angular
    .module('stellar')
    .controller('MainCtrl', MainCtrl);

  MainCtrl.$inject = ['$scope', '$rootScope', 'parseService'];

  function MainCtrl($scope, $rootScope, parseService) {
    $rootScope.title = "Challenges";

    var vm = this;

    activate();

    function activate() {
      parseService.getAllUsers().then(function (data) {
        vm.allUsers = data;
      });

      parseService.getChallenges().then(function (data) {
        vm.challenges = data;
      });
    }
  }
})();
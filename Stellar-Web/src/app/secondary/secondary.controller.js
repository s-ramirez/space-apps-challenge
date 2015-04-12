(function() {
    'use strict';
    
    function SecondaryCtrl() {
        var vm = this;
        
        vm.init = function () {
        }

        vm.init();
    }
    
    SecondaryCtrl.$inject = [];
    
    angular
        .module('stellar')
        .controller('SecondaryCtrl', SecondaryCtrl);
})();
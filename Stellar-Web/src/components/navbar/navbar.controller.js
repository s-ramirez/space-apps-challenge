(function() {
    'use strict';
    
    function NavbarCtrl($mdSidenav) {
        var vm = this;
        
		vm.openSidebar = function() {
			$mdSidenav('sidebar').toggle();
		};
    }
    
    NavbarCtrl.$inject = ['$mdSidenav'];
    
    angular
        .module('stellar')
        .controller('NavbarCtrl', NavbarCtrl);
})();
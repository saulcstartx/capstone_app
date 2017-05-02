(function() {
  "use strict";

  angular
    .module("spa-demo.tags")
    .component("sdThingTypeSearch", {
      templateUrl: templateUrl,
      controller: ThingTypeSearchController,
    });


  templateUrl.$inject = ["spa-demo.config.APP_CONFIG"];
  function templateUrl(APP_CONFIG) {
    return APP_CONFIG.current_thing_type_search_html;
  }    

  ThingTypeSearchController.$inject = ["$scope", "spa-demo.tags.thingType"];
  function ThingTypeSearchController($scope, thingType) {
    var vm=this;
    vm.lookupType=lookupType;

    vm.$onInit = function() {
      //console.log("ThingTypeSearchController",$scope);
    }
    return;
    //////////////
    function lookupType() {
      console.log("lookupType for", vm.tag);
      if(vm.tag) {
        thingType.setTag(vm.tag);
      }
      else{
        thingType.clearTag();
      }
    }

  }
})();
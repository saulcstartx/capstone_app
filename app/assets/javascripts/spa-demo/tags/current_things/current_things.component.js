(function() {
  "use strict";

  angular
    .module("spa-demo.tags")
    .component("sdCurrentTagThings", {
      templateUrl: tagThingsTemplateUrl,
      controller: CurrentTagThingsController,
    })
    .component("sdCurrentTagThingInfo", {
      templateUrl: tagThingInfoTemplateUrl,
      controller: CurrentTagThingInfoController,
    })
    ;

  tagThingsTemplateUrl.$inject = ["spa-demo.config.APP_CONFIG"];
  function tagThingsTemplateUrl(APP_CONFIG) {
    return APP_CONFIG.current_tag_things_html;
  }    
  tagThingInfoTemplateUrl.$inject = ["spa-demo.config.APP_CONFIG"];
  function tagThingInfoTemplateUrl(APP_CONFIG) {
    return APP_CONFIG.current_tag_thing_info_html;
  }    

  CurrentTagThingsController.$inject = ["$scope",
                                     "spa-demo.tags.currentTags"];
  function CurrentTagThingsController($scope,currentTags) {
    var vm=this;
    vm.thingClicked = thingClicked;
    vm.isCurrentThing = currentTags.isCurrentThingIndex;

    vm.$onInit = function() {
      console.log("CurrentTagThingsController",$scope);
    }
    vm.$postLink = function() {
      $scope.$watch(
        function() { return currentTags.getThings(); }, 
        function(things) { vm.things = things; }
      );
    }    
    return;
    //////////////
    function thingClicked(index) {
      currentTags.setCurrentThing(index);
    }    
  }

  CurrentTagThingInfoController.$inject = ["$scope",
                                        "spa-demo.tags.currentTags",
                                        "spa-demo.subjects.Thing",
                                        "spa-demo.authz.Authz"];
  function CurrentTagThingInfoController($scope,currentTags, Thing, Authz) {
    var vm=this;
    vm.nextThing = currentTags.nextThing;
    vm.previousThing = currentTags.previousThing;

    vm.$onInit = function() {
      console.log("CurrentTagThingInfoController",$scope);
    }
    vm.$postLink = function() {
      $scope.$watch(
        function() { return currentTags.getCurrentThing(); }, 
        newThing 
      );
      $scope.$watch(
        function() { return Authz.getAuthorizedUserId(); },
        function() { newThing(currentTags.getCurrentThing()); }
      );        
    }    
    return;
    //////////////
    function newThing(link) {
      vm.link = link; 
      vm.thing = null;
      if (link && link.thing_id) {
        vm.thing=Thing.get({id:link.thing_id});
      }
    }

  }
})();

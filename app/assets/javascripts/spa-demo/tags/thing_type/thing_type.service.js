(function() {
  "use strict";

  angular
    .module("spa-demo.tags")
    .service("spa-demo.tags.thingType", ThingType);

  ThingType.$inject = ["$rootScope"];
  function ThingType($rootScope) {
    var service = this;
    this.version=0;
    this.tag=null; 

    return;
    ////////////////
  }
  ThingType.prototype.getVersion = function() {
    return this.version;
  }  
  ThingType.prototype.clearTag = function() {
    this.tag=null;
    this.version += 1;
  }  
  ThingType.prototype.setTag = function(tag) {
    console.log("setTag", tag);
    this.tag = angular.copy(tag);
    this.version += 1;
  }
  ThingType.prototype.getTag = function() {
    return this.tag;
  }
})();
(function() {
  "use strict";

  angular
    .module("spa-demo.tags")
    .component("sdCurrentTagImages", {
      templateUrl: imagesTagTemplateUrl,
      controller: CurrentTagImagesController,
    })
    .component("sdCurrentTagImageViewer", {
      templateUrl: tagImageViewerTemplateUrl,
      controller: CurrentTagImageViewerController,
      bindings: {
        name: "@",
        minWidth: "@"
      }
    })
    ;

  imagesTagTemplateUrl.$inject = ["spa-demo.config.APP_CONFIG"];
  function imagesTagTemplateUrl(APP_CONFIG) {
    return APP_CONFIG.current_tag_images_html;
  }    
  tagImageViewerTemplateUrl.$inject = ["spa-demo.config.APP_CONFIG"];
  function tagImageViewerTemplateUrl(APP_CONFIG) {
    return APP_CONFIG.current_tag_image_viewer_html;
  }    

  CurrentTagImagesController.$inject = ["$scope",
                                     "spa-demo.tags.currentTags"];
  function CurrentTagImagesController($scope, currentTags) {
    var vm=this;
    vm.imageClicked = imageClicked;
    vm.isCurrentImage = currentTags.isCurrentImageIndex;

    vm.$onInit = function() {
      console.log("CurrentTagImagesController",$scope);
    }
    vm.$postLink = function() {
      $scope.$watch(
        function() { return currentTags.getImages(); }, 
        function(images) { vm.images = images; }
      );
    }    
    return;
    //////////////
    function imageClicked(index) {
      currentTags.setCurrentImage(index);
    }
  }

  CurrentTagImageViewerController.$inject = ["$scope",
                                          "spa-demo.tags.currentTags"];
  function CurrentTagImageViewerController($scope, currentTags) {
    var vm=this;
    vm.viewerIndexChanged = viewerIndexChanged;

    vm.$onInit = function() {
      console.log("CurrentTagImageViewerController",$scope);
    }
    vm.$postLink = function() {
      $scope.$watch(
        function() { return currentTags.getImages(); }, 
        function(images) { vm.images = images; }
      );
      $scope.$watch(
        function() { return currentTags.getCurrentImageIndex(); }, 
        function(index) { vm.currentImageIndex = index; }
      );
    }    
    return;
    //////////////
    function viewerIndexChanged(index) {
      console.log("viewer index changed, setting currentImage", index);
      currentTags.setCurrentImage(index);
    }
  }

})();

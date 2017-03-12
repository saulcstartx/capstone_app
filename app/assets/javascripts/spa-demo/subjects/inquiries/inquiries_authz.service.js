(function() {
  "use strict";

  angular
    .module("spa-demo.subjects")
    .factory("spa-demo.subjects.InquiriesAuthz", InquiriesAuthzFactory);

  InquiriesAuthzFactory.$inject = ["spa-demo.authz.Authz",
                                "spa-demo.authz.BasePolicy"];
  function InquiriesAuthzFactory(Authz, BasePolicy) {
    function InquiriesAuthz() {
      BasePolicy.call(this, "Inquiry");
    }
      //start with base class prototype definitions
    InquiriesAuthz.prototype = Object.create(BasePolicy.prototype);
    InquiriesAuthz.constructor = InquiriesAuthz;

      //override methods
    InquiriesAuthz.prototype.canQuery=function() {
      return Authz.isOriginator(this.resourceName);
    };

    InquiriesAuthz.prototype.canCreate=function() {
      return Authz.isOriginator(this.resourceName);
    };
    InquiriesAuthz.prototype.canDelete = function(inquiry) {
      return (inquiry && inquiry.id && this.canUpdate(inquiry)) == true;
    };
    InquiriesAuthz.prototype.canGetDetails = function(inquiry) {
      if (!inquiry) {
        return false;
      } else {
        return !inquiry.id ? this.canCreate() : Authz.isOrganizer(inquiry);
      }
    };
    
    return new InquiriesAuthz();
  }
})();
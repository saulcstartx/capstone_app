class InquiryPolicy < ApplicationPolicy
  def index?
    originator?
  end
  def show?
    organizer?
  end
  def create?
    originator?
  end
  def update?
    organizer?
  end
  def destroy?
    organizer?
  end

  class Scope < Scope
    def user_roles
      joins_clause=["join Roles r on r.mname='Inquiry'",
                    "r.mid=Inquiries.id",
                    "r.user_id #{user_criteria}"].join(" and ")
      scope.select("Inquiries.*, r.role_name")
           .joins(joins_clause)
    end

    def resolve
      user_roles
    end
  end
end

# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(person)
    return unless person.present?

    return unless person.intermediary? || person.admin?

    can :read, Person
    can :update, Person, :type_cd
    cannot :update, Person, &:admin?

    return unless person.admin?

    can [:read, :destroy], Person
    can [:create, :update], Person, [:email, :password, :type_cd]
  end
end

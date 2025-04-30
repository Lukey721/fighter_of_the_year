# frozen_string_literal: true

class TestController < ApplicationController
  before_action :require_login, only: [:private_action]
  before_action :require_admin, only: [:admin_action]

  def index
    render plain: 'Index OK'
  end

  def private_action
    render plain: 'Private Access OK'
  end

  def admin_action
    render plain: 'Admin Access OK'
  end
end

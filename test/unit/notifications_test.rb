# -*- encoding : utf-8 -*-
require 'test_helper'

class NotificationsTest < ActionMailer::TestCase
  test "errors" do
    @expected.subject = 'Notifications#errors'
    @expected.body    = read_fixture('errors')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifications.create_errors(@expected.date).encoded
  end

end

require 'test_helper'

class DriverMessagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:driver)
  end

  test "can post a message" do
    ride = rides(:driver_created)

    assert_difference -> {ride.reload.messages.count} do
      post driver_ride_messages_url(ride), params: {
        message: { content: "Hello there" }
      }
    end

    assert_redirected_to driver_ride_url(ride)
  end

  test "can't post an empty message" do
    ride = rides(:driver_created)

    assert_no_difference -> {ride.reload.messages.count} do
      post driver_ride_messages_url(ride), params: {
        message: { content: "" }
      }
    end

    assert_redirected_to driver_ride_url(ride)
  end
end

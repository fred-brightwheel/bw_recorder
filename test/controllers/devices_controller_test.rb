require "test_helper"

class DevicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @device_id = 23
    @latest_count = 100
    @older_count = 200
    @oldest_count = 300

    params = {
      id: @device_id,
      readings: [
        { timestamp: 1.day.ago.iso8601, count: @latest_count },
        { timestamp: 2.days.ago.iso8601, count: @older_count },
        { timestamp: 3.days.ago.iso8601, count: @oldest_count }
      ]
    }

    post '/readings', params: params, as: :json
    assert_response :created
  end

  test 'total_count' do
    get "/devices/#{@device_id}/total_count", as: :json
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal [@latest_count, @older_count, @oldest_count].sum, json['count']
  end

  test 'total_count with unknown id' do
    get "/devices/woot/total_count", as: :json
    assert_response :not_found
  end

  test 'latest_count' do
    get "/devices/#{@device_id}/latest_count", as: :json
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal @latest_count, json['count']
  end

  test 'latest_count with unknown id' do
    get "/devices/woot/latest_count", as: :json
    assert_response :not_found
  end
end

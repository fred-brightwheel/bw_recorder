require "test_helper"

class ReadingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @device_id = 23
  end

  test 'create' do
    params = {
      id: @device_id,
      readings: [
        { timestamp: Time.current.iso8601, count: 23 }
      ]
    }

    post '/readings', params: params, as: :json
    assert_response :created
  end

  test 'create with multiple readings' do
    params = {
      id: @device_id,
      readings: [
        { timestamp: Time.current.iso8601, count: 23 },
        { timestamp: 1.day.ago.iso8601, count: 22 },
        { timestamp: 2.days.ago.iso8601, count: 21 },
      ]
    }

    post '/readings', params: params, as: :json
    assert_response :created
  end

  test 'create with duplicate readings' do
    params = {
      id: @device_id,
      readings: [
        { timestamp: Time.current.iso8601, count: 1 },
        { timestamp: Time.current.iso8601, count: 2 },
        { timestamp: Time.current.iso8601, count: 3 }
      ]
    }

    post '/readings', params: params, as: :json
    assert_response :created
  end

  test 'create with missing id' do
    params = {
      readings: [
        { timestamp: Time.current.iso8601, count: 23 },
        { timestamp: 1.day.ago.iso8601, count: 22 },
        { timestamp: 2.days.ago.iso8601, count: 21 },
      ]
    }

    post '/readings', params: params, as: :json
    assert_response :unprocessable_entity
  end

  test 'create with missing readings' do
    params = {
      id: @device_id
    }

    post '/readings', params: params, as: :json
    assert_response :unprocessable_entity
  end

  test 'create with no timestamp in reading' do
    params = {
      id: @device_id,
      readings: [
        { count: 23 }
      ]
    }

    post '/readings', params: params, as: :json
    assert_response :unprocessable_entity
  end

  test 'create with no count in reading' do
    params = {
      id: @device_id,
      readings: [
        { timestamp: Time.current.iso8601 }
      ]
    }

    post '/readings', params: params, as: :json
    assert_response :unprocessable_entity
  end

  test 'create with malformed reading' do
    params = {
      id: @device_id,
      readings: 'woot'
    }

    post '/readings', params: params, as: :json
    assert_response :unprocessable_entity
  end

  test 'create with invalid timestamp in reading' do
    params = {
      id: @device_id,
      readings: [
        { timestamp: 'woot', count: 23 }
      ]
    }

    post '/readings', params: params, as: :json
    assert_response :unprocessable_entity
  end

  test 'create with invalid count in reading' do
    params = {
      id: @device_id,
      readings: [
        { timestamp: Time.current.iso8601, count: 'woot' }
      ]
    }

    post '/readings', params: params, as: :json
    assert_response :unprocessable_entity
  end
end

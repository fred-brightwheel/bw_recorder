require 'fileutils'

class ReadingsController < ApplicationController
  DEVICE_DIR = Rails.env.test? ? 'db/test/devices' : 'db/devices'

  before_action :validate_device_id
  before_action :validate_readings
  before_action :validate_readings_format

  def create
    device_path = [DEVICE_DIR, params[:id]].join('/')
    FileUtils.mkdir_p(device_path)

    params[:readings].each do |reading|
      file_path = [device_path, reading[:timestamp]].join('/')
      File.open(file_path, 'w') do |f|
        f.write(reading[:count])
      end
    end

    render json: nil, status: :created
  end

  private

  def validate_device_id
    unless params[:id].present?
      render json: { error: 'missing device id' }, status: :unprocessable_entity
    end
  end

  def validate_readings
    unless params[:readings].present?
      render json: { error: 'missing readings' }, status: :unprocessable_entity
    end 
  end

  def validate_readings_format
    unless params[:readings].is_a?(Array)
      return render json: { error: 'readings must be array' }, status: :unprocessable_entity
    end

    params[:readings].each do |reading|
      count = Integer(reading[:count]) rescue nil
      unless count.present?
        return render json: { error: 'malformed reading count' }, status: :unprocessable_entity
      end

      timestamp = Time.parse(reading[:timestamp]) rescue nil
      unless timestamp.present?
        return render json: { error: 'malformed reading timestamp' }, status: :unprocessable_entity
      end
    end
  end
end

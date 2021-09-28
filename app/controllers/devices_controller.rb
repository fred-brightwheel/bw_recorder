require 'fileutils'

class DevicesController < ApplicationController
  DEVICE_DIR = Rails.env.test? ? 'db/test/devices' : 'db/devices'

  before_action :validate_device_id

  def total_count
    device_path = [DEVICE_DIR, params[:id], '*'].join('/')
    counts = Dir[device_path].collect do |file_path|
      File.open(file_path, 'r') do |f|
        f.read.to_i
      end
    end

    render json: { count: counts.sum }, status: :ok
  end

  def latest_count
    device_path = [DEVICE_DIR, params[:id], '*'].join('/')
    file_path = Dir[device_path].sort.last

    count = nil
    File.open(file_path, 'r') do |f|
      count = f.read.to_i
    end

    render json: { count: count }, status: :ok
  end

  private

  def validate_device_id
    device_path = [DEVICE_DIR, params[:id]].join('/')

    unless Dir.exist?(device_path)
      render json: { error: 'device not found' }, status: :not_found
    end
  end
end

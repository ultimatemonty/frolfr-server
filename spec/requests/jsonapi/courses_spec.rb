require 'spec_helper'

describe Jsonapi::CoursesController do
  describe 'GET show' do
    let(:course) { FactoryGirl.create(:course) }
    before do
      FactoryGirl.create_list(:hole, 3, course: course)
    end

    it 'returns a course' do
      get jsonapi_course_path(course)
      expect(response).to be_ok

      expected_json = {
        'data' => {
          'id' => course.id.to_s,
          'type'=> 'courses',
          'links'=> {
            'self' => "http://www.example.com/jsonapi/courses/#{course.id}"
          },
          'attributes' => {
            'city' => course.city,
            'state' => course.state,
            'name' => course.name,
            'country' => course.country,
            'holes-count' => 3
          },
          'relationships' => {
            'rounds'=> {
              'links' => {
                'self' => 'http://www.example.com/jsonapi/courses/1/relationships/rounds',
                'related'=> 'http://www.example.com/jsonapi/courses/1/rounds'
              }
            }
          }
        }
      }

      expect(json).to eq expected_json
    end
  end

  describe 'GET index' do
    it 'returns courses' do
      courses = FactoryGirl.create_list(:course, 3)

      get jsonapi_courses_path
      expect(response).to be_ok

      expected_ids = json['data'].map { |course_data| course_data['id'].to_i }

      expect(expected_ids).to match_array courses.map(&:id)
    end

    it 'paginates' do
      courses = FactoryGirl.create_list(:course, 15)

      get jsonapi_courses_path
      expect(response).to be_ok

      expected_courses = json['data'].count

      expect(expected_courses).to eq 10

      get jsonapi_courses_path, { page: { number: 2 } }
      expect(response).to be_ok

      expected_courses = json['data'].count

      expect(expected_courses).to eq 5
    end
  end

  describe 'POST create' do
    let!(:course) { FactoryGirl.create(:course) }

    it 'returns a course' do
      headers = { 'Content-Type' => 'application/vnd.api+json' }

      course = FactoryGirl.build(:course)
      hole_count = 3

      request =  {
        'data' => {
          'type'=> 'courses',
          'attributes' => {
            'city' => course.city,
            'state' => course.state,
            'name' => course.name,
            'country' => course.country,
            'hole-count' => hole_count
          }
        }
      }

      expect {
        post jsonapi_courses_path, request.to_json, headers
      }.to change(Course, :count).by(1)

      expect(response).to be_created

      course = Course.last
      expect(hole_count).to eq course.holes.count
    end
  end
end

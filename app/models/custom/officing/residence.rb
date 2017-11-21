require_dependency Rails.root.join('app', 'models', 'officing', 'residence').to_s

class Officing::Residence
  include ActiveModel::Dates

  attr_accessor :user, :officer, :document_number, :document_type, :date_of_birth
  skip_callback :validate, :residence_in_madrid

  validate :allowed_age
  validate :residence_in_las_palmas_gc
  validates :date_of_birth, presence: true

  def initialize(attrs = {})
    self.date_of_birth = parse_date('date_of_birth', attrs)
    self.year_of_birth = self.date_of_birth.year if self.date_of_birth
    attrs = remove_date('date_of_birth', attrs)
    super
    clean_document_number
  end


  def residence_in_las_palmas_gc
    return if errors.any?

    unless residency_valid?
      store_failed_census_call
      errors.add(residency_errors, false)
    end
  end

  def allowed_age
    return if errors[:date_of_birth].any?

    unless allowed_age?
      errors.add(:date_of_birth, I18n.t('verification.residence.new.error_not_allowed_age'))
    end
  end


  private

    def retrieve_census_data
      @census_api_response = CensusCaller.new.call(document_type, document_number, date_of_birth)
    end

    def residency_valid?
      @census_api_response.valid?
    end

    def gender
      # @census_api_response.gender
      '-'
    end

    def district_code
      @census_api_response.district_code
    end

    def residency_errors
      @census_api_response.errors
    end

end

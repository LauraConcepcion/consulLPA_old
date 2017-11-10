require_dependency Rails.root.join('app', 'models', 'verification', 'residence').to_s

class Verification::Residence

  skip_callback :validate, :allowed_age

  validate :postal_code_in_location
  validate :residence_in_location

  def postal_code_in_location
    errors.add(:postal_code, I18n.t('verification.residence.new.error_not_allowed_postal_code')) unless valid_postal_code?
  end

  def residence_in_location
    return if errors.any?

    unless residency_valid?
      errors.add(:residence_in_location, false)
      store_failed_attempt
      Lock.increase_tries(user)
    end
  end

  def geozone
    # TODO: Decide if we get district from web service or form
    return
  end

  def gender
    # TODO: Decide if we get district from web service or form
    return
  end

  private

    def retrieve_census_data
      @census_data = CensusCaller.new.call(document_type, document_number, date_of_birth)
    end

    def valid_postal_code?
      # Example received data '35000-35019,35219'
      postal_codes = [Setting['postal_codes']][0].sub('-','..').split(',')
      postal_codes = postal_codes.map {|i| eval(i) }.map {|i| i.is_a?(Range) ? i.to_a : [i]}.flatten
      postal_code.to_i.in?(postal_codes)
    end

    def residency_valid?
      @census_data.valid?
    end

end

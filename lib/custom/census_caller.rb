require_dependency Rails.root.join('lib', 'census_caller').to_s

class CensusCaller
  def call(document_type, document_number, date_of_birth)
    response = CensusApi.new.call(document_type, document_number, date_of_birth)
    # response = LocalCensus.new.call(document_type, document_number) unless response.valid?
    response
  end
end

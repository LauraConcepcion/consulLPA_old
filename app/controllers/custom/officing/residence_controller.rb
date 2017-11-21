require_dependency Rails.root.join('app', 'controllers', 'officing', 'residence_controller').to_s
class Officing::ResidenceController

  private

    def residence_params
      params.require(:residence).permit(:document_number, :document_type, :date_of_birth)
    end
end

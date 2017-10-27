require_dependency Rails.root.join('app', 'models', 'budget').to_s
class Budget
  def formatted_float(amount)
    ActionController::Base.helpers.number_to_currency(amount,
                                                      precision: 2,
                                                      locale: I18n.default_locale,
                                                      unit: currency_symbol)
  end

  def formatted_heading_price(heading)
    formatted_float(heading_price(heading))
  end

  def formatted_heading_amount_spent(heading)
    formatted_float(amount_spent(heading))
  end
end

